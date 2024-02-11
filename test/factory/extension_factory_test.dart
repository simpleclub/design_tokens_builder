import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/factory/theme_extension/model/extension_property_class.dart';
import 'package:design_tokens_builder/factory/theme_extension/model/extension_property_value.dart';
import 'package:design_tokens_builder/factory/theme_extension/theme_extension_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Build extension name', () {
    final result = buildExtensionName('contentColors');
    expect(result, 'ContentColorsThemeExtension');
  });

  group('get extensions', () {
    final config = BuilderConfig(
      tokenSetConfigs: [
        TokenSetConfig(prefix: 'global', type: TokenSetType.source),
      ],
    );

    test('across multiple sets', () {
      final tokens = {
        'global': {
          'button': {
            'height': {
              'value': '38px',
              'type': 'dimension',
            },
          },
          'dimensions': {
            'group': {
              'someDimension': {
                'value': '42px',
                'type': 'dimension',
              },
            },
            'someDimension': {
              'value': '42px',
              'type': 'dimension',
            },
          },
        },
        'light': {
          'button': {
            'color': {
              'value': '#FFFFFF',
              'type': 'color',
            },
          },
        },
        r'$metadata': {
          'tokenSetOrder': [
            'global',
            'light',
          ],
        },
      };

      final result = getExtensions(tokens, config: config);

      expect(
        result,
        [
          ExtensionPropertyClass(
            name: 'button',
            prefixedName: 'button',
            properties: [
              ExtensionPropertyValue(
                name: 'height',
                value: '38px',
                type: 'dimension',
              ),
              ExtensionPropertyValue(
                name: 'color',
                value: '#FFFFFF',
                type: 'color',
              ),
            ],
          ),
          ExtensionPropertyClass(
            name: 'dimensions',
            prefixedName: 'dimensions',
            properties: [
              ExtensionPropertyClass(
                name: 'group',
                prefixedName: 'dimensionsGroup',
                properties: [
                  ExtensionPropertyValue(
                    name: 'someDimension',
                    value: '42px',
                    type: 'dimension',
                  ),
                ],
              ),
              ExtensionPropertyValue(
                name: 'someDimension',
                value: '42px',
                type: 'dimension',
              ),
            ],
          ),
        ],
      );
    });
  });
}
