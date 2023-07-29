import 'package:math_expressions/math_expressions.dart';
import 'package:tuple/tuple.dart';

/// Prepares the tokens by resolving the aliases and solving mathematical
/// expressions.
Map<String, dynamic> prepareTokens(Map<String, dynamic> map) {
  final metadata = map['\$metadata'];
  final List<String> tokenSetOrder =
      List<String>.from(metadata['tokenSetOrder']);

  for (final entry in map.entries) {
    if (!entry.key.startsWith('\$')) {
      final replaced = _resolveAliasesAndMath(
        entry.value,
        tokenSetOrder: tokenSetOrder.toList(),
        globalMap: map,
      );
      map[entry.key] = replaced;
    }
  }
  return map;
}

/// Resolves aliases by looking in `globalMap` for the referenced values and
/// calculates math expressions recursively.
Map<String, dynamic> _resolveAliasesAndMath(
  Map<String, dynamic> map, {
  required List<String> tokenSetOrder,
  required Map<String, dynamic> globalMap,
}) {
  for (final entry in map.entries) {
    final value = entry.value;
    if (value is Map<String, dynamic>) {
      map[entry.key] = _resolveAliasesAndMath(
        value,
        tokenSetOrder: tokenSetOrder,
        globalMap: globalMap,
      );
    } else if (value is String) {
      const regex = r'{([^}]+)}';
      final matches = RegExp(regex).allMatches(value);
      String newValue = value;
      for (final match in matches) {
        final variableName = match.group(1)?.trim();
        String resolvedVariable;
        if (variableName != null) {
          resolvedVariable = _findVariable(
            globalMap,
            tokenSetOrder: tokenSetOrder,
            variableName: variableName,
          );
        } else {
          resolvedVariable = '';
        }
        newValue = newValue.replaceFirst(match.pattern, resolvedVariable);
      }

      // Resolve math expression if possible.
      try {
        newValue = evaluateMathExpression(newValue);
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
Tuple2<String, String> _prepareMathEvaluation(String value) {
  var newValue = value;
  final pxRegex = RegExp(r'\b(\d+(?:\.\d+)?)px\b');
  for (final match in pxRegex.allMatches(value)) {
    newValue = newValue.replaceFirst(match.group(0)!, match.group(1)!);
  }

  final unit = pxRegex.hasMatch(value) ? 'px' : '';

  return Tuple2(unit, newValue);
}

String evaluateMathExpression(String value) {
  final equation = _prepareMathEvaluation(value);

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
dynamic _findVariable(
  Map<String, dynamic> globalMap, {
  required List<String> tokenSetOrder,
  required String variableName,
}) {
  for (final tokenSetName in tokenSetOrder) {
    final tokenSet = globalMap[tokenSetName];
    if (tokenSet != null) {
      final resolvedVariable = _getTokenSetVariable(tokenSet, variableName);
      if (resolvedVariable != null) {
        return resolvedVariable;
      }
    }
  }
  return null;
}

/// Gets and returns a variable in a given `tokenSet`.
dynamic _getTokenSetVariable(
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
