import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/factory/context_extension_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Build context extensions', () {
    final config = BuilderConfig(
      tokenFilePath: 'some/path',
    );

    test('with one extension', () {
      final result = buildContextExtension(
        {
          'dark': {
            'contentColors': {
              'color1': {'value': '#f8e912', 'type': 'color'},
              'color2': {'value': '#049bf4', 'type': 'color'},
              'color3': {'value': '#ff4600', 'type': 'color'},
              'color4': {'value': '#34af7c', 'type': 'color'},
              'color5': {'value': '#ffb000', 'type': 'color'},
              'color6': {'value': '#9f35a5', 'type': 'color'},
              'color7': {'value': '#73c118', 'type': 'color'},
              'color8': {'value': '#ed0c8d', 'type': 'color'},
              'color9': {'value': '#8800ff', 'type': 'color'},
            },
          },
          '\$metadata': {
            'tokenSetOrder': [
              'dark',
            ],
          },
        },
        config: config,
      );

      expect(result, '''extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  
  ContentColorsThemeExtension get contentColors => theme.extension<ContentColorsThemeExtension>()!;
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
}''');
    });

    test('without extensions', () {
      final result = buildContextExtension(
        {
          'dark': {
            'sys': {
              'primary': {'value': '#f8e912', 'type': 'color'},
            },
          },
          '\$metadata': {
            'tokenSetOrder': [
              'dark',
            ],
          },
        },
        config: config,
      );

      expect(result, '''extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
}''');
    });
  });
}
