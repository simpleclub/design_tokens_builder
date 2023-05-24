/// Parses token sets from token data and returns a list of all available tokens
/// sets.
///
/// Removed the default set from the output.
List<String> getTokenSets(
  Map<String, dynamic> tokens, {
  bool includeDefaultSet = false,
}) {
  final tokenSets = List<String>.from(
    (tokens['\$metadata']['tokenSetOrder'] as List).cast<String>(),
  );

  if (!includeDefaultSet) {
    tokenSets.remove('global');
  }

  return tokenSets;
}

/// Overrides and merges the `baseSet` with `withSet`.
Map<String, dynamic> overrideAndMergeTokenSet(
  Map<String, dynamic> baseSet, {
  required Map<String, dynamic> withSet,
}) {
  return baseSet..addAll(withSet);
}

/// Check if `data` has any child that has type `type`.
bool hasNestedType(MapEntry<String, dynamic> data, {required String type}) {
  final value = data.value as Map<String, dynamic>;
  if (value.containsKey('type')) {
    return value['type'] == type;
  }

  return hasNestedType(value.entries.first, type: type);
}

/// Returns a map of all tokens for a specific type.
///
/// When `fallbackSetData` is set `tokenSetData` gets merged and overridden
/// with the provided map.
Map<String, dynamic> getTokensOfType(
  String type, {
  required Map<String, dynamic> tokenSetData,
  Map<String, dynamic>? fallbackSetData,
}) {
  final tokens = Map.fromEntries(
    tokenSetData.entries.where((element) => hasNestedType(element, type: type)),
  );

  if (fallbackSetData != null) {
    final fallbackTokens = Map.fromEntries(
      fallbackSetData.entries
          .where((element) => hasNestedType(element, type: type)),
    );

    return overrideAndMergeTokenSet(fallbackTokens, withSet: tokens);
  }

  return tokens;
}
