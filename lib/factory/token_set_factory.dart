import 'package:design_tokens_builder/factory/extension_factory.dart';
import 'package:design_tokens_builder/utils/color_utils.dart';
import 'package:design_tokens_builder/utils/string_utils.dart';
import 'package:design_tokens_builder/utils/token_set_utils.dart';
import 'package:design_tokens_builder/utils/typography_utils.dart';
import 'package:tuple/tuple.dart';
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
    var brightness = _brightness(tokenSet: tokenSet);
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
            'ColorScheme get _colorScheme => const ColorScheme.$brightness(\n${indentation(level: 4)}${colorSchemeValues.join(',\n${indentation(level: 4)}')},\n${indentation(level: 3)});';
      }

      /// Generate text style.
      var systemTextTheme = getTokensOfType(
        'typography',
        tokenSetData: sys,
        fallbackSetData: defaultSys,
      );
      systemTextTheme = prepareTypographyTokens(systemTextTheme);

      if (systemTextTheme.isNotEmpty) {
        final textThemeValues =
            systemTextTheme.keys.map((key) => '$key: ${_parseAttribute(
                  systemTextTheme[key],
                  config: config,
                  indentationLevel: 4,
                )}');
        textTheme +=
            'TextTheme get _textTheme => const TextTheme(\n${indentation(level: 4)}${textThemeValues.join(',\n${indentation(level: 4)}')},\n${indentation(level: 3)});';
      }
    }

    final extensions = getExtensions(tokens);
    var themeData = '''@override
  ThemeData get themeData => ThemeData.$brightness().copyWith(
        colorScheme: _colorScheme,
        textTheme: _textTheme,
        extensions: [
          ${extensions.keys.map((e) => '${buildExtensionName(e)}(\n${indentation(level: 6)}${extensions[e]!.map((e) => '${e.item1}: ${_parseAttribute(e.item2, config: config)}').join(',\n${indentation(level: 6)}')},\n${indentation(level: 5)})').join(',\n${indentation(level: 4)}')},
        ],
      );''';

    output +=
        '''class ${tokenSet.firstUpperCased}ThemeData with GeneratedThemeData {
  const ${tokenSet.firstUpperCased}ThemeData();

  $colorScheme
  
  $textTheme

  $themeData
}

''';
  }

  return '$output${generateTokenSetEnum(tokenSets)}';
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
  YamlMap config, [
  int depth = 1,
]) {
  String recursiveMap(Map<String, dynamic> map, depth) {
    var output = '';
    for (final key in map.keys) {
      final attr = map[key] as Map<String, dynamic>;
      final dynamic value;
      if (attr.keys.contains('value') && attr.keys.contains('type')) {
        value = _parseAttribute(attr, config: config, indentationLevel: depth);
      } else {
        value = '{\n${recursiveMap(attr, depth + 1)}${'  ' * depth}}';
      }
      output += '${'  ' * depth}\'$key\': $value,\n';
    }
    return output;
  }

  return '{\n${recursiveMap(global, depth)}}';
}

dynamic _parseAttribute(
  Map<String, dynamic> attr, {
  required YamlMap config,
  final int indentationLevel = 2,
}) {
  final value = attr['value'] as dynamic;
  switch (attr['type']) {
    case 'color':
      return 'const ${parseColor(attr['value'])}';
    case 'typography':
      return 'const ${parseTextStyle(
        attr,
        config: config,
        indentationLevel: indentationLevel,
      )}';
    case 'fontFamilies':
      return parseFontFamily(value, config: config);
    case 'fontWeights':
      final parsed = tryParseFontWeight(value);
      if (parsed == null) return value;

      return parsed;
    case 'textDecoration':
      return parseTextDecoration(value);
    case 'lineHeights':
    case 'opacity':
      final parsed = tryParsePercentageToDouble(value);
      if (parsed == null) return value;

      return parsed;
    case 'sizing':
    case 'borderWidth':
    case 'dimension':
      final parsed = tryParsePixel(value);
      if (parsed == null) return value;

      return parsed;
    case 'spacing':
      final parsed = tryParseSpacing(value);
      if (parsed == null) return value;

      return 'const $parsed';
    case 'borderRadius':
      final parsed = tryParseBorderRadius(value);
      if (parsed == null) return value;

      return 'const $parsed';
    case 'boxShadow':
      final parsed = tryParseBoxShadow(value);
      if (parsed == null) return value;

      return 'const $parsed';
    case 'border':
      final parsed = tryParseBorder(value);
      if (parsed == null) return value;

      return '$parsed';
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

/// Parses spacing according to
/// [Tokens Studio](https://docs.tokens.studio/available-tokens/spacing-tokens)
/// and returns a string representing Flutters `EdgeInsets`.
String? tryParseSpacing(dynamic value) {
  if (value is String) {
    final spacingValues = value.split(' ');

    switch (spacingValues.length) {
      case 1:
        final space = tryParsePixel(spacingValues[0]) ?? 0;
        return 'EdgeInsets.all($space)';
      case 2:
        final vSpace = tryParsePixel(spacingValues[0]) ?? 0;
        final hSpace = tryParsePixel(spacingValues[1]) ?? 0;

        return 'EdgeInsets.symmetric(vertical: $vSpace, horizontal: $hSpace)';
      case 3:
        final top = tryParsePixel(spacingValues[0]) ?? 0;
        final hSpace = tryParsePixel(spacingValues[1]) ?? 0;
        final bottom = tryParsePixel(spacingValues[2]) ?? 0;

        return 'EdgeInsets.only(top: $top, right: $hSpace, bottom: $bottom, left: $hSpace)';
      case 4:
        final top = tryParsePixel(spacingValues[0]) ?? 0;
        final right = tryParsePixel(spacingValues[1]) ?? 0;
        final bottom = tryParsePixel(spacingValues[2]) ?? 0;
        final left = tryParsePixel(spacingValues[3]) ?? 0;

        return 'EdgeInsets.only(top: $top, right: $right, bottom: $bottom, left: $left)';
      default:
        throw Exception(
            'Cannot parse spacing since there are ${spacingValues.length} values. Please provide 1-4 values.');
    }
  }

  return null;
}

