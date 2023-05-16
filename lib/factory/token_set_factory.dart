import 'package:design_tokens_builder/factory/extension_factory.dart';
import 'package:design_tokens_builder/utils/color_utils.dart';
import 'package:design_tokens_builder/utils/string_utils.dart';
import 'package:design_tokens_builder/utils/token_set_utils.dart';
import 'package:design_tokens_builder/utils/typography_utils.dart';
import 'package:yaml/yaml.dart';

/// Generates theming for all available token sets.
///
/// Theming includes:
/// - `ColorScheme`
/// - `TextStyle`
/// - `ThemeData` with all extensions
String buildTokenSet(
  Map<String, dynamic> tokens, {
  required YamlMap config,
}) {
  var output = '';

  final tokenSets = getTokenSets(tokens);
  final defaultSetData = tokens['global'] as Map<String, dynamic>;
  final defaultSys = defaultSetData['sys'] as Map<String, dynamic>;
  for (final tokenSet in tokenSets) {
    final setData = tokens[tokenSet] as Map<String, dynamic>;

    var colorScheme = '';
    var textTheme = '';
    final sys = setData.remove('sys') as Map<String, dynamic>?;
    if (sys != null) {
      /// Generate color scheme.
      final systemColors = getTokensOfType(
        'color',
        tokenSetData: sys,
        fallbackSetData: defaultSys,
      );
      if (systemColors.isNotEmpty) {
        final colorSchemeValues = systemColors.keys
            .map((key) => '$key: ${_parseAttribute(sys[key], config: config)}');
        colorScheme +=
            '@override\n  ColorScheme get _colorScheme => const ColorScheme.$tokenSet(\n    ${colorSchemeValues.join(',\n    ')}\n  );';
      }

      /// Generate text style.
      var systemTextTheme = getTokensOfType(
        'typography',
        tokenSetData: sys,
        fallbackSetData: defaultSys,
      );
      systemTextTheme = prepareTypographyTokens(systemTextTheme);

      if (systemTextTheme.isNotEmpty) {
        final textThemeValues = systemTextTheme.keys.map((key) =>
            '$key: ${_parseAttribute(systemTextTheme[key], config: config)}');
        textTheme +=
            '@override\n\tTextTheme get _textTheme => const TextTheme(\n\t\t${textThemeValues.join(',\n\t\t')}\n\t);';
      }
    }

    final extensions = getExtensions(tokens);
    var themeData = '''@override
  ThemeData get themeData => ThemeData.$tokenSet().copyWith(
    colorScheme: _colorScheme,
    textTheme: _textTheme,
    extensions: [
      ${extensions.keys.map((e) => '${e.toCapitalized()}${extensions[e]!.first.item2['type'].toString().toCapitalized()}s(\n        ${extensions[e]!.map((e) => '${e.item1}: const ${_parseAttribute(e.item2, config: config)}').join(',\n        ')}\n      )').join(',\n      ')}
    ],
  );''';

    output +=
        '''class ${tokenSet.toCapitalized()}ThemeData with GeneratedThemeData {
  const ${tokenSet.toCapitalized()}ThemeData();

  $colorScheme
  
  $textTheme

  $themeData
}''';
  }

  return '''$output
  
${generateTokenSetEnum(tokenSets)}''';
}

/// Parses all tokens and parses all attributes to dart readable format.
String buildAttributeMap(
  Map<String, dynamic> global,
  YamlMap config, [
  int depth = 1,
]) {
  String recursiveMap(Map<String, dynamic> map, depth) {
    var output = '';
    for (final key in map.keys) {
      final attr = map[key] as Map<String, dynamic>;
      final dynamic value;
      if (attr.keys.contains('value') && attr.keys.contains('type')) {
        value = _parseAttribute(attr, config: config);
      } else {
        value = '{\n${recursiveMap(attr, depth + 1)}${'  ' * depth}}';
      }
      output += '${'  ' * depth}\'$key\': $value,\n';
    }
    return output;
  }

  return '{\n${recursiveMap(global, depth)}}';
}

