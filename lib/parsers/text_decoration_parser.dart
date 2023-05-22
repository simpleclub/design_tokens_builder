import 'package:design_tokens_builder/parsers/design_token_parser.dart';

/// Try to parse and return a flutter readable text decoration.
class TextDecorationParser extends DesignTokenParser {
  TextDecorationParser([super.indentationLevel, super.config]);
  @override
  List<String> get tokenType => ['textDecoration'];

  @override
  String get flutterType => 'TextDecoration';

  @override
  String lerp(value) {
    // TODO: implement lerp
    throw UnimplementedError();
  }

  @override
  String parse(value) {
    switch (value) {
      case 'none':
        return 'TextDecoration.none';
      case 'underline':
        return 'TextDecoration.underline';
      case 'line-through':
        return 'TextDecoration.lineThrough';
      default:
        return '';
    }
  }
}
