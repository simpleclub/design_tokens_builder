import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/parsers/font_family_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final config = BuilderConfig(
    tokenSetConfigs: [
      TokenSetConfig(prefix: 'global', type: TokenSetType.source),
    ],
    fontConfig: [
      FontConfig(family: 'My Font', flutterName: 'MyFlutterFont'),
    ],
  );
  final parser = FontFamilyParser(1, config);

  test('correct setup', () {
    expect(parser.tokenType, ['fontFamilies']);
    expect(parser.flutterType, 'String');
  });

  group('build value', () {
    test('succeed with font in config', () {
      final result = parser.buildValue('My Font');
      expect(result, '\'MyFlutterFont\'');
    });

    test('returns font if unknown to config', () {
      final result = parser.buildValue('UnknownFont');
      expect(result, '\'UnknownFont\'');
    });

    test('returns font if no config', () {
      final noConfigParser = FontFamilyParser();
      final result = noConfigParser.buildValue('My Font');
      expect(result, '\'My Font\'');
    });
  });

  group('build lerp', () {
    test('succeeds', () {
      var token = 'someFontFamily';
      expect(parser.buildLerp(token, null), 'other.someFontFamily');
    });
  });
}
