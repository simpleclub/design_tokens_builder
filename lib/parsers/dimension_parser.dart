import 'package:design_tokens_builder/parsers/design_token_parser.dart';

/// Parser for dimension tokens.
///
/// Only supports px for now but not rem.
///
/// E.g.
/// Figma design tokens:
///   "value": "14" or
///   "value": "14px"
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
    return 'lerpDouble($token, other.$token, t) ?? other.$token';
  }

  @override
  String buildValue(value) {
    if (value is String) {
      final pixel = double.parse(value.split('px').first);
      return pixel.toString();
    }

    throw Exception('Unable to parse dimension value with data: $value');
  }
}
