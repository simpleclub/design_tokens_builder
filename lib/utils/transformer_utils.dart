import 'package:math_expressions/math_expressions.dart';

Map<String, dynamic> preProcess(Map<String, dynamic> map) {
  final metadata = map['\$metadata'];
  final List<String> tokenSetOrder =
      List<String>.from(metadata['tokenSetOrder']);

  for (final entry in map.entries) {
    if (!entry.key.startsWith('\$')) {
      final replaced = replaceVariables(
        entry.value,
        tokenSetOrder: tokenSetOrder.toList(),
        globalMap: map,
      );
      map[entry.key] = replaced;
    }
  }
  return map;
}

Map<String, dynamic> replaceVariables(
  Map<String, dynamic> map, {
  required List<String> tokenSetOrder,
  required Map<String, dynamic> globalMap,
}) {
  for (final entry in map.entries) {
    final value = entry.value;
    if (value is Map<String, dynamic>) {
      map[entry.key] = replaceVariables(
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
          resolvedVariable = findVariable(
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
        final parser = Parser();
        parser.addFunction(
            'roundTo', (List<double> args) => args.first.round());
        Expression exp = parser.parse(newValue);
        newValue = '${exp.evaluate(EvaluationType.REAL, ContextModel())}';
      } catch (e) {
        // We do not catch anything here since we only want to evaluate
        // mathematical expressions and dont care about anything else.
      }
      map[entry.key] = newValue;
    }
  }

  return map;
}

dynamic findVariable(
  Map<String, dynamic> globalMap, {
  required List<String> tokenSetOrder,
  required String variableName,
}) {
  for (final tokenSetName in tokenSetOrder) {
    final tokenSet = globalMap[tokenSetName];
    if (tokenSet != null) {
      final resolvedVariable = getTokenSetVariable(tokenSet, variableName);
      if (resolvedVariable != null) {
        return resolvedVariable;
      }
    }
  }
  return null;
}

dynamic getTokenSetVariable(
    Map<String, dynamic> tokenSet, String variableName) {
  final path = variableName.split('.');
  dynamic value = tokenSet;
  for (final key in path) {
    if (value == null) {
      return null;
    }

    if (value is Map) {
      value = value[key];
    }
  }
  return value['value'];
}
