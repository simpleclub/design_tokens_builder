// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:flutter/material.dart';

final attributes = {
  'white': const Color(0xFFffffff),
  'black': const Color(0xFF293133),
  'fontFamilies': {
    'primary': 'Roboto',
  },
  'fontWeights': {
    '400': FontWeight.w400,
    '600': FontWeight.w600,
    '700': FontWeight.w700,
    '800': FontWeight.w800,
    '900': FontWeight.w900,
  },
  'fontSize': {
    'base': 10.0,
    'scale': 3.0,
    'xs': 10.0,
    'sm': 13.0,
    'md': 16.0,
    'lg': 19.0,
    'xl': 22.0,
    '2xl': 25.0,
    '3xl': 28.0,
    '4xl': 31.0,
    '5xl': 34.0,
    '6xl': 37.0,
  },
  'letterSpacing': {
    '0': 0.0,
    'sm': 0.1,
    'md': 0.25,
    'lg': 0.5,
  },
  'paragraphSpacing': {
    '0': 0.0,
  },
  'sys': {
    'display': {
      'small': const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w900,
        height: 1.1,
        fontSize: 31.0,
        letterSpacing: 0.0,
        decoration: TextDecoration.none,
      ),
      'medium': const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w900,
        height: 1.1,
        fontSize: 34.0,
        letterSpacing: 0.0,
        decoration: TextDecoration.none,
      ),
      'large': const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w900,
        height: 1.1,
        fontSize: 37.0,
        letterSpacing: 0.0,
        decoration: TextDecoration.none,
      ),
    },
    'headline': {
      'small': const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w900,
        height: 1.5,
        fontSize: 22.0,
        letterSpacing: 0.0,
        decoration: TextDecoration.none,
      ),
      'medium': const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w900,
        height: 1.5,
        fontSize: 25.0,
        letterSpacing: 0.0,
        decoration: TextDecoration.none,
      ),
      'large': const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w900,
        height: 1.5,
        fontSize: 28.0,
        letterSpacing: 0.0,
        decoration: TextDecoration.none,
      ),
    },
    'title': {
      'small': const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w800,
        height: 1.5,
        fontSize: 13.0,
        letterSpacing: 0.1,
        decoration: TextDecoration.none,
      ),
      'medium': const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w800,
        height: 1.5,
        fontSize: 16.0,
        letterSpacing: 0.1,
        decoration: TextDecoration.none,
      ),
      'large': const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w800,
        height: 1.5,
        fontSize: 22.0,
        letterSpacing: 0.0,
        decoration: TextDecoration.none,
      ),
    },
    'label': {
      'small': const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w800,
        height: 1.5,
        fontSize: 10.0,
        letterSpacing: 0.5,
        decoration: TextDecoration.none,
      ),
      'medium': const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w800,
        height: 1.5,
        fontSize: 13.0,
        letterSpacing: 0.5,
        decoration: TextDecoration.none,
      ),
      'large': const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w800,
        height: 1.5,
        fontSize: 16.0,
        letterSpacing: 0.1,
        decoration: TextDecoration.none,
      ),
    },
    'body': {
      'small': const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        height: 1.5,
        fontSize: 10.0,
        letterSpacing: 0.5,
        decoration: TextDecoration.none,
      ),
      'medium': const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        height: 1.5,
        fontSize: 13.0,
        letterSpacing: 0.25,
        decoration: TextDecoration.none,
      ),
      'large': const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        height: 1.5,
        fontSize: 16.0,
        letterSpacing: 0.1,
        decoration: TextDecoration.none,
      ),
    },
  },
  'textCase': {
    'none': 'none',
  },
  'textDecoration': {
    'none': TextDecoration.none,
  },
  'paragraphIndent': {
    '0': 0,
  },
  'lineHeights': {
    'xs': 1.1,
    'sm': 1.25,
    'md': 1.5,
  },
  'elevatedButton': {
    'height': 38.0,
    'color': const Color(0xFF3A9BDC),
    'padding': const EdgeInsets.only(top: 1, right: 0, bottom: 3, left: 4),
    'borderRadius': const BorderRadius.all(Radius.circular(0)),
    'shadow': const [BoxShadow(color: Color(0xFF000000), offset: Offset(0, 3), blurRadius: 5, spreadRadius: 0, blurStyle: BlurStyle.normal),BoxShadow(color: Color(0xFF000000), offset: Offset(0, 0), blurRadius: 0, spreadRadius: 0, blurStyle: BlurStyle.inner)],
    'border': Border.all(width: 0, color: const Color(0xFF293133)),
  },
};

