import 'package:design_tokens_builder/parsers/color_parser.dart';
import 'package:design_tokens_builder/parsers/extensions/modifiers.dart';
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

    test('Parse hex color with alpha modifier', () {
      final modifier100 = TokenModifierAlpha(value: 1.0, space: 'argb');
      final result100 = parser.buildValue('#000000', modifier: modifier100);
      expect(result100, 'Color(0xFF000000)');

      final modifier50 = TokenModifierAlpha(value: 0.5, space: 'lch');
      final result50 = parser.buildValue('#12345678', modifier: modifier50);
      expect(result50, 'Color(0x80123456)');

      final modifier0 = TokenModifierAlpha(value: 0.0, space: 'argb');
      final result0 = parser.buildValue('#000000FF', modifier: modifier0);
      expect(result0, 'Color(0x00000000)');
    });

    test('throwing exception on invalid color', () {
      expect(() => parser.buildValue('Some color'), throwsException);
    });

    test('fails', () {
      expect(() => parser.buildValue(1), throwsException);
    });
  });
}
