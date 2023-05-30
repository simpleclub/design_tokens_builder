import 'package:design_tokens_builder/utils/transformer_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('evaluate math expression', () {
    test('simple equation', () {
      final simple = '3 * 2 + 4';
      expect(evaluateMathExpression(simple), '10.0');
    });

    test('with px', () {
      final simple = '8px * 2';
      expect(evaluateMathExpression(simple), '16.0px');
    });
  });
}