abstract class GeneratedThemeData {
  ThemeData get themeData;
}

class BrightnessAdapted<T> {
  const BrightnessAdapted({required this.light, required this.dark});

  final T light;
  final T dark;
}

class DarkThemeData with GeneratedThemeData {
  const DarkThemeData();

  ColorScheme get _colorScheme => const ColorScheme.dark(
        background: const Color(0xFF293133),
        onBackground: const Color(0xFFffffff),
        primary: const Color(0xFF0000FF),
        onPrimary: const Color(0xFFffffff),
      );
  
  TextTheme get _textTheme => const TextTheme(
        displaySmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.1,
          fontSize: 31.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        displayMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.1,
          fontSize: 34.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        displayLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.1,
          fontSize: 37.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        headlineSmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.5,
          fontSize: 22.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        headlineMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.5,
          fontSize: 25.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        headlineLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.5,
          fontSize: 28.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        titleSmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 13.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
        titleMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 16.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
        titleLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 22.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        labelSmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 10.0,
          letterSpacing: 0.5,
          decoration: TextDecoration.none,
        ),
        labelMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 13.0,
          letterSpacing: 0.5,
          decoration: TextDecoration.none,
        ),
        labelLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 16.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
        bodySmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          height: 1.5,
          fontSize: 10.0,
          letterSpacing: 0.5,
          decoration: TextDecoration.none,
        ),
        bodyMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          height: 1.5,
          fontSize: 13.0,
          letterSpacing: 0.25,
          decoration: TextDecoration.none,
        ),
        bodyLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          height: 1.5,
          fontSize: 16.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
      );

  @override
  ThemeData get themeData => ThemeData.dark().copyWith(
        colorScheme: _colorScheme,
        textTheme: _textTheme,
        extensions: [
          FontFamiliesThemeExtension(
            primary: 'Roboto',
          ),
        FontWeightsThemeExtension(
            400: FontWeight.w400,
            600: FontWeight.w600,
            700: FontWeight.w700,
            800: FontWeight.w800,
            900: FontWeight.w900,
          ),
        FontSizeThemeExtension(
            base: 10.0,
            scale: 3.0,
            xs: 10.0,
            sm: 13.0,
            md: 16.0,
            lg: 19.0,
            xl: 22.0,
            2xl: 25.0,
            3xl: 28.0,
            4xl: 31.0,
            5xl: 34.0,
            6xl: 37.0,
          ),
        LetterSpacingThemeExtension(
            0: 0.0,
            sm: 0.1,
            md: 0.25,
            lg: 0.5,
          ),
        ParagraphSpacingThemeExtension(
            0: 0.0,
          ),
        TextCaseThemeExtension(
            none: 'none',
          ),
        TextDecorationThemeExtension(
            none: TextDecoration.none,
          ),
        ParagraphIndentThemeExtension(
            0: 0,
          ),
        LineHeightsThemeExtension(
            xs: 1.1,
            sm: 1.25,
            md: 1.5,
          ),
        ElevatedButtonThemeExtension(
            height: 38.0,
            color: const Color(0xFF3A9BDC),
            padding: const EdgeInsets.only(top: 1, right: 0, bottom: 3, left: 4),
            borderRadius: const BorderRadius.all(Radius.circular(0)),
            shadow: const [BoxShadow(color: Color(0xFF000000), offset: Offset(0, 3), blurRadius: 5, spreadRadius: 0, blurStyle: BlurStyle.normal),BoxShadow(color: Color(0xFF000000), offset: Offset(0, 0), blurRadius: 0, spreadRadius: 0, blurStyle: BlurStyle.inner)],
            border: Border.all(width: 0, color: const Color(0xFF293133)),
          ),
        SpecialColorsThemeExtension(
            color1: const Color(0xFF00FF00),
            color2: const Color(0xFFFF0000),
          ),
        ],
      );
}

class LightThemeData with GeneratedThemeData {
  const LightThemeData();

  ColorScheme get _colorScheme => const ColorScheme.light(
        background: const Color(0xFFffffff),
        onBackground: const Color(0xFF293133),
        primary: const Color(0xFF0000FF),
        onPrimary: const Color(0xFFffffff),
      );
  
