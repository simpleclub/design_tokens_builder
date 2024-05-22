import 'package:collection/collection.dart';
import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/utils/token_set_utils.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';

/// Prepares the tokens by resolving the aliases and solving mathematical
/// expressions.
Map<String, dynamic> prepareTokens(
  Map<String, dynamic> map, {
  required BuilderConfig config,
}) {
  print('  Resolving extensions… --------------');
  final resolvedMap = resolveExtensions(
    Map.from(_deepCastMap(map)),
    tokenSetOrder: getTokenSets(
      map,
      config: config,
      includeSourceSet: true,
    ).values.flattened.toList(),
    sourceMap: map,
  );

  print('  Resolving aliases and math… --------------');
  for (final entry in resolvedMap.entries) {
    if (!entry.key.startsWith('\$')) {
      if (entry.key == 'flutterMapping') continue;
      final tokenSetOrder = getTokenSets(
        map,
        config: config,
        prioritisedSet: entry.key,
        includeSourceSet: true,
      ).values.flattened;
      print(tokenSetOrder);
      print(resolvedMap);
      final replaced = resolveAliasesAndMath(
        entry.value,
        tokenSetOrder: tokenSetOrder.toList(),
        sourceMap: resolvedMap,
      );
      map[entry.key] = replaced;
    }
  }
  return map;
}

Map<String, dynamic> resolveExtensions(
  Map<String, dynamic> map, {
  required List<String> tokenSetOrder,
  required Map<String, dynamic> sourceMap,
}) {
  for (final entry in map.entries) {
    if (entry.key == 'flutterMapping' ||
        entry.key == '\$themes' ||
        entry.key == '\$metadata') continue;
    final value = entry.value;
    if (value is Map<String, dynamic>) {
      dynamic newValue = value['value'];

      if (newValue == null) {
        map[entry.key] = resolveExtensions(
          value,
          tokenSetOrder: tokenSetOrder,
          sourceMap: sourceMap,
        );
      } else if (value.containsKey('value')) {
        const regex = r'{([^}]+)}';
        if (newValue is String) {
          final matches = RegExp(regex).allMatches(newValue);

          for (final match in matches) {
            final variableName = match.group(1)?.trim();
            if (variableName != null) {
              dynamic extensions = findNearestExtension(
                sourceMap,
                tokenSetOrder: tokenSetOrder,
                variableName: variableName,
              );

              if (extensions != null) {
                var existingMap =
                    Map<String, dynamic>.from(map[entry.key] as Map);
                existingMap['\$extensions'] =
                    extensions as Map<String, dynamic>;
                print(map[entry.key].runtimeType);
                map[entry.key] = existingMap;
              }
            }
          }
        }
      }
    } else if (value is List<dynamic>) {
      map[entry.key] = value.map(
        (e) {
          return resolveExtensions(
            e as Map<String, dynamic>,
            tokenSetOrder: tokenSetOrder,
            sourceMap: sourceMap,
          );
        },
      ).toList();
    }
  }

  return map;
}

Map<String, dynamic> _deepCastMap(dynamic map) {
  if (map is! Map) {
    throw ArgumentError('Provided value must be a Map');
  }

  var castMap = <String, dynamic>{};
  map.forEach((key, value) {
    if (value is Map) {
      // Recursive call to cast nested maps
      castMap[key.toString()] = _deepCastMap(value);
    } else if (value is List) {
      // Recursively cast lists of maps
      castMap[key.toString()] =
          value.map((item) => item is Map ? _deepCastMap(item) : item).toList();
    } else {
      // Assign non-Map and non-List values directly
      castMap[key.toString()] = value;
    }
  });
  return castMap;
}

