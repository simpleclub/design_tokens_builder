import 'package:design_tokens_builder/parsers/color_parser.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';
import 'package:design_tokens_builder/parsers/dimension_parser.dart';

/// Parses box shadows according to
/// [Tokens Studio](https://docs.tokens.studio/available-tokens/shadow-tokens)
/// and provides methods to return Flutter code.
///
/// Supports single shadows but also a list of shadows. Also supports
/// `dropShadow` and `innerShadow` shadow types from design tokens.
///
/// E.g.
/// Figma design tokens:
///   "value": {
///     "x": "4",
///     "y": "2",
///     "spread": "3",
///     "color": "#FFFFFF",
///     "blur": "5",
///     "type": "dropShadow"
///   }
///
/// Flutter generated code:
///   BoxShadow(
///     color: Color(0xFFFFFFFF),
///     offset: Offset(4.0, 2.0),
///     blurRadius: 5.0,
///     spreadRadius: 3.0,
///     blurStyle: BlurStyle.normal,
///   )
class BoxShadowParser extends DesignTokenParser {
  /// Constructs a [BoxShadowParser].
  BoxShadowParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => ['boxShadow'];

  @override
  String flutterType([dynamic value]) => 'List<BoxShadow>';

  @override
  String buildLerp(String token, dynamic value) {
    return 'BoxShadow.lerpList($token, other.$token, t) ?? other.$token';
  }

  @override
  String buildValue(value) {
    if (value is Map<String, dynamic>) {
      return '[\n${indent()}${_parseShadow(value)},\n${indent(-1)}]';
    } else if (value is List<dynamic>) {
      var parsedShadows = <String>[];

      for (final shadow in value) {
        parsedShadows.add(_parseShadow(shadow));
      }

      return '[\n${indent()}${parsedShadows.join(',\n${indent()}')},\n${indent(-1)}]';
    }

    throw Exception('Unable to parse box shadow with data: $value');
  }

  String _parseShadow(
    Map<String, dynamic> shadow,
  ) {
    final parseDimension = DimensionParser().parse;
    final x = parseDimension(shadow['x']);
    final y = parseDimension(shadow['y']);
    final offset = 'Offset($x, $y)';
    final spread = parseDimension(shadow['spread']);
    final color = ColorParser().parse(shadow['color'], isConst: false);
    final blur = parseDimension(shadow['blur']);
    final style =
        shadow['type'] == 'dropShadow' ? 'BlurStyle.normal' : 'BlurStyle.inner';

    return 'BoxShadow(\n${indent(1)}color: $color,\n${indent(1)}offset: $offset,\n${indent(1)}blurRadius: $blur,\n${indent(1)}spreadRadius: $spread,\n${indent(1)}blurStyle: $style,\n${indent()})';
  }
}