  TextTheme get _textTheme => const TextTheme(
        displaySmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.1,
          fontSize: 31.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        displayMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.1,
          fontSize: 34.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        displayLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.1,
          fontSize: 37.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        headlineSmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.5,
          fontSize: 22.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        headlineMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.5,
          fontSize: 25.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        headlineLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.5,
          fontSize: 28.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        titleSmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 13.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
        titleMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 16.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
        titleLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 22.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        labelSmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 10.0,
          letterSpacing: 0.5,
          decoration: TextDecoration.none,
        ),
        labelMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 13.0,
          letterSpacing: 0.5,
          decoration: TextDecoration.none,
        ),
        labelLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 16.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
        bodySmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          height: 1.5,
          fontSize: 10.0,
          letterSpacing: 0.5,
          decoration: TextDecoration.none,
        ),
        bodyMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          height: 1.5,
          fontSize: 13.0,
          letterSpacing: 0.25,
          decoration: TextDecoration.none,
        ),
        bodyLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          height: 1.5,
          fontSize: 16.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
      );

  @override
  ThemeData get themeData => ThemeData.light().copyWith(
        colorScheme: _colorScheme,
        textTheme: _textTheme,
        extensions: [
          FontFamiliesThemeExtension(
            primary: 'Roboto',
          ),
        FontWeightsThemeExtension(
            400: FontWeight.w400,
            600: FontWeight.w600,
            700: FontWeight.w700,
            800: FontWeight.w800,
            900: FontWeight.w900,
          ),
        FontSizeThemeExtension(
            base: 10.0,
            scale: 3.0,
            xs: 10.0,
            sm: 13.0,
            md: 16.0,
            lg: 19.0,
            xl: 22.0,
            2xl: 25.0,
            3xl: 28.0,
            4xl: 31.0,
            5xl: 34.0,
            6xl: 37.0,
          ),
        LetterSpacingThemeExtension(
            0: 0.0,
            sm: 0.1,
            md: 0.25,
            lg: 0.5,
          ),
        ParagraphSpacingThemeExtension(
            0: 0.0,
          ),
        TextCaseThemeExtension(
            none: 'none',
          ),
        TextDecorationThemeExtension(
            none: TextDecoration.none,
          ),
        ParagraphIndentThemeExtension(
            0: 0,
          ),
        LineHeightsThemeExtension(
            xs: 1.1,
            sm: 1.25,
            md: 1.5,
          ),
        ElevatedButtonThemeExtension(
            height: 38.0,
            color: const Color(0xFF3A9BDC),
            padding: const EdgeInsets.only(top: 1, right: 0, bottom: 3, left: 4),
            borderRadius: const BorderRadius.all(Radius.circular(0)),
            shadow: const [BoxShadow(color: Color(0xFF000000), offset: Offset(0, 3), blurRadius: 5, spreadRadius: 0, blurStyle: BlurStyle.normal),BoxShadow(color: Color(0xFF000000), offset: Offset(0, 0), blurRadius: 0, spreadRadius: 0, blurStyle: BlurStyle.inner)],
            border: Border.all(width: 0, color: const Color(0xFF293133)),
          ),
        SpecialColorsThemeExtension(
            color1: const Color(0xFF00FF00),
            color2: const Color(0xFFFF0000),
          ),
        ],
      );
}

class CustomThemeData with GeneratedThemeData {
  const CustomThemeData();

  ColorScheme get _colorScheme => const ColorScheme.light(
        background: const Color(0xFFCBD0CC),
        onBackground: const Color(0xFF293133),
        primary: const Color(0xFFBDECB6),
        onPrimary: const Color(0xFF293133),
      );
  
