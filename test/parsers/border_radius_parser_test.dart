import 'package:design_tokens_builder/parsers/border_radius_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = BorderRadiusParser();

  test('correct setup', () {
    expect(parser.tokenType, ['borderRadius']);
    expect(parser.flutterType, 'BorderRadius');
  });

  group('build value', () {
    test('1 value', () {
      final value = '4px';

      expect(
        parser.buildValue(value),
        'BorderRadius.all(Radius.circular(4.0))',
      );
    });

    test('2 values', () {
      final value = '4px 10';

      expect(
        parser.buildValue(value),
        'BorderRadius.only(topLeft: Radius.circular(4.0), topRight: Radius.circular(10.0), bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(4.0))',
      );
    });

    test('3 values', () {
      final value = '4px 10 2';

      expect(
        parser.buildValue(value),
        'BorderRadius.only(topLeft: Radius.circular(4.0), topRight: Radius.circular(10.0), bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(2.0))',
      );
    });

    test('4 values', () {
      final value = '4px 10 2 5px';

      expect(
        parser.buildValue(value),
        'BorderRadius.only(topLeft: Radius.circular(4.0), topRight: Radius.circular(10.0), bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(2.0))',
      );
    });

    test('fails', () {
      final value = 1;

      expect(() => parser.parse(value), throwsException);
    });

    test('too many values', () {
      final value = '1 2 3 4 5';

      expect(() => parser.parse(value), throwsException);
    });
  });
}
