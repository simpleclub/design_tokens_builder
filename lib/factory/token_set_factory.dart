import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/factory/extension_factory.dart';
import 'package:design_tokens_builder/factory/flutter_theme_factory.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';
import 'package:design_tokens_builder/utils/string_utils.dart';
import 'package:design_tokens_builder/utils/token_set_utils.dart';
import 'package:tuple/tuple.dart';

/// Generates theming for all available token sets.
///
/// Theming includes:
/// - `ColorScheme`
/// - `TextStyle`
/// - `ThemeData` with all extensions
String buildTokenSet(
  Map<String, dynamic> tokens, {
  required BuilderConfig config,
}) {
  var output = '';

  final tokenSets = getTokenSets(tokens, config: config);
  final sourceSetData = tokens[config.sourceSetName] as Map<String, dynamic>;
  final defaultSys = sourceSetData['sys'] as Map<String, dynamic>;
  for (final tokenSet in tokenSets) {
    final setData = tokens[tokenSet] as Map<String, dynamic>;
    var brightness = _brightness(tokenSet: tokenSet);
    final flutterTheme = buildFlutterTheme(
      tokens,
      setName: tokenSet,
      brightness: brightness,
      config: config,
    );
    // TODO: Generate flutter themes from flutterMappingTheme
    // if (sys != null) {
    //   /// Generate color scheme.
    //   final systemColors = getTokensOfType(
    //     'color',
    //     tokenSetData: sys,
    //     fallbackSetData: defaultSys,
    //   );
    //   if (systemColors.isNotEmpty) {
    //     final colorSchemeValues = systemColors.keys.map(
    //       (key) => '$key: ${_parseAttribute(
    //         sys[key],
    //         config: config,
    //         isConst: false,
    //       )}',
    //     );
    //     colorScheme +=
    //         'ColorScheme get _colorScheme => const ColorScheme.$brightness(\n${indentation(
    //       level: 4,
    //     )}${colorSchemeValues.join(
    //       ',\n${indentation(level: 4)}',
    //     )},\n${indentation(level: 3)});';
    //   }
    //
    //   /// Generate text style.
    //   var systemTextTheme = getTokensOfType(
    //     'typography',
    //     tokenSetData: sys,
    //     fallbackSetData: defaultSys,
    //   );
    //   systemTextTheme = prepareTypographyTokens(systemTextTheme);
    //
    //   if (systemTextTheme.isNotEmpty) {
    //     final textThemeValues = systemTextTheme.keys.map(
    //       (key) {
    //         // Add default text style color to style.
    //         final textTheme =
    //             Map.from(systemTextTheme[key]).cast<String, dynamic>();
    //         textTheme['value']['color'] = '_colorScheme.onBackground';
    //         return '$key: ${_parseAttribute(
    //           textTheme,
    //           config: config,
    //           indentationLevel: 4,
    //           isConst: false,
    //         )}';
    //       },
    //     );
    //     textTheme += 'TextTheme get _textTheme => TextTheme(\n${indentation(
    //       level: 4,
    //     )}${textThemeValues.join(
    //       ',\n${indentation(level: 4)}',
    //     )},\n${indentation(level: 3)});';
    //   }
    // }

    final extensions = getExtensions(tokens, config: config);
    // textTheme: _textTheme,
    var themeData = '''@override
  ThemeData get themeData => ThemeData.$brightness().copyWith(
        colorScheme: _colorScheme,
        extensions: [
          ${extensions.keys.map(
              (e) => '${buildExtensionName(
                e,
              )}(\n${indentation(level: 6)}${extensions[e]!.map(
                    (e) => '${e.item1}: ${parseAttribute(
                      e.item2,
                      config: config,
                      indentationLevel: 6,
                    )}',
                  ).join(
                    ',\n${indentation(level: 6)}',
                  )},\n${indentation(level: 5)})',
            ).join(
              ',\n${indentation(level: 4)}',
            )},
        ],
      );''';

    output +=
        '''class ${tokenSet.firstUpperCased}ThemeData with GeneratedThemeData {
  const ${tokenSet.firstUpperCased}ThemeData();

  $flutterTheme

  $themeData
}

''';
  }

  return '$output${generateTokenSetEnum(tokenSets, config: config)}';
}

/// Returns the brightness based on the token set name.
///
/// Returns light if name contains light or Light.
/// Returns dark if name contains dark or Dark.
///
/// Returns light by default.
String _brightness({required tokenSet}) {
  final darkRegex = RegExp(r'\b(\w*)(?:dark|Dark)\w*\b');
  if (darkRegex.hasMatch(tokenSet)) return 'dark';

  return 'light';
}

