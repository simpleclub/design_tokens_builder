import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
      expect(() => parsePercentage('example'), throwsException);
    });
  });

  group('Generate token set enum', () {
    final config = BuilderConfig(
      sourceSetName: 'global',
    );

    test('with light, dark and global token sets', () {
      final tokenSets = ['global', 'light', 'dark'];

      final result = generateTokenSetEnum(tokenSets, config: config);
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

      final result = generateTokenSetEnum(tokenSets, config: config);
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

      final result = generateTokenSetEnum(tokenSets, config: config);
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

      final result = generateTokenSetEnum(tokenSets, config: config);
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