  TextTheme get _textTheme => const TextTheme(
        displaySmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.1,
          fontSize: 31.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        displayMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.1,
          fontSize: 34.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        displayLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.1,
          fontSize: 37.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        headlineSmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.5,
          fontSize: 22.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        headlineMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.5,
          fontSize: 25.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        headlineLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.5,
          fontSize: 28.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        titleSmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 13.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
        titleMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 16.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
        titleLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 22.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        labelSmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 10.0,
          letterSpacing: 0.5,
          decoration: TextDecoration.none,
        ),
        labelMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 13.0,
          letterSpacing: 0.5,
          decoration: TextDecoration.none,
        ),
        labelLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 16.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
        bodySmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          height: 1.5,
          fontSize: 10.0,
          letterSpacing: 0.5,
          decoration: TextDecoration.none,
        ),
        bodyMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          height: 1.5,
          fontSize: 13.0,
          letterSpacing: 0.25,
          decoration: TextDecoration.none,
        ),
        bodyLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          height: 1.5,
          fontSize: 16.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
      );

  @override
  ThemeData get themeData => ThemeData.light().copyWith(
        colorScheme: _colorScheme,
        textTheme: _textTheme,
        extensions: [
          FontFamiliesThemeExtension(
            primary: 'Roboto',
          ),
        FontWeightsThemeExtension(
            400: FontWeight.w400,
            600: FontWeight.w600,
            700: FontWeight.w700,
            800: FontWeight.w800,
            900: FontWeight.w900,
          ),
        FontSizeThemeExtension(
            base: 10.0,
            scale: 3.0,
            xs: 10.0,
            sm: 13.0,
            md: 16.0,
            lg: 19.0,
            xl: 22.0,
            2xl: 25.0,
            3xl: 28.0,
            4xl: 31.0,
            5xl: 34.0,
            6xl: 37.0,
          ),
        LetterSpacingThemeExtension(
            0: 0.0,
            sm: 0.1,
            md: 0.25,
            lg: 0.5,
          ),
        ParagraphSpacingThemeExtension(
            0: 0.0,
          ),
        TextCaseThemeExtension(
            none: 'none',
          ),
        TextDecorationThemeExtension(
            none: TextDecoration.none,
          ),
        ParagraphIndentThemeExtension(
            0: 0,
          ),
        LineHeightsThemeExtension(
            xs: 1.1,
            sm: 1.25,
            md: 1.5,
          ),
        ElevatedButtonThemeExtension(
            height: 38.0,
            color: const Color(0xFF3A9BDC),
            padding: const EdgeInsets.only(top: 1, right: 0, bottom: 3, left: 4),
            borderRadius: const BorderRadius.all(Radius.circular(0)),
            shadow: const [BoxShadow(color: Color(0xFF000000), offset: Offset(0, 3), blurRadius: 5, spreadRadius: 0, blurStyle: BlurStyle.normal),BoxShadow(color: Color(0xFF000000), offset: Offset(0, 0), blurRadius: 0, spreadRadius: 0, blurStyle: BlurStyle.inner)],
            border: Border.all(width: 0, color: const Color(0xFF293133)),
          ),
        SpecialColorsThemeExtension(
            color1: const Color(0xFF00FF00),
            color2: const Color(0xFFFF0000),
          ),
        ],
      );
}

class PartyLightThemeData with GeneratedThemeData {
  const PartyLightThemeData();

  ColorScheme get _colorScheme => const ColorScheme.light(
        background: const Color(0xFFffffff),
        onBackground: const Color(0xFF293133),
        primary: const Color(0xFFFE0000),
        onPrimary: const Color(0xFFffffff),
      );
  
  TextTheme get _textTheme => const TextTheme(
        displaySmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.1,
          fontSize: 31.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        displayMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.1,
          fontSize: 34.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        displayLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.1,
          fontSize: 37.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        headlineSmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.5,
          fontSize: 22.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        headlineMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.5,
          fontSize: 25.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        headlineLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.5,
          fontSize: 28.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        titleSmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 13.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
        titleMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 16.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
        titleLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 22.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        labelSmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 10.0,
          letterSpacing: 0.5,
          decoration: TextDecoration.none,
        ),
        labelMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 13.0,
          letterSpacing: 0.5,
          decoration: TextDecoration.none,
        ),
        labelLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 16.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
        bodySmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          height: 1.5,
          fontSize: 10.0,
          letterSpacing: 0.5,
          decoration: TextDecoration.none,
        ),
        bodyMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          height: 1.5,
          fontSize: 13.0,
          letterSpacing: 0.25,
          decoration: TextDecoration.none,
        ),
        bodyLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          height: 1.5,
          fontSize: 16.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
      );

  @override
  ThemeData get themeData => ThemeData.light().copyWith(
        colorScheme: _colorScheme,
        textTheme: _textTheme,
        extensions: [
          FontFamiliesThemeExtension(
            primary: 'Roboto',
          ),
        FontWeightsThemeExtension(
            400: FontWeight.w400,
            600: FontWeight.w600,
            700: FontWeight.w700,
            800: FontWeight.w800,
            900: FontWeight.w900,
          ),
        FontSizeThemeExtension(
            base: 10.0,
            scale: 3.0,
            xs: 10.0,
            sm: 13.0,
            md: 16.0,
            lg: 19.0,
            xl: 22.0,
            2xl: 25.0,
            3xl: 28.0,
            4xl: 31.0,
            5xl: 34.0,
            6xl: 37.0,
          ),
        LetterSpacingThemeExtension(
            0: 0.0,
            sm: 0.1,
            md: 0.25,
            lg: 0.5,
          ),
        ParagraphSpacingThemeExtension(
            0: 0.0,
          ),
        TextCaseThemeExtension(
            none: 'none',
          ),
        TextDecorationThemeExtension(
            none: TextDecoration.none,
          ),
        ParagraphIndentThemeExtension(
            0: 0,
          ),
        LineHeightsThemeExtension(
            xs: 1.1,
            sm: 1.25,
            md: 1.5,
          ),
        ElevatedButtonThemeExtension(
            height: 38.0,
            color: const Color(0xFF3A9BDC),
            padding: const EdgeInsets.only(top: 1, right: 0, bottom: 3, left: 4),
            borderRadius: const BorderRadius.all(Radius.circular(0)),
            shadow: const [BoxShadow(color: Color(0xFF000000), offset: Offset(0, 3), blurRadius: 5, spreadRadius: 0, blurStyle: BlurStyle.normal),BoxShadow(color: Color(0xFF000000), offset: Offset(0, 0), blurRadius: 0, spreadRadius: 0, blurStyle: BlurStyle.inner)],
            border: Border.all(width: 0, color: const Color(0xFF293133)),
          ),
        SpecialColorsThemeExtension(
            color1: const Color(0xFF00FF00),
            color2: const Color(0xFFFF0000),
          ),
        ],
      );
}

