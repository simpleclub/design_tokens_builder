import 'package:design_tokens_builder/utils/typography_utils.dart';
import 'package:flutter_test/flutter_test.dart';

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
          'type': 'typography',
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
        'type': 'typography',
      },
    });
  });
}
