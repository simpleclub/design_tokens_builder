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
    final generalTokenSetConfig =
        TokenSetConfig(prefix: '', type: TokenSetType.themeData);
    final customTokenSetConfig =
        TokenSetConfig(prefix: 'custom', type: TokenSetType.themeData);
    final allyTokenSetConfig = TokenSetConfig(
      prefix: 'ally',
      type: TokenSetType.themeData,
    );
    final config = BuilderConfig(
      tokenSetConfigs: [
        generalTokenSetConfig,
        customTokenSetConfig,
        allyTokenSetConfig,
      ],
    );

    test('with light, dark and global token sets', () {
      final result = generateThemeTokenSetEnum(
        {
          generalTokenSetConfig: ['light', 'dark'],
        },
        config: config,
      );
      expect(result, '''enum ThemeDataTokenSet {
  general(BrightnessAdapted(
    dark: DarkThemeData(),
    light: LightThemeData(),
  ));

  const ThemeDataTokenSet(this.data);

  final BrightnessAdapted<GeneratedThemeData> data;
}''');
    });

    test('with custom token set', () {
      final result = generateThemeTokenSetEnum({
        customTokenSetConfig: ['']
      }, config: config);
      expect(result, '''enum ThemeDataTokenSet {
  custom(BrightnessAdapted(
    dark: CustomThemeData(),
    light: CustomThemeData(),
  ));

  const ThemeDataTokenSet(this.data);

  final BrightnessAdapted<GeneratedThemeData> data;
}''');
    });

    test('with two complete sets and custom', () {
      final result = generateThemeTokenSetEnum(
        {
          generalTokenSetConfig: ['light', 'dark'],
          allyTokenSetConfig: ['light', 'dark'],
          customTokenSetConfig: [''],
        },
        config: config,
      );
      expect(result, '''enum ThemeDataTokenSet {
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

  const ThemeDataTokenSet(this.data);

  final BrightnessAdapted<GeneratedThemeData> data;
}''');
    });

    test('with only light theme', () {
      final tokenSets = ['global', 'light'];

      final result = generateThemeTokenSetEnum(
        {
          generalTokenSetConfig: ['light'],
        },
        config: config,
      );
      expect(result, '''enum ThemeDataTokenSet {
  general(BrightnessAdapted(
    dark: LightThemeData(),
    light: LightThemeData(),
  ));

  const ThemeDataTokenSet(this.data);

  final BrightnessAdapted<GeneratedThemeData> data;
}''');
    });
  });
}
