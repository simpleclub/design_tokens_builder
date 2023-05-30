import 'package:design_tokens_builder/parsers/dimension_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = DimensionParser();

  test('correct setup', () {
    expect(parser.tokenType, [
      'sizing',
      'borderWidth',
      'dimension',
    ]);
    expect(parser.flutterType, 'double');
  });

  group('build value', () {
    test('succeeds with px', () {
      final result = parser.buildValue('420px');
      expect(result, '420.0');
    });

    test('succeeds without px', () {
      final result = parser.buildValue('69');
      expect(result, '69.0');
    });

    test('succeeds with floating number', () {
      final result = parser.buildValue('69.0px');
      expect(result, '69.0');
    });

    test('fails', () {
      expect(() => parser.buildValue(1), throwsException);
      expect(() => parser.buildValue('some value'), throwsException);
    });
  });

  group('build lerp', () {
    test('succeeds', () {
      var token = 'someDimension';
      expect(
        parser.buildLerp(token),
        'lerpDouble(someDimension, other.someDimension, t)',
      );
    });
  });
}
