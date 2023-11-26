import 'package:design_tokens_builder/parsers/font_weight_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = FontWeightParser();

  test('correct setup', () {
    expect(parser.tokenType, ['fontWeights']);
    expect(parser.flutterType, 'FontWeight');
  });

  group('build value', () {
    test('succeeds', () {
      final result = parser.buildValue('400');
      expect(result, 'FontWeight.w400');
    });

    test('fails because of wrong weight', () {
      expect(() => parser.buildValue('420'), throwsException);
    });

    test('fails', () {
      expect(() => parser.buildValue(400), throwsException);
    });
  });

  group('FigmaFontWeight', () {
    test('thin', () {
      const fontWeight = FigmaFontWeight.thin;
      expect(fontWeight.numerical, 100);
      expect(fontWeight.string, 'thin');
    });

    test('extraLight', () {
      const fontWeight = FigmaFontWeight.extraLight;
      expect(fontWeight.numerical, 200);
      expect(fontWeight.string, 'extra-light');
    });

    test('light', () {
      const fontWeight = FigmaFontWeight.light;
      expect(fontWeight.numerical, 300);
      expect(fontWeight.string, 'light');
    });

    test('regular', () {
      const fontWeight = FigmaFontWeight.regular;
      expect(fontWeight.numerical, 400);
      expect(fontWeight.string, 'regular');
    });

    test('medium', () {
      const fontWeight = FigmaFontWeight.medium;
      expect(fontWeight.numerical, 500);
      expect(fontWeight.string, 'medium');
    });

    test('semiBold', () {
      const fontWeight = FigmaFontWeight.semiBold;
      expect(fontWeight.numerical, 600);
      expect(fontWeight.string, 'semi-bold');
    });

    test('bold', () {
      const fontWeight = FigmaFontWeight.bold;
      expect(fontWeight.numerical, 700);
      expect(fontWeight.string, 'bold');
    });

    test('extraBold', () {
      const fontWeight = FigmaFontWeight.extraBold;
      expect(fontWeight.numerical, 800);
      expect(fontWeight.string, 'extra-bold');
    });

    test('black', () {
      const fontWeight = FigmaFontWeight.black;
      expect(fontWeight.numerical, 900);
      expect(fontWeight.string, 'black');
    });

    test('tryParse', () {
      expect(FigmaFontWeight.tryParse('thin'), FigmaFontWeight.thin);
      expect(FigmaFontWeight.tryParse('extra-light'), FigmaFontWeight.extraLight);
      expect(FigmaFontWeight.tryParse('light'), FigmaFontWeight.light);
      expect(FigmaFontWeight.tryParse('regular'), FigmaFontWeight.regular);
      expect(FigmaFontWeight.tryParse('medium'), FigmaFontWeight.medium);
      expect(FigmaFontWeight.tryParse('semi-bold'), FigmaFontWeight.semiBold);
      expect(FigmaFontWeight.tryParse('bold'), FigmaFontWeight.bold);
      expect(FigmaFontWeight.tryParse('extra-bold'), FigmaFontWeight.extraBold);
      expect(FigmaFontWeight.tryParse('black'), FigmaFontWeight.black);
      expect(FigmaFontWeight.tryParse('600'), FigmaFontWeight.semiBold);
      expect(FigmaFontWeight.tryParse('semiBold'), FigmaFontWeight.semiBold);
      expect(FigmaFontWeight.tryParse('Semi Bold'), FigmaFontWeight.semiBold);
      expect(FigmaFontWeight.tryParse('SemiBold'), FigmaFontWeight.semiBold);
      expect(FigmaFontWeight.tryParse('650'), null);
    });
  });
}
