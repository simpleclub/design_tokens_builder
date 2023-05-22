import 'package:design_tokens_builder/parsers/design_token_parser.dart';

class NumberParser extends DesignTokenParser {
  NumberParser([super.indentationLevel, super.config]);
  @override
  List<String> get tokenType => [
        'fontSizes',
        'letterSpacing',
        'paragraphSpacing',
        'lineHeights',
      ];

  @override
  String get flutterType => 'double';

  @override
  String lerp(value) {
    // TODO: implement lerp
    throw UnimplementedError();
  }

  @override
  String parse(value) {
    final number = double.tryParse(value);
    if (number != null) return number.toString();

    throw Exception('Unable to parse number with data: $value');
  }
}
