import 'package:design_tokens_builder/parsers/font_weight_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = FontWeightParser();

  test('correct setup', () {
    expect(parser.tokenType, ['fontWeights']);
    expect(parser.flutterType, 'FontWeight');
  });

  group('build value', () {
    test('succeeds', () {
      final result = parser.buildValue('400');
      expect(result, 'FontWeight.w400');
    });

    test('fails because of wrong weight', () {
      expect(() => parser.buildValue('420'), throwsException);
    });

    test('fails', () {
      expect(() => parser.buildValue(400), throwsException);
    });
  });
}
