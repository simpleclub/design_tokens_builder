import 'package:design_tokens_builder/builder_config/builder_config.dart';

/// Parses token sets from token data and returns a list of all available tokens
/// sets.
///
/// Removed the source set and possible flutterMapping from the output.
List<String> getTokenSets(
  Map<String, dynamic> tokens, {
  required BuilderConfig config,
  bool includeSourceSet = false,
  bool includeFlutterMappingSet = false,
  String? prioritisedSet,
}) {
  final tokenSets = List<String>.from(
    (tokens['\$metadata']['tokenSetOrder'] as List).cast<String>(),
  );

  if (!includeSourceSet) {
    tokenSets.remove(config.sourceSetName);
  }

  if (!includeFlutterMappingSet) {
    tokenSets.remove('flutterMapping');
  }

  if (prioritisedSet != null) {
    final setSibling =
        findTokenSetSibling(set: prioritisedSet, tokenSets: tokenSets);
    final prioSets = [
      prioritisedSet,
      if (setSibling != null) setSibling,
    ];

    tokenSets.removeWhere((element) => prioSets.contains(element));

    tokenSets.insertAll(0, prioSets);
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

/// Returns set name without brightness.
///
/// E.g. when the set is called `setLight` it returns `set`.
String tokenSetWithoutBrightness(String set) {
  RegExp exp = RegExp(r'\b(?:light|Light|dark|Dark)\b');
  return set.replaceFirst(exp, '');
}

/// Returns a sibling of a token set.
///
/// Defined as a token set with the same name but different brightness.
/// E.g. `light` and `dark` are siblings as `setLight` and `setDark`.
String? findTokenSetSibling({
  required String set,
  required List<String> tokenSets,
}) {
  final baseName = tokenSetWithoutBrightness(set);
  final siblings = tokenSets
      .where((element) => tokenSetWithoutBrightness(element) == baseName)
      .toList();
  siblings.remove(set);

  return siblings.firstOrNull;
}
