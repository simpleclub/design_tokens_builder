import 'dart:math';

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

      final modifier50 = TokenModifierAlpha(value: 0.58, space: 'lch');
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
  test('gradient degrees to points', () {
    // 0.0 -> bottom center
    expect(
      parser.degreesToPoints(0.0),
      equals([Point(0.0, 1.0), Point(0.0, -1.0)]),
      reason: '0deg',
    );
    // 30.0
    expect(
      parser.degreesToPoints(30.0),
      equals(
        [Point(-0.58, 1.0), Point(0.58, -1.0)],
      ),
      reason: '30deg',
    );
    // 45.0 -> bottom left
    expect(
      parser.degreesToPoints(45.0),
      equals([Point(-1.0, 1.0), Point(1.0, -1.0)]),
      reason: '45deg',
    );
    // 60.0
    expect(
      parser.degreesToPoints(60.0),
      equals([Point(-1.0, 0.58), Point(1.0, -0.58)]),
      reason: '60deg',
    );
    // 90.0 -> center left
    expect(
      parser.degreesToPoints(90.0),
      equals([Point(-1.0, 0.0), Point(1.0, 0.0)]),
      reason: '90deg',
    );
    // 135.0 -> top left
    expect(
      parser.degreesToPoints(135.0),
      equals([Point(-1.0, -1.0), Point(1.0, 1.0)]),
      reason: '135deg',
    );
    // 180.0 -> top center
    expect(
      parser.degreesToPoints(180.0),
      equals([Point(0.0, -1.0), Point(0.0, 1.0)]),
      reason: '180deg',
    );
    // 270.0 -> center right
    expect(
      parser.degreesToPoints(270.0),
      equals([Point(1.0, 0.0), Point(-1.0, 0.0)]),
      reason: '270deg',
    );
    // 360.0 -> bottom center
    expect(
      parser.degreesToPoints(360.0),
      equals([Point(0.0, 1.0), Point(0.0, -1.0)]),
      reason: '0deg',
    );
  });
}
