import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';

/// Parses the line height according to Design Token Studio.
///
/// Supports not only percentage values like 42% but also font sizes like 16.
///
/// E.g.
/// Figma design tokens:
///   "value": "42%" or
///   "value": "16"
///
/// Flutter generated code:
///   0.42 or
///   16
class LineHeightParser extends DesignTokenParser {
  /// Constructs a [LineHeightParser].
  LineHeightParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => ['lineHeights'];

  @override
  String get flutterType => 'double';

  @override
  String buildLerp(String token) {
    return 'lerpDouble($token, other.$token, t)';
  }

  @override
  String buildValue(value) {
    if (value is String) {
      if (value.contains('%')) {
        return '${parsePercentage(value)}';
      } else {
        try {
          return double.parse(value).toString();
        } catch (e) {
          throw Exception('Unable to parse line height with data: $value');
        }
      }
    }

    throw Exception('Unable to parse line height with data: $value');
  }
}
