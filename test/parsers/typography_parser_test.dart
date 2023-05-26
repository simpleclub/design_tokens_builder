import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/parsers/typography_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final config = BuilderConfig(
    tokenFilePath: 'some/path',
    fontConfig: [
      FontConfig(family: 'My Font', flutterName: 'MyFlutterFont'),
    ],
  );
  final parser = TypographyParser(1, config);

  test('correct setup', () {
    expect(parser.tokenType, ['typography']);
    expect(parser.flutterType, 'TextStyle');
  });

  group('build value', () {
    test('succeeds', () {
      final map = {
        'fontFamily': 'My Font',
        'fontWeight': '400',
        'lineHeight': '120%',
        'fontSize': '17',
        'textDecoration': 'underline',
      };

      expect(
        parser.buildValue(map),
        'TextStyle(\n  fontFamily: \'MyFlutterFont\',\n  fontWeight: FontWeight.w400,\n  height: 1.2,\n  fontSize: 17.0,\n  decoration: TextDecoration.underline,\n)',
      );
    });

    test('fails', () {
      final map = {
        'fontFamily': 'My Font',
        'fontWeight': '400',
        'lineHeight': '16',
        'fontSize': '17',
        'someUnknownKey': '42',
      };

      expect(() => parser.buildValue('Some value'), throwsException);
      expect(() => parser.buildValue(map), throwsException);
    });
  });
}
