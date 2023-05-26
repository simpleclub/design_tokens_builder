import 'package:design_tokens_builder/parsers/text_case_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = TextCaseParser();

  test('correct setup', () {
    expect(parser.tokenType, ['textCase']);
    expect(parser.flutterType, 'String');
  });

  group('build value', () {
    test('succeeds', () {
      final result = parser.buildValue('uppercase');
      expect(result, '\'uppercase\'');
    });
  });

  group('build lerp', () {
    test('succeeds', () {
      var token = 'someTextCase';
      expect(parser.buildLerp(token), 'other.someTextCase');
    });
  });
}
