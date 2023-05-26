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
        'EdgeInsets.symmetric(\n  vertical: 4.0,\n  horizontal: 10.0,\n)',
      );
    });

    test('3 values', () {
      final value = '4px 10 2';

      expect(
        parser.buildValue(value),
        'EdgeInsets.only(\n  top: 4.0,\n  right: 10.0,\n  bottom: 2.0,\n  left: 10.0,\n)',
      );
    });

    test('4 values', () {
      final value = '4px 10 2 5px';

      expect(
        parser.buildValue(value),
        'EdgeInsets.only(\n  top: 4.0,\n  right: 10.0,\n  bottom: 2.0,\n  left: 5.0,\n)',
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