/// Parses all tokens and parses all attributes to dart readable format.
String buildAttributeMap(
  Map<String, dynamic> global,
  BuilderConfig config, [
  int depth = 1,
]) {
  String recursiveMap(Map<String, dynamic> map, depth) {
    var output = '';
    for (final key in map.keys) {
      final attr = map[key] as Map<String, dynamic>;
      final dynamic value;
      if (attr.keys.contains('value') && attr.keys.contains('type')) {
        value = parseAttribute(attr, config: config, indentationLevel: depth);
      } else {
        value = '{\n${recursiveMap(attr, depth + 1)}${'  ' * depth}}';
      }
      output += '${'  ' * depth}\'$key\': $value,\n';
    }
    return output;
  }

  return '{\n${recursiveMap(global, depth)}}';
}

// String _buildColorScheme({
//   required Map<String, dynamic> setData,
//   required String brightness,
// }) {
//   final mappingTheme =
//   final systemColors = getTokensOfType(
//     'color',
//     tokenSetData: sys,
//     fallbackSetData: defaultSys,
//   );
//   if (systemColors.isNotEmpty) {
//     final colorSchemeValues = systemColors.keys.map(
//           (key) => '$key: ${_parseAttribute(
//         sys[key],
//         config: config,
//         isConst: false,
//       )}',
//     );
//
//     final content = '\n${indentation(
//       level: 4,
//     )}${colorSchemeValues.join(
//       ',\n${indentation(level: 4)}',
//     )},\n${indentation(level: 3)}';
//
//     return
//     'ColorScheme get _colorScheme => const ColorScheme.$brightness($content);';
//
// }

dynamic parseAttribute(
  Map<String, dynamic> attr, {
  required BuilderConfig config,
  int indentationLevel = 2,
  bool isConst = true,
}) {
  final value = attr['value'] as dynamic;
  final type = attr['type'] as String;
  final parser = parserForType(
    type,
    indentationLevel: indentationLevel + 1,
    config: config,
  );

  return parser.parse(value, isConst: isConst);
}

/// Tries to parse a value that looks like `120%` to a double like this `1.2`.
///
/// Returns `null` if parsing failed.
double parsePercentage(dynamic value) {
  if (value is String) {
    final abs = int.tryParse(
      value.split('%').first,
    );
    if (abs != null) {
      return abs / 100;
    }
  }

  throw Exception('Unable to parse percentage value with data: $value');
}

/// Generates an enum with all available token sets.
///
/// If the set contains light it will be set as light themeData.
/// If the set contains dark it will be set as dark themeData.
/// If light or dark is not in the set name the first set is chosen.
///
/// E.g.
/// ```
/// // tokenSets = ['light', 'dark', 'allyLight'] is transformed to:
/// enum GeneratedTokenSet {
///   general(BrightnessAdapted(dark: DarkThemeData(), light: LightThemeData()),
///   ally(BrightnessAdapted(dark: AllyLightThemeData(), light: AllyLightThemeData());
///
///   const GeneratedTokenSet(this.data);
///
///   final BrightnessAdapted<GeneratedThemeData> data;
/// }
/// ```
String generateTokenSetEnum(
  List<String> tokenSets, {
  required BuilderConfig config,
}) {
  var cases = <String>[];
  tokenSets.remove(config.sourceSetName);
  final tokenSetsString = tokenSets.join(',');
  final regex = RegExp(r'\b(\w*)(?:light|dark|Light|Dark)\w*\b');
  final matches = regex.allMatches(tokenSetsString);
  final nonMatchedSets =
      tokenSets.where((set) => !matches.any((match) => match.group(0) == set));

  // List of tuples containing all prefixes for topics.
  // Tuple: (prefix, initial match)
  final prefixes = [
    ...matches.map((match) => Tuple2(match.group(1), match.group(0))),
    ...nonMatchedSets.map((noMatch) => Tuple2(noMatch, noMatch))
  ];

  // A list of all unique prefixes.
  final uniquePrefixes = prefixes.map((e) => e.item1).toSet().toList();

  for (final uniquePrefix in uniquePrefixes) {
    final themeMatches =
        prefixes.where((element) => element.item1 == uniquePrefix);
    final themes =
        themeMatches.map((e) => '${e.item2?.firstUpperCased}ThemeData()');
    final lightTheme = themes.firstWhere(
      (element) => element.contains('Light'),
      orElse: () => themes.first,
    );
    final darkTheme = themes.firstWhere(
      (element) => element.contains('Dark'),
      orElse: () => themes.first,
    );

    final set = (uniquePrefix?.isEmpty ?? true) ? 'general' : uniquePrefix;

    cases.add(
      '$set(BrightnessAdapted(\n${indentation(
        level: 2,
      )}dark: $darkTheme,\n${indentation(
        level: 2,
      )}light: $lightTheme,\n${indentation(level: 1)}))',
    );
  }

  return '''enum GeneratedTokenSet {
  ${cases.join(',\n  ')};

  const GeneratedTokenSet(this.data);

  final BrightnessAdapted<GeneratedThemeData> data;
}''';
}