/// Resolves aliases by looking in [sourceMap] for the referenced values and
/// calculates math expressions recursively.
Map<String, dynamic> resolveAliasesAndMath(
  Map<String, dynamic> map, {
  required List<String> tokenSetOrder,
  required Map<String, dynamic> sourceMap,
}) {
  for (final entry in map.entries) {
    final value = entry.value;
    if (value is Map<String, dynamic>) {
      map[entry.key] = resolveAliasesAndMath(
        value,
        tokenSetOrder: tokenSetOrder,
        sourceMap: sourceMap,
      );
    } else if (value is List<dynamic>) {
      map[entry.key] = value.map(
        (e) {
          return resolveAliasesAndMath(
            e,
            tokenSetOrder: tokenSetOrder,
            sourceMap: sourceMap,
          );
        },
      ).toList();
    } else if (value is String) {
      const regex = r'{([^}]+)}';
      dynamic newValue = value;
      while (newValue is String && RegExp(regex).hasMatch(newValue)) {
        final matches = RegExp(regex).allMatches(newValue);

        for (final match in matches) {
          final variableName = match.group(1)?.trim();
          dynamic resolvedVariable;
          if (variableName != null) {
            resolvedVariable = findVariable(
              sourceMap,
              tokenSetOrder: tokenSetOrder,
              variableName: variableName,
            )?.value;
          } else {
            resolvedVariable = '';
          }

          if (resolvedVariable is String) {
            newValue = newValue.replaceFirst(match.pattern, resolvedVariable);
          } else {
            newValue = resolvedVariable;
          }
        }
      }

      // Resolve math expression if possible.
      try {
        if (newValue is String) {
          newValue = evaluateMathExpression(newValue);
        }
      } catch (e) {
        // We do not catch anything here since we only want to evaluate
        // mathematical expressions and don't care about anything else.
      }
      map[entry.key] = newValue;
    }
  }

  return map;
}

/// Returns a tuple with the matching unit and the cleaned equation.
///
/// E.g. 3px + 42 -> (px, 3 + 42)
@visibleForTesting
Tuple2<String, String> prepareMathEvaluation(String value) {
  var newValue = value;
  final pxRegex = RegExp(r'\b(\d+(?:\.\d+)?)px\b');
  for (final match in pxRegex.allMatches(value)) {
    newValue = newValue.replaceFirst(match.group(0)!, match.group(1)!);
  }

  final unit = pxRegex.hasMatch(value) ? 'px' : '';

  return Tuple2(unit, newValue);
}

/// Evaluates a mathematical expression and returns the result.
String evaluateMathExpression(String value) {
  final equation = prepareMathEvaluation(value);

  final parser = Parser();
  // Need to add roundTo method manually since its nothing
  // math_expressions package supports.
  parser.addFunction(
    'roundTo',
    (List<double> args) => args.first.round(),
  );
  Expression exp = parser.parse(equation.item2);
  return '${exp.evaluate(EvaluationType.REAL, ContextModel())}${equation.item1}';
}

/// Finds and returns a value of a variable for a given name in any token set.
@visibleForTesting
({dynamic value, Map<String, dynamic>? extensions})? findVariable(
  Map<String, dynamic> data, {
  required List<String> tokenSetOrder,
  required String variableName,
}) {
  for (final tokenSetName in tokenSetOrder) {
    final tokenSet = data[tokenSetName];
    if (tokenSet != null) {
      final resolvedVariable = getTokenSetVariable(tokenSet, variableName);
      if (resolvedVariable != null) {
        return resolvedVariable;
      }
    }
  }

  return null;
}

@visibleForTesting
Map<String, dynamic>? findNearestExtension(
  Map<String, dynamic> data, {
  required List<String> tokenSetOrder,
  required String variableName,
}) {
  final resolvedVariable = findVariable(data,
      tokenSetOrder: tokenSetOrder, variableName: variableName);
  if (resolvedVariable?.extensions != null) {
    return resolvedVariable?.extensions;
  }

  const regex = r'{([^}]+)}';
  dynamic newValue = resolvedVariable?.value;
  while (newValue is String && RegExp(regex).hasMatch(newValue)) {
    final matches = RegExp(regex).allMatches(newValue);

    for (final match in matches) {
      final variableName = match.group(1)?.trim();
      if (variableName != null) {
        return findNearestExtension(
          data,
          tokenSetOrder: tokenSetOrder,
          variableName: variableName,
        );
      }
    }
  }

  return null;
}

/// Gets and returns a variable in a given `tokenSet`.
@visibleForTesting
({dynamic value, Map<String, dynamic>? extensions})? getTokenSetVariable(
  Map<String, dynamic> tokenSet,
  String variableName,
) {
  final path = variableName.split('.');
  dynamic value = tokenSet;
  for (final key in path) {
    if (value == null) {
      return null;
    }

    if (value is Map) {
      value = value[key];
      if (value == null) return null;
    }
  }
  return (value: value['value'], extensions: value['\$extensions']);
}
