import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/factory/extension_factory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuple/tuple.dart';

void main() {
  test('Build extension name', () {
    final result = buildExtensionName('contentColors');
    expect(result, 'ContentColorsThemeExtension');
  });

  group('get extensions', () {
    final config = BuilderConfig();

    test('across multiple sets', () {
      final tokens = {
        'global': {
          'button': {
            'height': {
              'value': '38px',
              'type': 'dimension',
            },
          }
        },
        'light': {
          'button': {
            'color': {
              'value': '#FFFFFF',
              'type': 'color',
            }
          }
        },
        r'$metadata': {
          'tokenSetOrder': [
            'global',
            'light',
          ]
        }
      };

      final result = getExtensions(tokens, config: config);
      expect(result, {
        'button': [
          Tuple2<String, Map<String, dynamic>>('height', {
            'value': '38px',
            'type': 'dimension',
          }),
          Tuple2<String, Map<String, dynamic>>('color', {
            'value': '#FFFFFF',
            'type': 'color',
          }),
        ]
      });
    });
  });
}
