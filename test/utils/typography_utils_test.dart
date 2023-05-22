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
            'fontWeight': '400',
            'lineHeight': '111%',
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
          '      fontFamily: \'MyFont\',\n'
          '      fontWeight: FontWeight.w400,\n'
          '      height: 1.11,\n'
          '      fontSize: 16,\n'
          '      letterSpacing: 0,\n'
          '      decoration: TextDecoration.none,\n'
          '    )');
    });

    test('without any tokens available', () {
      final result = parseTextStyle({}, config: YamlMap.wrap({}));
      expect(result, 'TextStyle()');
    });
  });

  group('Prepare typography tokens', () {});
}
