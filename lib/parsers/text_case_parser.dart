import 'package:design_tokens_builder/parsers/design_token_parser.dart';

class TextCaseParser extends DesignTokenParser {
  TextCaseParser([super.indentationLevel, super.config]);
  @override
  List<String> get tokenType => ['textCase'];

  @override
  String get flutterType => 'String';

  @override
  String lerp(value) {
    // TODO: implement lerp
    throw UnimplementedError();
  }

  @override
  String parse(value) {
    return '\'$value\'';
  }
}
