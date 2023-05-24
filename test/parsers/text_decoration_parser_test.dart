import 'package:design_tokens_builder/parsers/text_decoration_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = TextDecorationParser();

  test('correct setup', () {
    expect(parser.tokenType, ['textDecoration']);
    expect(parser.flutterType, 'TextDecoration');
  });

  group('build value', () {
    test('succeeds', () {
      expect(parser.buildValue('none'), 'TextDecoration.none');
      expect(parser.buildValue('underline'), 'TextDecoration.underline');
      expect(parser.buildValue('line-through'), 'TextDecoration.lineThrough');
    });

    test('fails', () {
      expect(() => parser.buildValue('upperline'), throwsException);
    });
  });

  group('build lerp', () {
    test('succeeds', () {
      var token = 'someTextDecoration';
      expect(parser.buildLerp(token), 'other.someTextDecoration');
    });
  });
}