class PartyDarkThemeData with GeneratedThemeData {
  const PartyDarkThemeData();

  ColorScheme get _colorScheme => const ColorScheme.dark(
        background: const Color(0xFF293133),
        onBackground: const Color(0xFFffffff),
        primary: const Color(0xFFF8F32B),
        onPrimary: const Color(0xFF293133),
      );
  
  TextTheme get _textTheme => const TextTheme(
        displaySmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.1,
          fontSize: 31.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        displayMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.1,
          fontSize: 34.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        displayLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.1,
          fontSize: 37.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        headlineSmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.5,
          fontSize: 22.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        headlineMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.5,
          fontSize: 25.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        headlineLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          height: 1.5,
          fontSize: 28.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        titleSmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 13.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
        titleMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 16.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
        titleLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 22.0,
          letterSpacing: 0.0,
          decoration: TextDecoration.none,
        ),
        labelSmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 10.0,
          letterSpacing: 0.5,
          decoration: TextDecoration.none,
        ),
        labelMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 13.0,
          letterSpacing: 0.5,
          decoration: TextDecoration.none,
        ),
        labelLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          height: 1.5,
          fontSize: 16.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
        bodySmall: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          height: 1.5,
          fontSize: 10.0,
          letterSpacing: 0.5,
          decoration: TextDecoration.none,
        ),
        bodyMedium: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          height: 1.5,
          fontSize: 13.0,
          letterSpacing: 0.25,
          decoration: TextDecoration.none,
        ),
        bodyLarge: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          height: 1.5,
          fontSize: 16.0,
          letterSpacing: 0.1,
          decoration: TextDecoration.none,
        ),
      );

  @override
  ThemeData get themeData => ThemeData.dark().copyWith(
        colorScheme: _colorScheme,
        textTheme: _textTheme,
        extensions: [
          FontFamiliesThemeExtension(
            primary: 'Roboto',
          ),
        FontWeightsThemeExtension(
            400: FontWeight.w400,
            600: FontWeight.w600,
            700: FontWeight.w700,
            800: FontWeight.w800,
            900: FontWeight.w900,
          ),
        FontSizeThemeExtension(
            base: 10.0,
            scale: 3.0,
            xs: 10.0,
            sm: 13.0,
            md: 16.0,
            lg: 19.0,
            xl: 22.0,
            2xl: 25.0,
            3xl: 28.0,
            4xl: 31.0,
            5xl: 34.0,
            6xl: 37.0,
          ),
        LetterSpacingThemeExtension(
            0: 0.0,
            sm: 0.1,
            md: 0.25,
            lg: 0.5,
          ),
        ParagraphSpacingThemeExtension(
            0: 0.0,
          ),
        TextCaseThemeExtension(
            none: 'none',
          ),
        TextDecorationThemeExtension(
            none: TextDecoration.none,
          ),
        ParagraphIndentThemeExtension(
            0: 0,
          ),
        LineHeightsThemeExtension(
            xs: 1.1,
            sm: 1.25,
            md: 1.5,
          ),
        ElevatedButtonThemeExtension(
            height: 38.0,
            color: const Color(0xFF3A9BDC),
            padding: const EdgeInsets.only(top: 1, right: 0, bottom: 3, left: 4),
            borderRadius: const BorderRadius.all(Radius.circular(0)),
            shadow: const [BoxShadow(color: Color(0xFF000000), offset: Offset(0, 3), blurRadius: 5, spreadRadius: 0, blurStyle: BlurStyle.normal),BoxShadow(color: Color(0xFF000000), offset: Offset(0, 0), blurRadius: 0, spreadRadius: 0, blurStyle: BlurStyle.inner)],
            border: Border.all(width: 0, color: const Color(0xFF293133)),
          ),
        SpecialColorsThemeExtension(
            color1: const Color(0xFF00FF00),
            color2: const Color(0xFFFF0000),
          ),
        ],
      );
}

