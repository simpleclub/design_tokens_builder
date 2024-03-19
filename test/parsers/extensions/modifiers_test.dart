import 'package:design_tokens_builder/parsers/extensions/modifiers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TokenModifierAlpha', () {
    test('Parsing succeeds', () {
      final json = {
        'type': 'alpha',
        'value': '0',
        'space': 'lch',
      };

      final instance = TokenModifierAlpha.fromMap(json);
      expect(instance, TokenModifierAlpha(value: 0.0, space: 'lch'));
    });
  });
}
