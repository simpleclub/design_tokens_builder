import 'package:design_tokens_builder/parsers/line_height_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = LineHeightParser();

  test('correct setup', () {
    expect(parser.tokenType, ['lineHeights']);
    expect(parser.flutterType, 'double');
  });

  group('build value', () {
    test('succeeds', () {
      final result = parser.buildValue('16');
      expect(result, '16.0');
    });

    test('succeeds with %', () {
      final result = parser.buildValue('12%');
      expect(result, '0.12');
    });

    test('fails', () {
      expect(() => parser.buildValue(400), throwsException);
      expect(() => parser.buildValue('some value'), throwsException);
    });
  });

  group('build lerp', () {
    test('succeeds', () {
      var token = 'someLineHeight';
      expect(
        parser.buildLerp(token),
        'lerpDouble(someLineHeight, other.someLineHeight, t)',
      );
    });
  });
}
