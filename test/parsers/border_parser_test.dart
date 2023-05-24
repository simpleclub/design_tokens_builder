import 'package:design_tokens_builder/parsers/border_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = BorderParser();

  test('correct setup', () {
    expect(parser.tokenType, ['border']);
    expect(parser.flutterType, 'BoxBorder');
  });

  group('build value', () {
    test('succeeds', () {
      final map = {
        'color': '#FFFFFF',
        'width': '3',
        'style': 'solid',
      };

      expect(
        parser.buildValue(map),
        'Border.all(\n  width: 3.0,\n  color: const Color(0xFFFFFFFF),\n)',
      );
    });

    test('fails', () {
      final value = 'Wrong value';

      expect(() => parser.parse(value), throwsException);
    });

    test('not supporting dashed style', () {
      final map = {
        'color': '#FFFFFF',
        'width': '3',
        'style': 'dashed',
      };

      expect(() => parser.parse(map), throwsException);
    });
  });
}
