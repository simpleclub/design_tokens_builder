import 'package:design_tokens_builder/parsers/design_token_parser.dart';

/// Parses any basic number token to a Flutter double.
///
/// E.g.
/// Figma design tokens:
///   "value": "3" or
///   "value": "4.2"
///
/// Flutter generated code:
///   3.0 or
///   4.2
class NumberParser extends DesignTokenParser {
  /// Constructs a [NumberParser].
  NumberParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => [
        'fontSizes',
        'letterSpacing',
        'paragraphSpacing',
        'lineHeights',
        'number',
      ];

  @override
  String get flutterType => 'double';

  @override
  String buildLerp(String token) {
    return 'lerpDouble($token, other.$token, t) ?? other.$token';
  }

  @override
  String buildValue(value) {
    try {
      return double.parse(value).toString();
    } catch (e) {
      throw Exception('Unable to parse number with data: $value');
    }
  }
}