/// Parses border radius according to
/// [Tokens Studio](https://docs.tokens.studio/available-tokens/border-radius-tokens)
/// and returns a string representing Flutters `BorderRadius`.
///
/// Returns `null` if parsing failed.
String? tryParseBorderRadius(dynamic value) {
  String radius(dynamic value) => 'Radius.circular($value)';

  if (value is String) {
    final radiiValues = value.split(' ');

    switch (radiiValues.length) {
      case 1:
        final r = tryParsePixel(radiiValues[0]) ?? 0;
        return 'BorderRadius.all(${radius(r)})';
      case 2:
        final r1 = tryParsePixel(radiiValues[0]) ?? 0;
        final r2 = tryParsePixel(radiiValues[1]) ?? 0;

        return 'BorderRadius.only(topLeft: ${radius(r1)}, topRight: ${radius(r2)}, bottomLeft: ${radius(r2)}, bottomRight: ${radius(r1)})';
      case 3:
        final r1 = tryParsePixel(radiiValues[0]) ?? 0;
        final r2 = tryParsePixel(radiiValues[1]) ?? 0;
        final r3 = tryParsePixel(radiiValues[2]) ?? 0;

        return 'BorderRadius.only(topLeft: ${radius(r1)}, topRight: ${radius(r2)}, bottomLeft: ${radius(r2)}, bottomRight: ${radius(r3)})';
      case 4:
        final r1 = tryParsePixel(radiiValues[0]) ?? 0;
        final r2 = tryParsePixel(radiiValues[1]) ?? 0;
        final r3 = tryParsePixel(radiiValues[2]) ?? 0;
        final r4 = tryParsePixel(radiiValues[3]) ?? 0;

        return 'BorderRadius.only(topLeft: ${radius(r1)}, topRight: ${radius(r2)}, bottomLeft: ${radius(r4)}, bottomRight: ${radius(r3)})';
      default:
        throw Exception(
            'Cannot parse border radius since there are ${radiiValues.length} values. Please provide 1-4 values.');
    }
  }

  return null;
}

/// Tries to parse a value that looks like `120%` to a double like this `1.2`.
///
/// Returns `null` if parsing failed.
double? tryParsePercentageToDouble(dynamic value) {
  // TODO: Add support for doubles here. https://docs.tokens.studio/available-tokens/opacity-tokens
  if (value is String) {
    final abs = int.tryParse(value.split('%').first);
    if (abs != null) {
      return abs / 100;
    }
  }

  return null;
}

/// Parses box shadows according to
/// [Tokens Studio](https://docs.tokens.studio/available-tokens/shadow-tokens)
/// and returns a string representing a Flutter `List<BoxShadow>`.
///
/// Returns `null` if parsing failed.
String? tryParseBoxShadow(dynamic value) {
  String parseShadow(Map<String, dynamic> shadow) {
    final x = tryParsePixel(shadow['x']) ?? 0;
    final y = tryParsePixel(shadow['y']) ?? 0;
    final offset = 'Offset($x, $y)';
    final spread = tryParsePixel(shadow['spread']) ?? 0;
    final color = parseColor(shadow['color']);
    final blur = tryParsePixel(shadow['blur']) ?? 0;
    final style =
        shadow['type'] == 'dropShadow' ? 'BlurStyle.normal' : 'BlurStyle.inner';

    return 'BoxShadow(color: $color, offset: $offset, blurRadius: $blur, spreadRadius: $spread, blurStyle: $style)';
  }

  if (value is Map<String, dynamic>) {
    return '[${parseShadow(value)}]';
  } else if (value is List<dynamic>) {
    var parsedShadows = <String>[];

    for (final shadow in value) {
      parsedShadows.add(parseShadow(shadow));
    }

    return '[${parsedShadows.join(',')}]';
  }

  return null;
}

/// Parses borders according to
/// [Tokens Studio](https://docs.tokens.studio/available-tokens/border-tokens)
/// and returns a string representing a Flutter `Border`.
///
/// Returns `null` if parsing failed.
///
/// Right now we only support solid borders since flutter does support dashed
/// borders by default.
String? tryParseBorder(dynamic value) {
  if (value is Map<String, dynamic>) {
    final color = parseColor(value['color']);
    final width = tryParsePixel(value['width']) ?? 0;

    if (value['style'] == 'dashed') {
      throw Exception(
          'Unable to parse dashed border. Please use solid instead.');
    }

    return 'Border.all(width: $width, color: const $color)';
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
  tokenSets.remove('global');
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
        '$set(BrightnessAdapted(\n${indentation(level: 2)}dark: $darkTheme,\n${indentation(level: 2)}light: $lightTheme,\n${indentation(level: 1)}))');
  }

  return '''enum GeneratedTokenSet {
  ${cases.join(',\n  ')};

  const GeneratedTokenSet(this.data);

  final BrightnessAdapted<GeneratedThemeData> data;
}''';
}
