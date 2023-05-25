import 'package:design_tokens_builder/parsers/design_token_parser.dart';

/// Try to parse and return a Flutter readable text decoration.
///
/// E.g.
/// Figma design tokens:
///   "value": "underline"
///
/// Flutter generated code:
///   TextDecoration.underline
class TextDecorationParser extends DesignTokenParser {
  /// Constructs a [TextDecorationParser].
  TextDecorationParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => ['textDecoration'];

  @override
  String get flutterType => 'TextDecoration';

  @override
  String buildLerp(String token) {
    return 'other.$token';
  }

  @override
  String buildValue(value) {
    switch (value) {
      case 'none':
        return 'TextDecoration.none';
      case 'underline':
        return 'TextDecoration.underline';
      case 'line-through':
        return 'TextDecoration.lineThrough';
      default:
        throw Exception(
          'Unable to parse text decoration due to unsupported value: $value',
        );
    }
  }
}
