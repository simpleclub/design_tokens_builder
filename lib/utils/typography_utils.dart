import 'package:design_tokens_builder/utils/string_utils.dart';

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
      tokens.add(
        MapEntry(
          '${highLevelEntry.key}${key?.toCapitalized() ?? ''}',
          lowLevelEntry.value,
        ),
      );
    }
  }

  return Map<String, dynamic>.fromEntries(tokens);
}
