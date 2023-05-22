import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:design_tokens_builder/parsers/color_parser.dart';
import 'package:design_tokens_builder/parsers/font_family_parser.dart';
import 'package:design_tokens_builder/parsers/text_decoration_parser.dart';
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
