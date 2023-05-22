import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('Try parsing pixel', () {
    test('succeeds with px', () {
      final result = parsePixel('420px');
      expect(result, 420);
    });

    test('succeeds without px', () {
      final result = parsePixel('69');
      expect(result, 69);
    });

    test('fails', () {
      final result = parsePixel('example');
      expect(result, null);
    });
  });

  group('Try parse spacing', () {
    test('All sides', () {
      final result = tryParseSpacing('16px');
      expect(result, 'EdgeInsets.all(16)');
    });

    test('Symmetric sides', () {
      final result = tryParseSpacing('16px 4');
      expect(result, 'EdgeInsets.symmetric(vertical: 16, horizontal: 4)');
    });

    test('Top, horizontal and bottom', () {
      final result = tryParseSpacing('16px 4 0px');
      expect(result, 'EdgeInsets.only(top: 16, right: 4, bottom: 0, left: 4)');
    });

    test('Top, right, bottom and left', () {
      final result = tryParseSpacing('16px 4 0px 8px');
      expect(result, 'EdgeInsets.only(top: 16, right: 4, bottom: 0, left: 8)');
    });

    test('Fails', () {
      expect(() => tryParseSpacing('16px 4 0px 8px 7'), throwsException);
    });
  });

  group('Try parse border radius', () {
    test('All sides', () {
      final result = tryParseBorderRadius('16px');
      expect(result, 'BorderRadius.all(Radius.circular(16))');
    });

    test('top-left-and-bottom-right | top-right-and-bottom-left', () {
      final result = tryParseBorderRadius('16px 4');
      expect(result,
          'BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(4), bottomLeft: Radius.circular(4), bottomRight: Radius.circular(16))');
    });

    test('top-left | top-right-and-bottom-left | bottom-right', () {
      final result = tryParseBorderRadius('16px 4 0px');
      expect(result,
          'BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(4), bottomLeft: Radius.circular(4), bottomRight: Radius.circular(0))');
    });

    test('top-left | top-right | bottom-right | bottom-left', () {
      final result = tryParseBorderRadius('16px 4 0px 8px');
      expect(result,
          'BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(4), bottomLeft: Radius.circular(8), bottomRight: Radius.circular(0))');
    });

    test('Fails', () {
      expect(() => tryParseBorderRadius('16px 4 0px 8px 7'), throwsException);
    });
  });

  group('Try parsing percentage to double', () {
    test('succeeds with %', () {
      final result = parsePercentage('420%');
      expect(result, 4.2);
    });

    test('succeeds without %', () {
      final result = parsePercentage('69');
      expect(result, 0.69);
    });

    test('fails', () {
      final result = parsePercentage('example');
      expect(result, null);
    });
  });

  group('Try parse font weight', () {
    test('succeeds', () {
      final result = tryParseFontWeight('500');
      expect(result, 'FontWeight.w500');
    });

    test('fails because weight is not allowed', () {
      final result = tryParseFontWeight('420');
      expect(result, null);
    });

    test('fails because value is not string', () {
      final result = tryParseFontWeight(500);
      expect(result, null);
    });
  });

  group('Parse text decoration', () {
    test('none succeeds', () {
      final result = parseTextDecoration('none');
      expect(result, 'TextDecoration.none');
    });

    test('underline succeeds', () {
      final result = parseTextDecoration('underline');
      expect(result, 'TextDecoration.underline');
    });

    test('line-through succeeds', () {
      final result = parseTextDecoration('line-through');
      expect(result, 'TextDecoration.lineThrough');
    });

    test('non mappable value returns empty string', () {
      final result = parseTextDecoration('test');
      expect(result, '');
    });
  });

  group('Parse font family', () {
    test('returns mapped flutter name with config', () {
      final config = YamlMap.wrap({
        'fontConfig': [
          {
            'family': 'This is a font',
            'flutterName': 'FlutterFont',
          }
        ],
      });

      final result = parseFontFamily('This is a font', config: config);
      expect(result, '\'FlutterFont\'');
    });

    test('returns value when no fontConfig is available', () {
      final result = parseFontFamily(
        'This is a font',
        config: YamlMap.wrap({}),
      );
      expect(result, '\'This is a font\'');
    });

    test('returns value when font family is not found in config', () {
      final config = YamlMap.wrap({
        'fontConfig': [
          {
            'family': 'This is a font',
            'flutterName': 'FlutterFont',
          }
        ],
      });

      final result = parseFontFamily('Some other font', config: config);
      expect(result, '\'Some other font\'');
    });
  });

  group('Generate token set enum', () {
    test('with light, dark and global token sets', () {
      final tokenSets = ['global', 'light', 'dark'];

      final result = generateTokenSetEnum(tokenSets);
      expect(result, '''enum GeneratedTokenSet {
  general(BrightnessAdapted(
    dark: DarkThemeData(),
    light: LightThemeData(),
  ));

  const GeneratedTokenSet(this.data);

  final BrightnessAdapted<GeneratedThemeData> data;
}''');
    });

    test('with custom token set', () {
      final tokenSets = ['custom'];

      final result = generateTokenSetEnum(tokenSets);
      expect(result, '''enum GeneratedTokenSet {
  custom(BrightnessAdapted(
    dark: CustomThemeData(),
    light: CustomThemeData(),
  ));

  const GeneratedTokenSet(this.data);

  final BrightnessAdapted<GeneratedThemeData> data;
}''');
    });

    test('with two complete sets and custom', () {
      final tokenSets = [
        'global',
        'light',
        'dark',
        'allyLight',
        'allyDark',
        'custom'
      ];

      final result = generateTokenSetEnum(tokenSets);
      expect(result, '''enum GeneratedTokenSet {
  general(BrightnessAdapted(
    dark: DarkThemeData(),
    light: LightThemeData(),
  )),
  ally(BrightnessAdapted(
    dark: AllyDarkThemeData(),
    light: AllyLightThemeData(),
  )),
  custom(BrightnessAdapted(
    dark: CustomThemeData(),
    light: CustomThemeData(),
  ));

  const GeneratedTokenSet(this.data);

  final BrightnessAdapted<GeneratedThemeData> data;
}''');
    });

    test('with only light theme', () {
      final tokenSets = ['global', 'light'];

      final result = generateTokenSetEnum(tokenSets);
      expect(result, '''enum GeneratedTokenSet {
  general(BrightnessAdapted(
    dark: LightThemeData(),
    light: LightThemeData(),
  ));

  const GeneratedTokenSet(this.data);

  final BrightnessAdapted<GeneratedThemeData> data;
}''');
    });
  });
}
