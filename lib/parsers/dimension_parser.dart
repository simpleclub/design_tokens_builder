import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';

class DimensionParser extends DesignTokenParser {
  DimensionParser([super.indentationLevel, super.config]);
  @override
  List<String> get tokenType => [
        'sizing',
        'borderWidth',
        'dimension',
      ];

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
      return parsePixel(value);
    }

    throw Exception('Unable to parse dimension value with data: $value');
  }
}
