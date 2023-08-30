import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:design_tokens_builder/utils/string_utils.dart';
import 'package:design_tokens_builder/utils/transformer_utils.dart';
import 'package:tuple/tuple.dart';

/// Builds all flutter related theming based on flutter theme.
///
/// Returns a tuple where the first entry consists of the built string and the second of an list of strings representing
/// the list of properties that need to be added to ThemeData constructor.
Tuple2<String, List<String>> buildFlutterTheme(
  Map<String, dynamic> allData, {
  required String setName,
  required String brightness,
  required BuilderConfig config,
}) {
  final data = json.decode(json.encode(allData)) as Map<String, dynamic>;
  final flutterMappingSet = data['flutterMapping'] as Map<String, dynamic>;
  final flutterTokens = resolveAliasesAndMath(
    {...flutterMappingSet},
    tokenSetOrder: [setName, config.sourceSetName],
    sourceMap: data,
  );
  final themeDataPropertyList = <String>[];
  final colorScheme = buildColorScheme(
    allData,
    flutterTokens: flutterTokens,
    setName: setName,
    brightness: brightness,
    config: config,
  );
  addThemeDataProperty(themeDataPropertyList,
      data: colorScheme, themeProperty: 'colorScheme');
  final textTheme = buildTextTheme(
    allData,
    flutterTokens: flutterTokens,
    setName: setName,
    brightness: brightness,
    config: config,
  );
  addThemeDataProperty(themeDataPropertyList,
      data: textTheme, themeProperty: 'textTheme');

  final buttonThemeNames = [
    'elevatedButton',
    'filledButton',
    'outlinedButton',
    'textButton'
  ];
  var buttonThemeList = <String>[];
  for (final buttonThemeName in buttonThemeNames) {
    final data = buildButtonTheme(
      allData,
      flutterTokens: flutterTokens,
      buttonThemeName: buttonThemeName,
      setName: setName,
      brightness: brightness,
      config: config,
    );
    buttonThemeList.add(data);
    final themeProperty = '${buttonThemeName}Theme';
    addThemeDataProperty(themeDataPropertyList,
        data: data, themeProperty: themeProperty);
  }
  final buttonThemes = buttonThemeList
      .where((element) => element.isNotEmpty)
      .join('\n\n${indentation()}');

  final cardTheme = buildCardTheme(
    allData,
    flutterTokens: flutterTokens,
    setName: setName,
    brightness: brightness,
    config: config,
  );
  addThemeDataProperty(themeDataPropertyList,
      data: cardTheme, themeProperty: 'cardTheme');

  final result = '''$colorScheme

  $textTheme

  $buttonThemes

  $cardTheme''';

  return Tuple2(result, themeDataPropertyList);
}

void addThemeDataProperty(List<String> list,
    {required String data, required String themeProperty}) {
  if (data.isNotEmpty) {
    list.add('$themeProperty: _$themeProperty');
  }
}

String buildColorScheme(
  Map<String, dynamic> allData, {
  required Map<String, dynamic> flutterTokens,
  required String setName,
  required String brightness,
  required BuilderConfig config,
}) {
  final colorScheme = flutterTokens['colorScheme'] as Map<String, dynamic>;
  final colorSchemeAttributes = colorScheme.entries.map((e) {
    final attribute = parseAttribute(
      e.value,
      config: config,
      indentationLevel: 2,
      isConst: false,
    );
    if (attribute == 'null') return '';
    return '${e.key}: $attribute';
  }).whereNot((element) => element == '');

  final content = colorSchemeAttributes.isNotEmpty
      ? '\n${indentation(level: 2)}${colorSchemeAttributes.join(',\n${indentation(level: 2)}')},\n${indentation(level: 1)}'
      : '';

  return 'ColorScheme get _colorScheme => const ColorScheme.$brightness($content);';
}

String buildTextTheme(
  Map<String, dynamic> allData, {
  required Map<String, dynamic> flutterTokens,
  required String setName,
  required String brightness,
  required BuilderConfig config,
}) {
  final textTheme = flutterTokens['textTheme'] as Map<String, dynamic>;
  var textThemeAttributes = <String>[];
  for (final entry in textTheme.entries) {
    final textStyle = Map.from(entry.value).cast<String, dynamic>();

    // Ensures that the text style has values and is not empty.
    if (textStyle['value'] is Map<String, dynamic>) {
      textStyle['value']['color'] = '_colorScheme.onBackground';
      final attribute = parseAttribute(
        textStyle,
        config: config,
        indentationLevel: 2,
        isConst: false,
      );

      if (attribute == 'null') continue;
      textThemeAttributes.add('${entry.key}: $attribute');
    }
  }

  final content = textThemeAttributes.isNotEmpty
      ? '\n${indentation(level: 2)}${textThemeAttributes.join(',\n${indentation(level: 2)}')},\n${indentation(level: 1)}'
      : '';

  return '''TextTheme get _textTheme => TextTheme($content);''';
}

String buildButtonTheme(
  Map<String, dynamic> allData, {
  required Map<String, dynamic> flutterTokens,
  required String buttonThemeName,
  required String setName,
  required String brightness,
  required BuilderConfig config,
}) {
  final elevatedButtonTheme =
      flutterTokens[buttonThemeName] as Map<String, dynamic>;
  final buttonThemeAttributes = elevatedButtonTheme.entries.map((e) {
    final value = Map.fromEntries([e]);
    var attribute = 'null';

    String resultBuilder(value, result) {
      if (value['type'] == 'border' && result != 'null') {
        return '$result.top';
      }

      return result;
    }

    attribute = parseValue(
      value,
      config: config,
      indentationLevel: 2,
      resultBuilder: resultBuilder,
    );

    if (attribute == 'null') return '';
    return '${e.key}: $attribute';
  }).whereNot((element) => element == '');

  final content = buttonThemeAttributes.isNotEmpty
      ? '\n${indentation(level: 2)}style: ButtonStyle(\n${indentation(level: 3)}${buttonThemeAttributes.join(',\n${indentation(level: 3)}')},\n${indentation(level: 2)}),\n${indentation(level: 1)}'
      : '';

  final themeDataName = '${buttonThemeName.firstUpperCased}ThemeData';

  if (content.isEmpty) return '';
  return '$themeDataName get _${buttonThemeName}Theme => $themeDataName($content);';
}

String buildCardTheme(
  Map<String, dynamic> allData, {
  required Map<String, dynamic> flutterTokens,
  required String setName,
  required String brightness,
  required BuilderConfig config,
}) {
  final cardTheme = flutterTokens['card'] as Map<String, dynamic>;
  final cardThemeAttributes = cardTheme.entries.map((e) {
    final attribute = parseValue(
      Map.fromEntries([e]),
      config: config,
      indentationLevel: 2,
      isConst: false,
    );
    if (attribute == 'null') return '';
    return '${e.key}: $attribute';
  }).whereNot((element) => element == '');

  final content = cardThemeAttributes.isNotEmpty
      ? '\n${indentation(level: 2)}${cardThemeAttributes.join(',\n${indentation(level: 2)}')},\n${indentation(level: 1)}'
      : '';

  return 'CardTheme get _cardTheme => const CardTheme($content);';
}
