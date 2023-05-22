import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';

/// Supports values like 42% or 16.
class LineHeightParser extends DesignTokenParser {
  LineHeightParser([super.indentationLevel, super.config]);
  @override
  List<String> get tokenType => ['lineHeights'];

  @override
  String get flutterType => 'double';

  @override
  String lerp(value) {
    // TODO: implement lerp
    throw UnimplementedError();
  }

  @override
  String parse(value) {
    if (value is String) {
      if (value.contains('%')) {
        return parsePercentage(value);
      } else {
        try {
          return int.parse(value).toString();
        } catch (e) {
          throw Exception('Unable to parse line height with data: $value');
        }
      }
    }

    throw Exception('Unable to parse line height with data: $value');
  }
}
