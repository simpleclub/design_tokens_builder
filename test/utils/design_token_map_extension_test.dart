import 'package:design_tokens_builder/parsers/dimension_parser.dart';
import 'package:design_tokens_builder/utils/design_token_map_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parser', () {
    test('succeeds', () {
      final map = {
        'value': '42px',
        'type': 'dimension',
      };

      expect(map.parser, isA<DimensionParser>());
    });

    test('fails due to unknown type', () {
      final map = {
        'value': '42px',
        'type': 'random',
      };

      expect(() => map.parser, throwsException);
    });
  });

  group('flutter type', () {
    test('succeeds', () {
      final map = {
        'value': '42px',
        'type': 'border',
      };

      expect(map.flutterType, 'BoxBorder');
    });

    test('fails due to unknown type', () {
      final map = {
        'value': '42px',
        'type': 'random',
      };

      expect(() => map.flutterType, throwsException);
    });
  });
}