enum GeneratedTokenSet {
  general(BrightnessAdapted(
    dark: DarkThemeData(),
    light: LightThemeData(),
  )),
  party(BrightnessAdapted(
    dark: PartyDarkThemeData(),
    light: PartyLightThemeData(),
  )),
  custom(BrightnessAdapted(
    dark: CustomThemeData(),
    light: CustomThemeData(),
  ));

  const GeneratedTokenSet(this.data);

  final BrightnessAdapted<GeneratedThemeData> data;
}

class FontFamiliesThemeExtension extends ThemeExtension<FontFamiliesThemeExtension> {
  FontFamiliesThemeExtension({
    this.primary,
  });

  final String? primary;

  @override
  FontFamiliesThemeExtension copyWith({
    String? primary,
  }) {
    return FontFamiliesThemeExtension(
      primary: primary ?? this.primary,
    );
  }

  @override
  FontFamiliesThemeExtension lerp(FontFamiliesThemeExtension? other, double t) {
    if (other is! FontFamiliesThemeExtension) {
      return this;
    }
    return FontFamiliesThemeExtension(
      primary: String.lerp(primary, other.primary, t),
    );
  }
}

class FontWeightsThemeExtension extends ThemeExtension<FontWeightsThemeExtension> {
  FontWeightsThemeExtension({
    this.400,
    this.600,
    this.700,
    this.800,
    this.900,
  });

  final FontWeight? 400;
  final FontWeight? 600;
  final FontWeight? 700;
  final FontWeight? 800;
  final FontWeight? 900;

  @override
  FontWeightsThemeExtension copyWith({
    FontWeight? 400,
    FontWeight? 600,
    FontWeight? 700,
    FontWeight? 800,
    FontWeight? 900,
  }) {
    return FontWeightsThemeExtension(
      400: 400 ?? this.400,
      600: 600 ?? this.600,
      700: 700 ?? this.700,
      800: 800 ?? this.800,
      900: 900 ?? this.900,
    );
  }

  @override
  FontWeightsThemeExtension lerp(FontWeightsThemeExtension? other, double t) {
    if (other is! FontWeightsThemeExtension) {
      return this;
    }
    return FontWeightsThemeExtension(
      400: FontWeight.lerp(400, other.400, t),
      600: FontWeight.lerp(600, other.600, t),
      700: FontWeight.lerp(700, other.700, t),
      800: FontWeight.lerp(800, other.800, t),
      900: FontWeight.lerp(900, other.900, t),
    );
  }
}

class FontSizeThemeExtension extends ThemeExtension<FontSizeThemeExtension> {
  FontSizeThemeExtension({
    this.base,
    this.scale,
    this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.2xl,
    this.3xl,
    this.4xl,
    this.5xl,
    this.6xl,
  });

  final double? base;
  final double? scale;
  final double? xs;
  final double? sm;
  final double? md;
  final double? lg;
  final double? xl;
  final double? 2xl;
  final double? 3xl;
  final double? 4xl;
  final double? 5xl;
  final double? 6xl;

  @override
  FontSizeThemeExtension copyWith({
    double? base,
    double? scale,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? 2xl,
    double? 3xl,
    double? 4xl,
    double? 5xl,
    double? 6xl,
  }) {
    return FontSizeThemeExtension(
      base: base ?? this.base,
      scale: scale ?? this.scale,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      2xl: 2xl ?? this.2xl,
      3xl: 3xl ?? this.3xl,
      4xl: 4xl ?? this.4xl,
      5xl: 5xl ?? this.5xl,
      6xl: 6xl ?? this.6xl,
    );
  }

  @override
  FontSizeThemeExtension lerp(FontSizeThemeExtension? other, double t) {
    if (other is! FontSizeThemeExtension) {
      return this;
    }
    return FontSizeThemeExtension(
      base: double.lerp(base, other.base, t),
      scale: double.lerp(scale, other.scale, t),
      xs: double.lerp(xs, other.xs, t),
      sm: double.lerp(sm, other.sm, t),
      md: double.lerp(md, other.md, t),
      lg: double.lerp(lg, other.lg, t),
      xl: double.lerp(xl, other.xl, t),
      2xl: double.lerp(2xl, other.2xl, t),
      3xl: double.lerp(3xl, other.3xl, t),
      4xl: double.lerp(4xl, other.4xl, t),
      5xl: double.lerp(5xl, other.5xl, t),
      6xl: double.lerp(6xl, other.6xl, t),
    );
  }
}

