import 'package:design_tokens_builder/parsers/spacing_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = SpacingParser();

  test('correct setup', () {
    expect(parser.tokenType, ['spacing']);
    expect(parser.flutterType, 'EdgeInsets');
  });

  group('build value', () {
    test('1 value', () {
      final value = '4px';

      expect(parser.buildValue(value), 'EdgeInsets.all(4.0)');
    });

    test('2 values', () {
      final value = '4px 10';

      expect(
        parser.buildValue(value),
        'EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0)',
      );
    });

    test('3 values', () {
      final value = '4px 10 2';

      expect(
        parser.buildValue(value),
        'EdgeInsets.only(top: 4.0, right: 10.0, bottom: 2.0, left: 10.0)',
      );
    });

    test('4 values', () {
      final value = '4px 10 2 5px';

      expect(
        parser.buildValue(value),
        'EdgeInsets.only(top: 4.0, right: 10.0, bottom: 2.0, left: 5.0)',
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
