import 'package:design_tokens_builder/parsers/design_token_parser.dart';
import 'package:design_tokens_builder/utils/color_utils.dart';

/// Parses tokens of type `color` to Flutter code.
class ColorParser extends DesignTokenParser {
  ColorParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => ['color'];

  @override
  String get flutterType => 'Color';

  @override
  String lerp(value) {
    // TODO: implement lerp
    throw UnimplementedError();
  }

  @override
  String parse(value) {
    if (value is String) {
      return parseColor(value);
    }

    throw Exception('Unable to parse color with data: $value');
  }
}
