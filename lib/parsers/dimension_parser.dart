import 'package:design_tokens_builder/parsers/design_token_parser.dart';
import 'package:design_tokens_builder/parsers/extensions/modifiers.dart';

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
  String flutterType([dynamic value]) => 'double';

  @override
  String buildLerp(String token, dynamic value) {
    return 'lerpDouble($token, other.$token, t) ?? other.$token';
  }

  @override
  String buildValue(value, {TokenModifier? modifier}) {
    if (value is String) {
      final pixel = double.parse(value.split('px').first);
      return pixel.toString();
    }

    throw Exception('Unable to parse dimension value with data: $value');
  }
}
