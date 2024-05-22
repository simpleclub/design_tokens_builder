import 'package:design_tokens_builder/builder_config/builder_config.dart';
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
      },
      'color': {
        'base': {
          'value': '#123456',
          'type': 'color',
        },
      },
    },
    'light': {
      'color': {
        'background': {
          'value': '{color.base}',
          'type': 'color',
        },
        'foreground': {
          'value': '#123456',
          'type': 'color',
        },
      },
      'button': {
        'size': {
          'height': {
            'value': '42px',
            'type': 'dimension',
          },
        },
        'background': {
          'value': '{color.background}',
          'type': 'color',
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
      final result = prepareTokens(
        map,
        config: BuilderConfig(
          tokenSetConfigs: [
            TokenSetConfig(prefix: 'global', type: TokenSetType.source),
          ],
        ),
      );

      expect(result, {
        'core': {
          'metrics': {
            'factor': {
              'value': '2.0',
              'type': 'number',
            },
          },
          'color': {
            'base': {
              'value': '#123456',
              'type': 'color',
            },
          },
        },
        'light': {
          'color': {
            'background': {
              'value': '#123456',
              'type': 'color',
            },
          },
          'button': {
            'size': {
              'height': {
                'value': '42.0px',
                'type': 'dimension',
              },
            },
            'background': {
              'value': '#123456',
              'type': 'color',
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
        'color': {
          'background': {
            'value': '#123456',
            'type': 'color',
          },
        },
        'button': {
          'size': {
            'height': {
              'value': '42.0px',
              'type': 'dimension',
            },
          },
          'background': {
            'value': '#123456',
            'type': 'color',
          },
        },
        'someNumber': {
          'value': '84.0',
          'type': 'number',
        },
      });
    });

    test('succeeds with shadows', () {
      final shadowsMap = {
        'shadow': {
          'value': [
            {
              'x': '0',
              'y': '1',
              'blur': '3',
              'spread': '0',
              'color': '{color.background}',
              'type': 'dropShadow',
            },
            {
              'x': '0',
              'y': '6',
              'blur': '12',
              'spread': '0',
              'color': '{color.background}',
              'type': 'dropShadow',
            },
          ],
          'type': 'boxShadow',
        },
      };

      final result = resolveAliasesAndMath(
        shadowsMap,
        tokenSetOrder: ['core', 'light', 'dark'],
        sourceMap: map,
      );

      expect(result, {
        'shadow': {
          'value': [
            {
              'x': '0.0',
              'y': '1.0',
              'blur': '3.0',
              'spread': '0.0',
              'color': '#123456',
              'type': 'dropShadow',
            },
            {
              'x': '0.0',
              'y': '6.0',
              'blur': '12.0',
              'spread': '0.0',
              'color': '#123456',
              'type': 'dropShadow',
            },
          ],
          'type': 'boxShadow',
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

  group('resolveExtensions', () {
    final map = <String, dynamic>{
      'core': <String, dynamic>{
        'palette': <String, dynamic>{
          'blue': <String, dynamic>{
            'shade50': {'value': '#e6f0ff', 'type': 'color'},
          },
        },
        'color': <String, dynamic>{
          'bg': <String, dynamic>{
            'tag': <String, dynamic>{
              'tonal': <String, dynamic>{
                'blue': <String, dynamic>{
                  'bg': <String, dynamic>{
                    'color': <String, dynamic>{
                      'value': '{color.bg.blue.tonal}',
                      'type': 'color'
                    },
                  },
                },
              },
            },
            'blue': <String, dynamic>{
              'tonal': <String, dynamic>{
                'value': '{color.bg.blue.weak}',
                'type': 'color',
                '\$extensions': <String, dynamic>{
                  'studio.tokens': <String, dynamic>{
                    'modify': <String, dynamic>{
                      'type': 'alpha',
                      'value': '0.1',
                      'space': 'lch'
                    },
                  },
                },
              },
              'weak': <String, dynamic>{
                'value': '{palette.blue.shade100}',
                'type': 'color'
              },
            },
          },
        },
      }
    };

    test('succeeds', () {
      final result = resolveExtensions(
        map,
        tokenSetOrder: ['core', 'light', 'dark'],
        sourceMap: map,
      );

      expect(result, <String, dynamic>{
        'core': <String, dynamic>{
          'palette': <String, dynamic>{
            'blue': <String, dynamic>{
              'shade50': <String, dynamic>{'value': '#e6f0ff', 'type': 'color'},
            },
          },
          'color': <String, dynamic>{
            'bg': <String, dynamic>{
              'tag': <String, dynamic>{
                'tonal': <String, dynamic>{
                  'blue': <String, dynamic>{
                    'bg': <String, dynamic>{
                      'color': <String, dynamic>{
                        'value': '{color.bg.blue.tonal}',
                        'type': 'color',
                        '\$extensions': <String, dynamic>{
                          'studio.tokens': <String, dynamic>{
                            'modify': <String, dynamic>{
                              'type': 'alpha',
                              'value': '0.1',
                              'space': 'lch'
                            },
                          },
                        },
                      },
                    },
                  },
                },
              },
              'blue': <String, dynamic>{
                'tonal': <String, dynamic>{
                  'value': '{color.bg.blue.weak}',
                  'type': 'color',
                  '\$extensions': <String, dynamic>{
                    'studio.tokens': <String, dynamic>{
                      'modify': <String, dynamic>{
                        'type': 'alpha',
                        'value': '0.1',
                        'space': 'lch'
                      },
                    },
                  },
                },
                'weak': <String, dynamic>{
                  'value': '{palette.blue.shade100}',
                  'type': 'color'
                },
              },
            },
          },
        }
      });
    });
  });
}
