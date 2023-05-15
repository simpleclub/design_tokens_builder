import 'package:design_tokens_builder/utils/color_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parse color', () {
    test('Parse hex color with #', () {
      final result = parseColor('#00FF00');
      expect(result, 'Color.fromRGBO(0, 255, 0, 1.0)');
    });

    test('Parse hex color with opacity', () {
      final result = parseColor('#00FF0000');
      expect(result, 'Color.fromRGBO(0, 255, 0, 0.0)');
    });

    test('failing returns transparent color', () {
      final result = parseColor('Some color');
      expect(result, 'Color(0xFFFF0000)');
    });
  });
}
