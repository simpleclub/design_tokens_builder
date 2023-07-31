import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:design_tokens_builder/utils/string_utils.dart';
import 'package:design_tokens_builder/utils/transformer_utils.dart';

String buildFlutterTheme(
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

  return '''
${buildColorScheme(
    allData,
    flutterTokens: flutterTokens,
    setName: setName,
    brightness: brightness,
    config: config,
  )}
  
  ${buildTextTheme(
    allData,
    flutterTokens: flutterTokens,
    setName: setName,
    brightness: brightness,
    config: config,
  )}
  
  ${buildButtonTheme(
    allData,
    flutterTokens: flutterTokens,
    buttonThemeName: 'elevatedButton',
    setName: setName,
    brightness: brightness,
    config: config,
  )}
  
  ${buildButtonTheme(
    allData,
    flutterTokens: flutterTokens,
    buttonThemeName: 'filledButton',
    setName: setName,
    brightness: brightness,
    config: config,
  )}
  
  ${buildButtonTheme(
    allData,
    flutterTokens: flutterTokens,
    buttonThemeName: 'outlinedButton',
    setName: setName,
    brightness: brightness,
    config: config,
  )}
  
  ${buildButtonTheme(
    allData,
    flutterTokens: flutterTokens,
    buttonThemeName: 'textButton',
    setName: setName,
    brightness: brightness,
    config: config,
  )}
''';
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
  final textThemeAttributes = textTheme.entries.map((e) {
    // Add default text style color to style.
    final textStyle = Map.from(e.value).cast<String, dynamic>();
    textStyle['value']['color'] = '_colorScheme.onBackground';
    final attribute = parseAttribute(
      textStyle,
      config: config,
      indentationLevel: 2,
      isConst: false,
    );
    if (attribute == 'null') return '';
    return '${e.key}: $attribute';
  }).whereNot((element) => element == '');

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
    final value = e.value as Map<String, dynamic>;
    var attribute = 'null';
    if (value.containsKey('value')) {
      attribute = parseAttribute(
        e.value,
        config: config,
        indentationLevel: 2,
        isConst: false,
      );
    } else if (value.containsKey('default')) {
      attribute = parseAttribute(
        value['default'],
        config: config,
        indentationLevel: 3,
        isConst: false,
      );

      if (attribute != 'null') {
        attribute = '''MaterialStateProperty.resolveWith((states) {
        return ${attribute};
      })''';
      }
    }

    if (attribute == 'null') return '';
    return '${e.key}: $attribute';
  }).whereNot((element) => element == '');

  final content = buttonThemeAttributes.isNotEmpty
      ? '\n${indentation(level: 2)}style: ButtonStyle(\n${indentation(level: 3)}${buttonThemeAttributes.join(',\n${indentation(level: 3)}')},\n${indentation(level: 2)}),\n${indentation(level: 1)}'
      : '';

  final themeDataName = '${buttonThemeName.firstUpperCased}ThemeData';
  return '$themeDataName get _${buttonThemeName}Theme => $themeDataName($content);';
}
