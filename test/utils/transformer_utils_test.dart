import 'package:design_tokens_builder/utils/transformer_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuple/tuple.dart';

void main() {
  final map = {
    'core': {
      'metrics': {
        'factor': {
          'value': '2',
          'type': 'number',
        },
      }
    },
    'light': {
      'button': {
        'size': {
          'height': {
            'value': '42px',
            'type': 'dimension',
          },
        },
      },
      'someNumber': {
        'value': '42 * {metrics.factor}',
        'type': 'number',
      },
    },
    'dark': {
      'button': {
        'size': {
          'height': {
            'value': '24px',
            'type': 'dimension',
          },
        },
      },
    },
    'flutterMapping': {
      'button.size.height': 'buttonHeight',
    },
    '\$metadata': {
      'tokenSetOrder': ['core', 'light', 'dark', 'flutterMapping'],
    },
  };

  group('prepare tokens', () {
    test('succeeds', () {
      final result = prepareTokens(map);

      expect(result, {
        'core': {
          'metrics': {
            'factor': {
              'value': '2.0',
              'type': 'number',
            },
          }
        },
        'light': {
          'button': {
            'size': {
              'height': {
                'value': '42.0px',
                'type': 'dimension',
              },
            },
          },
          'someNumber': {
            'value': '84.0',
            'type': 'number',
          },
        },
        'dark': {
          'button': {
            'size': {
              'height': {
                'value': '24.0px',
                'type': 'dimension',
              },
            },
          },
        },
        'flutterMapping': {
          'button.size.height': 'buttonHeight',
        },
        '\$metadata': {
          'tokenSetOrder': ['core', 'light', 'dark', 'flutterMapping'],
        },
      });
    });
  });

  group('resolve aliases and math', () {
    test('succeeds', () {
      final result = resolveAliasesAndMath(
        map['light'] as Map<String, dynamic>,
        tokenSetOrder: ['core', 'light', 'dark'],
        sourceMap: map,
      );

      expect(result, {
        'button': {
          'size': {
            'height': {
              'value': '42.0px',
              'type': 'dimension',
            },
          },
        },
        'someNumber': {
          'value': '84.0',
          'type': 'number',
        },
      });
    });
  });

  group('prepare math evaluation', () {
    test(
      'cleaning px succeeds',
      () => expect(prepareMathEvaluation('42px * 3'), Tuple2('px', '42 * 3')),
    );
  });

  group('evaluate math expression', () {
    test('simple equation', () {
      final simple = '3 * 2 + 4';
      expect(evaluateMathExpression(simple), '10.0');
    });

    test('with px', () {
      final simple = '8px * 2';
      expect(evaluateMathExpression(simple), '16.0px');
    });

    test('with roundTo', () {
      final simple = 'roundTo(42.2)';
      expect(evaluateMathExpression(simple), '42');
    });
  });

  group('find variable', () {
    test(
      'light theme value',
      () => expect(
        findVariable(
          map,
          tokenSetOrder: ['light', 'dark'],
          variableName: 'button.size.height',
        ),
        '42.0px',
      ),
    );

    test(
      'dark theme value',
      () => expect(
        findVariable(
          map,
          tokenSetOrder: ['dark', 'light'],
          variableName: 'button.size.height',
        ),
        '24.0px',
      ),
    );

    test(
      'fails',
      () => expect(
        findVariable(
          map,
          tokenSetOrder: ['light', 'dark'],
          variableName: 'button.size.width',
        ),
        null,
      ),
    );
  });

  group('get token set variable', () {
    test('simple', () {
      final map = {
        'height': {
          'value': '42px',
          'type': 'dimension',
        },
      };

      expect(getTokenSetVariable(map, 'height'), '42px');
    });

    test('nested', () {
      final map = {
        'light': {
          'button': {
            'size': {
              'height': {
                'value': '42px',
                'type': 'dimension',
              },
            },
          },
        },
      };

      expect(getTokenSetVariable(map, 'light.button.size.height'), '42px');
    });

    test('fails', () {
      final map = {
        'height': {
          'value': '42px',
          'type': 'dimension',
        },
      };

      expect(getTokenSetVariable(map, 'width'), null);
    });
  });
}
