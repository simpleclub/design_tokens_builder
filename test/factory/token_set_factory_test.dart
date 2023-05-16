import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('Try parsing pixel', () {
    test('succeeds with px', () {
      final result = tryParsePixel('420px');
      expect(result, 420);
    });

    test('succeeds without px', () {
      final result = tryParsePixel('69');
      expect(result, 69);
    });

    test('fails', () {
      final result = tryParsePixel('example');
      expect(result, null);
    });
  });

  group('Try parsing percentage to double', () {
    test('succeeds with %', () {
      final result = tryParsePercentageToDouble('420%');
      expect(result, 4.2);
    });

    test('succeeds without %', () {
      final result = tryParsePercentageToDouble('69');
      expect(result, 0.69);
    });

    test('fails', () {
      final result = tryParsePercentageToDouble('example');
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
  general(BrightnessAdapted(dark: DarkThemeData(), light: LightThemeData()));

  const GeneratedTokenSet(this.data);

  final BrightnessAdapted<GeneratedThemeData> data;
}''');
    });

    test('with custom token set', () {
      final tokenSets = ['custom'];

      final result = generateTokenSetEnum(tokenSets);
      expect(result, '''enum GeneratedTokenSet {
  general(BrightnessAdapted(dark: CustomThemeData(), light: CustomThemeData()));

  const GeneratedTokenSet(this.data);

  final BrightnessAdapted<GeneratedThemeData> data;
}''');
    });

    test('with two complete sets', () {
      final tokenSets = ['global', 'light', 'dark', 'allyLight', 'allyDark'];

      final result = generateTokenSetEnum(tokenSets);
      expect(result, '''enum GeneratedTokenSet {
  general(BrightnessAdapted(dark: DarkThemeData(), light: LightThemeData())),
  ally(BrightnessAdapted(dark: AllyDarkThemeData(), light: AllyLightThemeData()));

  const GeneratedTokenSet(this.data);

  final BrightnessAdapted<GeneratedThemeData> data;
}''');
    });

    test('with only light theme', () {
      final tokenSets = ['global', 'light'];

      final result = generateTokenSetEnum(tokenSets);
      expect(result, '''enum GeneratedTokenSet {
  general(BrightnessAdapted(dark: LightThemeData(), light: LightThemeData()));

  const GeneratedTokenSet(this.data);

  final BrightnessAdapted<GeneratedThemeData> data;
}''');
    });
  });
}
