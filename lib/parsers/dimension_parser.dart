import 'package:design_tokens_builder/parsers/design_token_parser.dart';

/// Parser for dimension tokens.
///
/// Only supports px for now but not rem.
///
/// E.g.
/// Figma design tokens:
///   "value": "14" or
///   "value": "14px" or
///   "value": 14
///
/// Flutter generated code:
///   14.0
class DimensionParser extends DesignTokenParser {
  /// Constructs a [DimensionParser].
  DimensionParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => [
        'sizing',
        'borderWidth',
        'dimension',
      ];

  @override
  String get flutterType => 'double';

  @override
  String buildLerp(String token) {
    return 'lerpDouble($token, other.$token, t)';
  }

  @override
  String buildValue(value) {
    late final double pixel;
    switch (value.runtimeType) {
      case String:
        pixel = double.parse(value.split('px').first);
        break;
      case int:
        pixel = value.toDouble();
        break;
      default:
        throw Exception('Unable to parse dimension value with data: $value');
    }
    return pixel.toString();
  }
}