class LetterSpacingThemeExtension extends ThemeExtension<LetterSpacingThemeExtension> {
  LetterSpacingThemeExtension({
    this.0,
    this.sm,
    this.md,
    this.lg,
  });

  final double? 0;
  final double? sm;
  final double? md;
  final double? lg;

  @override
  LetterSpacingThemeExtension copyWith({
    double? 0,
    double? sm,
    double? md,
    double? lg,
  }) {
    return LetterSpacingThemeExtension(
      0: 0 ?? this.0,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
    );
  }

  @override
  LetterSpacingThemeExtension lerp(LetterSpacingThemeExtension? other, double t) {
    if (other is! LetterSpacingThemeExtension) {
      return this;
    }
    return LetterSpacingThemeExtension(
      0: double.lerp(0, other.0, t),
      sm: double.lerp(sm, other.sm, t),
      md: double.lerp(md, other.md, t),
      lg: double.lerp(lg, other.lg, t),
    );
  }
}

class ParagraphSpacingThemeExtension extends ThemeExtension<ParagraphSpacingThemeExtension> {
  ParagraphSpacingThemeExtension({
    this.0,
  });

  final double? 0;

  @override
  ParagraphSpacingThemeExtension copyWith({
    double? 0,
  }) {
    return ParagraphSpacingThemeExtension(
      0: 0 ?? this.0,
    );
  }

  @override
  ParagraphSpacingThemeExtension lerp(ParagraphSpacingThemeExtension? other, double t) {
    if (other is! ParagraphSpacingThemeExtension) {
      return this;
    }
    return ParagraphSpacingThemeExtension(
      0: double.lerp(0, other.0, t),
    );
  }
}

class TextCaseThemeExtension extends ThemeExtension<TextCaseThemeExtension> {
  TextCaseThemeExtension({
    this.none,
  });

  final String? none;

  @override
  TextCaseThemeExtension copyWith({
    String? none,
  }) {
    return TextCaseThemeExtension(
      none: none ?? this.none,
    );
  }

  @override
  TextCaseThemeExtension lerp(TextCaseThemeExtension? other, double t) {
    if (other is! TextCaseThemeExtension) {
      return this;
    }
    return TextCaseThemeExtension(
      none: String.lerp(none, other.none, t),
    );
  }
}

class TextDecorationThemeExtension extends ThemeExtension<TextDecorationThemeExtension> {
  TextDecorationThemeExtension({
    this.none,
  });

  final TextDecoration? none;

  @override
  TextDecorationThemeExtension copyWith({
    TextDecoration? none,
  }) {
    return TextDecorationThemeExtension(
      none: none ?? this.none,
    );
  }

  @override
  TextDecorationThemeExtension lerp(TextDecorationThemeExtension? other, double t) {
    if (other is! TextDecorationThemeExtension) {
      return this;
    }
    return TextDecorationThemeExtension(
      none: TextDecoration.lerp(none, other.none, t),
    );
  }
}

class ParagraphIndentThemeExtension extends ThemeExtension<ParagraphIndentThemeExtension> {
  ParagraphIndentThemeExtension({
    this.0,
  });

  final double? 0;

  @override
  ParagraphIndentThemeExtension copyWith({
    double? 0,
  }) {
    return ParagraphIndentThemeExtension(
      0: 0 ?? this.0,
    );
  }

  @override
  ParagraphIndentThemeExtension lerp(ParagraphIndentThemeExtension? other, double t) {
    if (other is! ParagraphIndentThemeExtension) {
      return this;
    }
    return ParagraphIndentThemeExtension(
      0: double.lerp(0, other.0, t),
    );
  }
}

class LineHeightsThemeExtension extends ThemeExtension<LineHeightsThemeExtension> {
  LineHeightsThemeExtension({
    this.xs,
    this.sm,
    this.md,
  });

  final double? xs;
  final double? sm;
  final double? md;

  @override
  LineHeightsThemeExtension copyWith({
    double? xs,
    double? sm,
    double? md,
  }) {
    return LineHeightsThemeExtension(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
    );
  }

  @override
  LineHeightsThemeExtension lerp(LineHeightsThemeExtension? other, double t) {
    if (other is! LineHeightsThemeExtension) {
      return this;
    }
    return LineHeightsThemeExtension(
      xs: double.lerp(xs, other.xs, t),
      sm: double.lerp(sm, other.sm, t),
      md: double.lerp(md, other.md, t),
    );
  }
}