dynamic _parseAttribute(Map<String, dynamic> attr, {required YamlMap config}) {
  final value = attr['value'] as dynamic;
  switch (attr['type']) {
    case 'color':
      return parseColor(attr['value']);
    case 'typography':
      return parseTextStyle(attr, config: config);
    case 'fontFamilies':
      return parseFontFamily(value, config: config);
    case 'fontWeights':
      final parsed = tryParseFontWeight(value);
      if (parsed == null) return value;

      return parsed;
    case 'textDecoration':
      return parseTextDecoration(value);
    case 'lineHeights':
      final parsed = tryParsePercentageToDouble(value);
      if (parsed == null) return value;

      return parsed;
    case 'dimension':
      final parsed = tryParsePixel(value);
      if (parsed == null) return value;

      return parsed;
    case 'textCase':
    case 'fontSizes':
    case 'letterSpacing':
    case 'paragraphSpacing':
      final number = double.tryParse(value);
      if (number != null) return number;

      final integer = int.tryParse(value);
      if (integer != null) return integer;

      return '\'$value\'';
    default:
      throw Exception('Unknown attribute type: ${attr['type']}');
  }
}

/// Tries to parse a value that looks like `120px` to a int like this `120`.
///
/// Returns `null` if parsing failed.
int? tryParsePixel(dynamic value) {
  if (value is String) {
    final pixel = int.tryParse(value.split('px').first);
    if (pixel != null) {
      return pixel;
    }
  }

  return null;
}

/// Tries to parse a value that looks like `120%` to a double like this `1.2`.
///
/// Returns `null` if parsing failed.
double? tryParsePercentageToDouble(dynamic value) {
  if (value is String) {
    final abs = int.tryParse(value.split('%').first);
    if (abs != null) {
      return abs / 100;
    }
  }

  return null;
}

/// Try to parse and return a flutter readable font weight.
///
/// If parsing fails returns `null`.
String? tryParseFontWeight(dynamic value) {
  if (value is String) {
    final abs = double.parse(value).toInt();
    final allowedWeights = [100, 200, 300, 400, 500, 600, 700, 800, 900];

    if (allowedWeights.contains(abs)) {
      return 'FontWeight.w$abs';
    }
  }

  return null;
}

/// Try to parse and return a flutter readable text decoration.
///
/// If parsing fails returns `null`.
String parseTextDecoration(String value) {
  switch (value) {
    case 'none':
      return 'TextDecoration.none';
    case 'underline':
      return 'TextDecoration.underline';
    case 'line-through':
      return 'TextDecoration.lineThrough';
    default:
      print('Parse Text Decoration: Unknown value: $value');
      return '';
  }
}

/// Parses and return a flutter readable font family.
///
/// Replaces the font name of the token value with its configured flutter name
/// found in `tokenbuilder.yaml`.
/// Returns `value` if no font config was set in `config`.
String parseFontFamily(dynamic value, {required YamlMap config}) {
  if (config.containsKey('fontConfig')) {
    final mappedFonts = config['fontConfig'] as YamlList;
    if (!mappedFonts.any((element) => element['family'] == value)) {
      return '\'$value\'';
    }

    final currentFont =
        mappedFonts.firstWhere((element) => element['family'] == value);

    return '\'${currentFont['flutterName']}\'';
  }

  return '\'$value\'';
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
String generateTokenSetEnum(List<String> tokenSets) {
  var cases = <String>[];
  final tokenSetsString = tokenSets.join(',');
  final regex = RegExp(r'\b(\w*)(?:light|dark|Light|Dark)\w*\b');
  final matches = regex.allMatches(tokenSetsString);
  final matchSetPrefix = matches.map((e) => e.group(1)).toSet().toList();

  for (final prefix in matchSetPrefix) {
    final themeMatches = matches.where((element) => element.group(1) == prefix);
    final themes =
        themeMatches.map((e) => '${e.group(0)?.firstUpperCased}ThemeData()');
    final lightTheme = themes.firstWhere(
      (element) => element.contains('Light'),
      orElse: () => themes.first,
    );
    final darkTheme = themes.firstWhere(
      (element) => element.contains('Dark'),
      orElse: () => themes.first,
    );

    final set = (prefix?.isEmpty ?? true) ? 'general' : prefix;

    cases.add('$set(BrightnessAdapted(dark: $darkTheme, light: $lightTheme))');
  }

  return '''enum GeneratedTokenSet {
  ${cases.join(',\n  ')};

  const GeneratedTokenSet(this.data);

  final BrightnessAdapted<GeneratedThemeData> data;
}''';
}
