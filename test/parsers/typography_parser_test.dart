import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/parsers/typography_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final config = BuilderConfig(
    fontConfig: [
      FontConfig(
        family: 'My Font',
        flutterName: 'MyFlutterFont',
      ),
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
        'letterSpacing': '0.0',
        'color': '#000000',
      };

      expect(
        parser.buildValue(map),
        'TextStyle(\n  fontFamily: \'MyFlutterFont\',\n  fontWeight: FontWeight.w400,\n  height: 1.2,\n  fontSize: 17.0,\n  decoration: TextDecoration.underline,\n  letterSpacing: 0.0,\n  color: const Color(0xFF000000),\n)',
      );
    });

    test('succeeds with package', () {
      final packageConfig = BuilderConfig(
        fontConfig: [
          FontConfig(
            family: 'My Font',
            flutterName: 'MyFlutterFont',
            package: 'my_package',
          ),
        ],
      );
      final packageParser = TypographyParser(1, packageConfig);
      final map = {
        'fontFamily': 'My Font',
        'fontWeight': '400',
        'lineHeight': '120%',
        'fontSize': '17',
        'textDecoration': 'underline',
      };

      expect(
        packageParser.buildValue(map),
        'TextStyle(\n  fontFamily: \'MyFlutterFont\',\n  fontWeight: FontWeight.w400,\n  height: 1.2,\n  fontSize: 17.0,\n  decoration: TextDecoration.underline,\n  package: \'my_package\',\n)',
      );
    });

    test('fails', () {
      final map = {
        'someUnknownKey': '42',
        'fontFamily': 'My Font',
        'fontWeight': '400',
        'lineHeight': '16',
        'fontSize': '17',
      };

      expect(() => parser.buildValue(map), throwsException);
      expect(() => parser.buildValue('Some value'), throwsException);
    });
  });
}
