import 'package:design_tokens_builder/parsers/box_shadow_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = BoxShadowParser();

  test('correct setup', () {
    expect(parser.tokenType, ['boxShadow']);
    expect(parser.flutterType, 'List<BoxShadow>');
  });

  group('build value', () {
    test('1 shadow', () {
      final map = {
        'x': '4',
        'y': '2',
        'spread': '3',
        'color': '#FFFFFF',
        'blur': '5',
        'type': 'dropShadow',
      };

      expect(
        parser.buildValue(map),
        '[\n  BoxShadow(\n    color: Color(0xFFFFFFFF),\n    offset: Offset(4.0, 2.0),\n    blurRadius: 5.0,\n    spreadRadius: 3.0,\n    blurStyle: BlurStyle.normal,\n  ),\n]',
      );
    });

    test('multiple shadows', () {
      final map = [
        {
          'x': '4',
          'y': '2',
          'spread': '3',
          'color': '#FFFFFF',
          'blur': '5',
          'type': 'dropShadow',
        },
        {
          'x': '4',
          'y': '2',
          'spread': '3',
          'color': '#FFFFFF',
          'blur': '5',
          'type': 'innerShadow',
        },
      ];

      expect(
        parser.buildValue(map),
        '[\n  BoxShadow(\n    color: Color(0xFFFFFFFF),\n    offset: Offset(4.0, 2.0),\n    blurRadius: 5.0,\n    spreadRadius: 3.0,\n    blurStyle: BlurStyle.normal,\n  ),\n  BoxShadow(\n    color: Color(0xFFFFFFFF),\n    offset: Offset(4.0, 2.0),\n    blurRadius: 5.0,\n    spreadRadius: 3.0,\n    blurStyle: BlurStyle.inner,\n  ),\n]',
      );
    });

    test('fails', () {
      final value = 1;

      expect(() => parser.parse(value), throwsException);
    });
  });

  group('build lerp', () {
    test('succeeds', () {
      var token = 'someShadow';
      expect(
        parser.buildLerp(token),
        'BoxShadow.lerpList(someShadow, other.someShadow, t) ?? other.someShadow',
      );
    });
  });
}
