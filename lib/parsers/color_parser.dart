import 'dart:math';

import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';
import 'package:design_tokens_builder/parsers/extensions/modifiers.dart';

/// Parses tokens of type `color` to Flutter code.
///
/// E.g.
/// Figma design tokens:
///   "value": "#FFFFFF"
///
/// Flutter generated code:
///   Color(0xFFFFFFFF)
class ColorParser extends DesignTokenParser {
  /// Constructs a [ColorParser].
  ColorParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => ['color'];

  @override
  String flutterType([dynamic value]) {
    if (value?.startsWith('linear-gradient')) {
      return 'LinearGradient';
    }

    return 'Color';
  }

  @override
  String buildValue(value, {TokenModifier? modifier}) {
    if (value is String) {
      final hexRegex = RegExp('(?:[0-9a-fA-F]{3,4}){1,2}\$');
      if (value.startsWith('linear-gradient')) {
        // Validating linear gradient.
        value = buildLinearGradient(value);
      } else if (hexRegex.hasMatch(value)) {
        // Validating HEX color.
        value = buildHex(value, modifier: modifier);
      } else {
        value = null;
      }
    } else {
      value = null;
    }

    if (value == null) {
      throw Exception('Unable to parse color with data: $value');
    } else {
      return value;
    }
  }

  /// Builds a Flutter color from a hex value.
  String? buildHex(String value, {TokenModifier? modifier}) {
    String? result;
    result = value.replaceAll('#', '');
    final rgb = result.substring(0, 6);
    var o = 'FF';
    // Check if opacity is present.

    if (result.length != 6 && result.length != 8) {
      return null;
    } else if (result.length > 6) {
      o = result.substring(6, 8);
    }

    if (modifier != null) {
      if (modifier is TokenModifierAlpha) {
        o = (modifier.value * 255)
            .round()
            .toRadixString(16)
            .padLeft(2, '0')
            .toUpperCase();
      }
    }

    final hexCode = '$o$rgb';

    return 'Color(0x$hexCode)';
  }

  /// Builds a Flutter linear gradient from a linear gradient value.
  String? buildLinearGradient(String value) {
    final regex = RegExp(r'linear-gradient\((\d+)deg,(.+)\)');
    final match = regex.firstMatch(value);

    if (match == null) return null;

    final degrees = double.parse(match.group(1)!);
    final points = degreesToPoints(degrees);
    final startPoint = points[0];
    var startAlignment = 'Alignment(${startPoint.x}, ${startPoint.y})';
    final endPoint = points[1];
    var endAlignment = 'Alignment(${endPoint.x}, ${endPoint.y})';
    var colors = <String>[];
    var stops = <double>[];

    for (final colorStop in match.group(2)!.split(',')) {
      final cleanColorStop = colorStop.trim();
      final split = cleanColorStop.split(' ');
      final colorParser = ColorParser();
      final color = colorParser.parse(split[0]);
      colors.add(color);

      final stop = parsePercentage(split[1]);
      stops.add(stop);
    }

    final colorsString = '[${colors.join(', ')}]';
    final stopsString = '[${stops.join(', ')}]';

    return '''LinearGradient(
  begin: $startAlignment,
  end: $endAlignment,
  colors: $colorsString,
  stops: $stopsString,
)
''';
  }

  /// Parses a degree to a list of points.
  List<Point> degreesToPoints(double degrees) {
    // Convert degrees to radians with the new starting point.
    double radians = ((90 - degrees) % 360) * (pi / 180.0);

    // Calculate the x and y coordinates based on the specified angle.
    double x = cos(radians);
    double y = sin(radians);

    // Ensure that the coordinates stay within the range [-1, 1].
    x = x.clamp(-1, 1);
    y = y.clamp(-1, 1);

    // Create Point objects for the two points.
    Point point1 = Point(x, y);
    Point point2 = Point(-x, -y);

    return [point1, point2];
  }
}
