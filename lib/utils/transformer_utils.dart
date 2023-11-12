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
  for (final entry in map.entries) {
    if (!entry.key.startsWith('\$')) {
      if (entry.key == 'flutterMapping') continue;
      final List<String> tokenSetOrder = getTokenSets(
        map,
        config: config,
        prioritisedSet: entry.key,
        includeSourceSet: true,
      );
      final replaced = resolveAliasesAndMath(
        entry.value,
        tokenSetOrder: tokenSetOrder.toList(),
        sourceMap: map,
      );
      map[entry.key] = replaced;
    }
  }
  return map;
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
            );
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
dynamic findVariable(
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

/// Gets and returns a variable in a given `tokenSet`.
@visibleForTesting
dynamic getTokenSetVariable(
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
  return value['value'];
}
