import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/factory/extension_factory.dart';
import 'package:flutter_test/flutter_test.dart';

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

      expect(result.values.first.map((e) => e.item1), ['height', 'color']);
      expect(result.values.first.map((e) => e.item2), [{
        'value': '38px',
        'type': 'dimension',
      }, {
        'value': '#FFFFFF',
        'type': 'color',
      }
      ]);
    });
  });
}