class ElevatedButtonThemeExtension extends ThemeExtension<ElevatedButtonThemeExtension> {
  ElevatedButtonThemeExtension({
    this.height,
    this.color,
    this.padding,
    this.borderRadius,
    this.shadow,
    this.border,
  });

  final double? height;
  final Color? color;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? shadow;
  final BoxBorder? border;

  @override
  ElevatedButtonThemeExtension copyWith({
    double? height,
    Color? color,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadow,
    BoxBorder? border,
  }) {
    return ElevatedButtonThemeExtension(
      height: height ?? this.height,
      color: color ?? this.color,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      shadow: shadow ?? this.shadow,
      border: border ?? this.border,
    );
  }

  @override
  ElevatedButtonThemeExtension lerp(ElevatedButtonThemeExtension? other, double t) {
    if (other is! ElevatedButtonThemeExtension) {
      return this;
    }
    return ElevatedButtonThemeExtension(
      height: double.lerp(height, other.height, t),
      color: Color.lerp(color, other.color, t),
      padding: EdgeInsets.lerp(padding, other.padding, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      shadow: List<BoxShadow>(shadow, other.shadow, t),
      border: BoxBorder.lerp(border, other.border, t),
    );
  }
}

class SpecialColorsThemeExtension extends ThemeExtension<SpecialColorsThemeExtension> {
  SpecialColorsThemeExtension({
    this.color1,
    this.color2,
  });

  final Color? color1;
  final Color? color2;

  @override
  SpecialColorsThemeExtension copyWith({
    Color? color1,
    Color? color2,
  }) {
    return SpecialColorsThemeExtension(
      color1: color1 ?? this.color1,
      color2: color2 ?? this.color2,
    );
  }

  @override
  SpecialColorsThemeExtension lerp(SpecialColorsThemeExtension? other, double t) {
    if (other is! SpecialColorsThemeExtension) {
      return this;
    }
    return SpecialColorsThemeExtension(
      color1: Color.lerp(color1, other.color1, t),
      color2: Color.lerp(color2, other.color2, t),
    );
  }
}

extension GeneratedTheme on ThemeData {
  FontFamiliesThemeExtension? get fontFamilies => extension<FontFamiliesThemeExtension>();
  FontWeightsThemeExtension? get fontWeights => extension<FontWeightsThemeExtension>();
  FontSizeThemeExtension? get fontSize => extension<FontSizeThemeExtension>();
  LetterSpacingThemeExtension? get letterSpacing => extension<LetterSpacingThemeExtension>();
  ParagraphSpacingThemeExtension? get paragraphSpacing => extension<ParagraphSpacingThemeExtension>();
  TextCaseThemeExtension? get textCase => extension<TextCaseThemeExtension>();
  TextDecorationThemeExtension? get textDecoration => extension<TextDecorationThemeExtension>();
  ParagraphIndentThemeExtension? get paragraphIndent => extension<ParagraphIndentThemeExtension>();
  LineHeightsThemeExtension? get lineHeights => extension<LineHeightsThemeExtension>();
  ElevatedButtonThemeExtension? get elevatedButton => extension<ElevatedButtonThemeExtension>();
  SpecialColorsThemeExtension? get specialColors => extension<SpecialColorsThemeExtension>();
}

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  
  FontFamiliesThemeExtension get fontFamiliesThemeExtension => theme.extension<FontFamiliesThemeExtension>()!;
FontWeightsThemeExtension get fontWeightsThemeExtension => theme.extension<FontWeightsThemeExtension>()!;
FontSizeThemeExtension get fontSizeThemeExtension => theme.extension<FontSizeThemeExtension>()!;
LetterSpacingThemeExtension get letterSpacingThemeExtension => theme.extension<LetterSpacingThemeExtension>()!;
ParagraphSpacingThemeExtension get paragraphSpacingThemeExtension => theme.extension<ParagraphSpacingThemeExtension>()!;
TextCaseThemeExtension get textCaseThemeExtension => theme.extension<TextCaseThemeExtension>()!;
TextDecorationThemeExtension get textDecorationThemeExtension => theme.extension<TextDecorationThemeExtension>()!;
ParagraphIndentThemeExtension get paragraphIndentThemeExtension => theme.extension<ParagraphIndentThemeExtension>()!;
LineHeightsThemeExtension get lineHeightsThemeExtension => theme.extension<LineHeightsThemeExtension>()!;
ElevatedButtonThemeExtension get elevatedButtonThemeExtension => theme.extension<ElevatedButtonThemeExtension>()!;
SpecialColorsThemeExtension get specialColorsThemeExtension => theme.extension<SpecialColorsThemeExtension>()!;
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
}
