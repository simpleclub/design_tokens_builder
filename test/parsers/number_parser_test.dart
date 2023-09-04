import 'package:design_tokens_builder/parsers/number_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = NumberParser();

  test('correct setup', () {
    expect(parser.tokenType, [
      'fontSizes',
      'letterSpacing',
      'paragraphSpacing',
      'lineHeights',
      'number',
    ]);
    expect(parser.flutterType, 'double');
  });

  group('build value', () {
    test('succeeds', () {
      expect(parser.buildValue('16'), '16.0');
      expect(parser.buildValue('16.0'), '16.0');
    });

    test('fails', () {
      expect(() => parser.buildValue(400), throwsException);
      expect(() => parser.buildValue('42px'), throwsException);
    });
  });

  group('build lerp', () {
    test('succeeds', () {
      var token = 'someNumber';
      expect(
        parser.buildLerp(token),
        'lerpDouble(someNumber, other.someNumber, t) ?? other.someNumber',
      );
    });
  });
}
