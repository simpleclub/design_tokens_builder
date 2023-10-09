import 'package:design_tokens_builder/parsers/design_token_parser.dart';

/// Parses text case according to Tokens studio for Figma.
///
/// E.g.
/// Figma design tokens:
///   "value": "uppercase"
///
/// Flutter generated code:
///   "uppercase"
class TextCaseParser extends DesignTokenParser {
  /// Constructs a [TextCaseParser].
  TextCaseParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => ['textCase'];

  @override
  String flutterType([dynamic value]) => 'String';

  @override
  String buildLerp(String token, dynamic value) {
    return 'other.$token';
  }

  @override
  String buildValue(value) {
    return '\'$value\'';
  }
}
