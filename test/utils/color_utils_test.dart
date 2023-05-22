import 'package:design_tokens_builder/utils/color_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Parse color', () {
    test('Parse hex color with #', () {
      final result = parseColor('#00FF00');
      expect(result, 'Color(0xFF00FF00)');
    });

    test('Parse hex color with opacity', () {
      final result = parseColor('#00FF0000');
      expect(result, 'Color(0x0000FF00)');
    });

    test('throwing exception on invalid color', () {
      expect(() => parseColor('Some color'), throwsException);
    });
  });
}
