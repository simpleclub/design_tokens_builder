import 'package:collection/collection.dart';
import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/utils/string_utils.dart';

/// Parses token sets from token data and returns a list of all available tokens
/// sets.
///
/// Removed the source set and possible flutterMapping from the output.
///
/// If `prioritisedSet` is set, the set will be moved to the front of the list
/// of its TokenSetConfig.
/// If `setType` is set, only the token sets of that type will be returned.
Map<TokenSetConfig, List<String>> getTokenSets(
  Map<String, dynamic> tokens, {
  required BuilderConfig config,
  bool includeSourceSet = false,
  bool includeFlutterMappingSet = false,
  String? prioritisedSet,
  TokenSetType? setType,
}) {
  var tokenSets = <TokenSetConfig, List<String>>{};
  final tokenSetOrder = List<String>.from(
    (tokens['\$metadata']['tokenSetOrder'] as List).cast<String>(),
  );

  final sortedConfigs = config.tokenSetConfigs.sorted((a, b) {
    final prio = a.type.sortPriority.compareTo(b.type.sortPriority);

    if (prio == 0) {
      // Sort by prefix if the type is the same. This prevents the source set
      // which has no prefix to include all available sets.
      return -a.prefix.compareTo(b.prefix);
    }

    return prio;
  });
  for (final tokenSetConfig in sortedConfigs) {
    if (setType != null && tokenSetConfig.type != setType) {
      tokenSetOrder
          .removeWhere((element) => element.startsWith(tokenSetConfig.prefix));
      continue;
    }

    final sets = tokenSetOrder
        .where((element) => element.startsWith(tokenSetConfig.prefix))
        .toList();
    tokenSetOrder
        .removeWhere((element) => element.startsWith(tokenSetConfig.prefix));
    tokenSets[tokenSetConfig] = sets.map((e) {
      if (!(tokenSetConfig.type == TokenSetType.flutter ||
              tokenSetConfig.type == TokenSetType.source) &&
          tokenSetConfig.prefix.isNotEmpty) {
        return e.split(tokenSetConfig.prefix).last.firstLowerCased;
      }

      return e;
    }).toList();
  }

  if (!includeSourceSet) {
    tokenSets.remove(config.sourceSetConfig);
  }

  if (!includeFlutterMappingSet) {
    final flutterMappingSet = tokenSets.entries.firstWhereOrNull(
        (element) => element.key.type == TokenSetType.flutter);
    if (flutterMappingSet != null) {
      tokenSets.remove(flutterMappingSet.key);
    }
  }

  if (prioritisedSet != null) {
    final priority = tokenSets.entries
        .firstWhereOrNull((element) => element.value.contains(prioritisedSet));
    if (priority != null) {
      tokenSets.remove(priority);
      final prioritySets = priority.value;
      prioritySets.remove(prioritisedSet);
      tokenSets[priority.key] = [prioritisedSet, ...prioritySets];
    }
  }

  tokenSets.removeWhere((key, value) => value.isEmpty);

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
