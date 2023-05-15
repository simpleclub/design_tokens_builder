import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:flutter_test/flutter_test.dart';

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
