import 'package:design_tokens_builder/utils/typography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('Prepare typography tokens', () {
    final result = prepareTypographyTokens({
      'display': {
        'small': {
          'value': {
            'fontFamily': 'Custom Font',
            'fontWeight': 400,
            'lineHeight': 1,
            'fontSize': 16,
            'letterSpacing': 0,
            'paragraphSpacing': 0,
            'paragraphIndent': 0,
            'textCase': 'none',
            'textDecoration': 'none',
          },
          'type': 'typography'
        },
      },
    });

    expect(result, {
      'displaySmall': {
        'value': {
          'fontFamily': 'Custom Font',
          'fontWeight': 400,
          'lineHeight': 1,
          'fontSize': 16,
          'letterSpacing': 0,
          'paragraphSpacing': 0,
          'paragraphIndent': 0,
          'textCase': 'none',
          'textDecoration': 'none',
        },
        'type': 'typography'
      }
    });
  });

  group('Parse text style', () {
    test('Successfully', () {
      final result = parseTextStyle(
        {
          'value': {
            'fontFamily': 'Custom Font',
            'fontWeight': 400,
            'lineHeight': 1,
            'fontSize': 16,
            'letterSpacing': 0,
            'paragraphSpacing': 0,
            'paragraphIndent': 0,
            'textCase': 'none',
            'textDecoration': 'none',
          }
        },
        config: YamlMap.wrap(
          {
            'fontConfig': [
              {
                'family': 'Custom Font',
                'flutterName': 'MyFont',
              },
            ],
          },
        ),
      );

      expect(
          result,
          'TextStyle(\n'
          '\t\t\tfontFamily: \'MyFont\',\n'
          '\t\t\tfontWeight: null,\n'
          '\t\t\theight: null,\n'
          '\t\t\tfontSize: 16,\n'
          '\t\t\tletterSpacing: 0,\n'
          '\t\t\tdecoration: TextDecoration.none\n'
          '\t\t)');
    });

    test('without any tokens available', () {
      final result = parseTextStyle({}, config: YamlMap.wrap({}));
      expect(result, 'TextStyle()');
    });
  });

  group('Prepare typography tokens', () {});
}
