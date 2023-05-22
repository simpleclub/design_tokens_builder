import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';

/// Supports 15% or 0.15.
class OpacityParser extends DesignTokenParser {
  OpacityParser([super.indentationLevel, super.config]);
  @override
  List<String> get tokenType => ['opcaity'];

  @override
  // TODO: implement flutterType
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
          return double.parse(value).toString();
        } catch (e) {
          throw Exception('Unable to parse opacity with data: $value');
        }
      }
    }

    throw Exception('Unable to parse opacity with data: $value');
  }
}
