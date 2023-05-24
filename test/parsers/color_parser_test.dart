import 'package:design_tokens_builder/parsers/color_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = ColorParser();

  test('correct setup', () {
    expect(parser.tokenType, ['color']);
    expect(parser.flutterType, 'Color');
  });

  group('build value', () {
    test('Parse hex color with #', () {
      final result = parser.buildValue('#00FF00');
      expect(result, 'Color(0xFF00FF00)');
    });

    test('Parse hex color with opacity', () {
      final result = parser.buildValue('#00FF0000');
      expect(result, 'Color(0x0000FF00)');
    });

    test('throwing exception on invalid color', () {
      expect(() => parser.buildValue('Some color'), throwsException);
    });

    test('fails', () {
      expect(() => parser.buildValue(1), throwsException);
    });
  });
}
