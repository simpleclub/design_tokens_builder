import 'package:design_tokens_builder/parsers/border_parser.dart';
import 'package:design_tokens_builder/parsers/color_parser.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';
import 'package:design_tokens_builder/parsers/dimension_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Uses any DesignTokenParser implementation in order to test method since
  // abstract classes cannot be instantiated.
  final parser = ColorParser();

  group('parser for type', () {
    test('returns correct parser', () {
      expect(parserForType('border'), isInstanceOf<BorderParser>());
    });

    test('fails', () {
      expect(() => parserForType('someType'), throwsException);
    });
  });

  group('parse works', () {
    final value = '#FFFFFF';

    test('parse with const', () {
      expect(parser.parse(value, isConst: true), 'const Color(0xFFFFFFFF)');
    });

    test('parse with const but with type that does not support it', () {
      final dimensionParser = DimensionParser();
      expect(dimensionParser.parse('3px', isConst: true), '3.0');
    });

    test('parse without const', () {
      expect(parser.parse(value, isConst: false), 'Color(0xFFFFFFFF)');
    });
  });

  group('build value', () {
    final value = '#FFFFFF';

    test('succeeds', () {
      expect(parser.buildValue(value), 'Color(0xFFFFFFFF)');
    });
  });

  group('build lerp', () {
    test('succeeds', () {
      expect(parser.buildLerp('someColor'),
          'Color.lerp(someColor, other.someColor, t) ?? other.someColor');
    });
  });

  group('indent', () {
    test('1', () {
      expect(parser.indent(1), '    ');
    });

    test('0', () {
      expect(parser.indent(), '  ');
    });

    test('4', () {
      expect(parser.indent(4), '          ');
    });
  });
}
