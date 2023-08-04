import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/factory/extension_factory.dart';
import 'package:design_tokens_builder/factory/flutter_theme_factory.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';
import 'package:design_tokens_builder/utils/string_utils.dart';
import 'package:design_tokens_builder/utils/token_set_utils.dart';
import 'package:tuple/tuple.dart';

typedef ParserResultBuilder = String Function(
    Map<String, dynamic> value, dynamic result);

/// Generates theming for all available token sets.
///
/// Theming includes:
/// - `ColorScheme`
/// - `TextStyle`
/// - `ThemeData` with all extensions
String buildTokenSet(Map<String, dynamic> tokens, {
  required BuilderConfig config,
}) {
  print('Build token set');
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

    final extensions = getExtensions(tokens, config: config);
    // textTheme: _textTheme,
    var themeData = '''@override
  ThemeData get themeData => ThemeData.$brightness().copyWith(
        ${flutterTheme.item2.join(',\n${indentation(level: 4)}')},
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

  ${flutterTheme.item1}

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
String buildAttributeMap(Map<String, dynamic> source,
    BuilderConfig config, [
      int depth = 1,
    ]) {
  print('Build attribute map: $source');
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

  return '{\n${recursiveMap(source, depth)}}';
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

dynamic parseAttribute(Map<String, dynamic> attr, {
  required BuilderConfig config,
  int indentationLevel = 2,
  bool isConst = true,
  ParserResultBuilder? resultBuilder,
}) {
  if (attr.containsKey('default')) {
    return parseMaterialStateProperty(
      attr,
      config: config,
      resultBuilder: resultBuilder,
    );
  }
  final value = attr['value'] as dynamic;
  final type = attr['type'] as String;
  final parser = parserForType(
    type,
    indentationLevel: indentationLevel + 1,
    config: config,
  );

  final result = parser.parse(value, isConst: isConst);

  return resultBuilder?.call(attr, result) ?? result;
}

/// Parses the whole token instead of parsing just an attribute of a token.
///
/// Ensures to parse specific shape, complex size and other custom token
/// structures properly.
dynamic parseValue(Map<String, dynamic> value, {
  required BuilderConfig config,
  int indentationLevel = 2,
  bool isConst = true,
  ParserResultBuilder? resultBuilder,
}) {
  final token = value.entries.first;
  if (token.key == ('fixedSize') ||
      token.key == 'maximumSize' ||
      token.key == 'minimumSize') {
    return parseSize(token.value, config: config);
  } else if (token.key == 'shape') {
    return parseShape(value, config: config);
  } else {
    return parseAttribute(
      token.value as Map<String, dynamic>,
      config: config,
      indentationLevel: indentationLevel,
      isConst: isConst,
      resultBuilder: resultBuilder,
    );
  }
}

/// Tries to parse a value that looks like `120%` to a double like this `1.2`.
///
/// Returns `null` if parsing failed.
double parsePercentage(dynamic value) {
  if (value is String) {
    final abs = int.tryParse(
      value
          .split('%')
          .first,
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
String generateTokenSetEnum(List<String> tokenSets, {
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

String parseMaterialStateProperty(Map<String, dynamic> value, {
  required BuilderConfig config,
  ParserResultBuilder? resultBuilder,
}) {
  final defaultValue = value['default'];
  final defaultAttribute = parseAttribute(
    defaultValue,
    config: config,
    indentationLevel: 4,
    resultBuilder: resultBuilder,
  );

  if (defaultAttribute == 'null') {
    return 'null';
  }

  var states = <String>[];

  for (final state
  in value.entries.where((element) => element.key != 'default')) {
    final value = parseAttribute(
      state.value,
      config: config,
      indentationLevel: 4,
      resultBuilder: resultBuilder,
    );
    if (value == 'null') continue;

    final stateContent =
    '''if (states.contains(MaterialState.${state.key
        .firstLowerCased})) {\n${indentation(
        level: 5)}return $value;\n${indentation(level: 4)}}''';
    states.add(stateContent);
  }

  final statesContent = states.isNotEmpty
      ? '${states.join('\n\n${indentation(level: 4)}')}\n\n${indentation(
      level: 4)}'
      : '';

  return '''MaterialStateProperty.resolveWith((states) {
        ${statesContent}return $defaultAttribute;
      })''';
}

String parseSize(Map<String, dynamic> value, {
  required BuilderConfig config,
}) {
  final heightToken = value['height'] as Map<String, dynamic>;
  final widthToken = value['width'] as Map<String, dynamic>;

  List<Tuple2<dynamic, dynamic>> sizes = [];

  if (heightToken.entries.length > 1 && heightToken.containsKey('default')) {
    for (var i = 0; i < heightToken.entries.length; i++) {
      final height =
      heightToken.entries
          .elementAt(i)
          .value as Map<String, dynamic>;
      final width =
      widthToken.entries
          .elementAt(i)
          .value as Map<String, dynamic>;

      sizes.add(
        Tuple2(
          parseAttribute(width, config: config),
          parseAttribute(height, config: config),
        ),
      );
    }
  }

  return parseMaterialStateProperty(
    heightToken,
    config: config,
    resultBuilder: (value, result) {
      final size = sizes.removeAt(0);

      if (size.item1 == 'null' && size.item2 == 'null') {
        return 'null';
      }

      final width = size.item1 == 'null' ? 'double.infinity' : size.item1;
      final height = size.item2 == 'null' ? 'double.infinity' : size.item2;

      return 'const Size($width, $height)';
    },
  );
}

String parseShape(Map<String, dynamic> value, {
  required BuilderConfig config,
}) {
  final shape = value['shape'] as Map<String, dynamic>;

  if (shape.containsKey('borderRadius')) {
    final borderRadius = shape['borderRadius'] as Map<String, dynamic>;

    if (borderRadius.containsKey('default')) {
      final borderRadiusAttribute = parseMaterialStateProperty(
        borderRadius,
        config: config,
        resultBuilder: (value, result) {
          if (result == 'null') {
            return 'null';
          }

          return 'const RoundedRectangleBorder(borderRadius: $result)';
        },
      );

      if (borderRadiusAttribute == 'null') {
        return 'null';
      }

      return borderRadiusAttribute;
    }
  }

  return 'null';
}
