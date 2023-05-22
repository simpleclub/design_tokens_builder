import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:design_tokens_builder/utils/string_utils.dart';
import 'package:yaml/yaml.dart';

/// Prepares typography tokens by concatenating nested groups to one key.
///
/// E.g.
/// Token data:
/// ```
/// 'display: {
///   'small': {
///     'value': …
///   }
/// }
/// ```
/// to:
/// ```
/// 'displaySmall': {
///   'value': …
/// }
/// ```
Map<String, dynamic> prepareTypographyTokens(Map<String, dynamic> tokenSet) {
  var tokens = <MapEntry<String, dynamic>>[];

  for (final highLevelEntry in tokenSet.entries) {
    for (final lowLevelEntry in highLevelEntry.value.entries) {
      final key = lowLevelEntry.key as String?;
      tokens.add(MapEntry(
        '${highLevelEntry.key}${key?.toCapitalized() ?? ''}',
        lowLevelEntry.value,
      ));
    }
  }

  return Map<String, dynamic>.fromEntries(tokens);
}

/// Parses the text style and transforms design tokens json values to flutter
/// readable values.
///
/// Returns a string representing a flutter `TextStyle`.
String parseTextStyle(
  Map<String, dynamic> data, {
  required YamlMap config,
  int indentationLevel = 2,
}) {
  final casted = data.cast<String, Map<String, dynamic>>();
  final transformedEntries = casted['value']
      ?.entries
      .map((e) => _transform(e, config: config))
      .where((element) => element != null)
      .toList()
      .cast<MapEntry<String, dynamic>>();
  final content = transformedEntries
      ?.map((e) => '${e.key}: ${e.value}')
      .join(',\n${indentation(level: indentationLevel + 1)}');

  if (content == null) return 'TextStyle()';
  return 'TextStyle(\n${indentation(level: indentationLevel + 1)}$content,\n${indentation(level: indentationLevel)})';
}

MapEntry<String, dynamic>? _transform(
  MapEntry<String, dynamic> data, {
  required YamlMap config,
}) {
  switch (data.key) {
    case 'fontFamily':
      return MapEntry(
          'fontFamily',
          parseFontFamily(
            data.value,
            config: config,
          ));
    case 'fontWeight':
      return MapEntry('fontWeight', tryParseFontWeight(data.value));
    case 'lineHeight':
      return MapEntry('height', tryParsePercentageToDouble(data.value));
    case 'fontSize':
      return MapEntry('fontSize', data.value);
    case 'letterSpacing':
      return MapEntry('letterSpacing', data.value);
    case 'paragraphSpacing':
      return null;
    case 'paragraphIndent':
      return null;
    case 'textCase':
      return null;
    case 'textDecoration':
      return MapEntry('decoration', parseTextDecoration(data.value));
  }

  return null;
}
