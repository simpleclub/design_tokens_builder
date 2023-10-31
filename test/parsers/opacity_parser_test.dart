import 'package:design_tokens_builder/parsers/opacity_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = OpacityParser();

  test('correct setup', () {
    expect(parser.tokenType, ['opacity']);
    expect(parser.flutterType, 'double');
  });

  group('build value', () {
    test('succeeds', () {
      expect(parser.buildValue('0.42'), '0.42');
    });

    test('succeeds with percentage', () {
      expect(parser.buildValue('42%'), '0.42');
    });

    test('fails', () {
      expect(() => parser.buildValue(400), throwsException);
      expect(() => parser.buildValue('42px'), throwsException);
      expect(() => parser.buildValue('111%'), throwsException);
      expect(() => parser.buildValue('-1%'), throwsException);
      expect(() => parser.buildValue('2'), throwsException);
    });
  });

  group('build lerp', () {
    test('succeeds', () {
      var token = 'someNumber';
      expect(
        parser.buildLerp(token, null),
        'lerpDouble(someNumber, other.someNumber, t) ?? other.someNumber',
      );
    });
  });
}
