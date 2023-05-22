import 'package:design_tokens_builder/parsers/design_token_parser.dart';

/// Parses tokens of type `fontWeights` to Flutter code.
class FontWeightParser extends DesignTokenParser {
  FontWeightParser([super.indentationLevel, super.config]);
  @override
  List<String> get tokenType => ['fontWeights'];

  @override
  String get flutterType => 'FontWeight';

  @override
  String lerp(value) {
    // TODO: implement lerp
    throw UnimplementedError();
  }

  @override
  String parse(value) {
    if (value is String) {
      final abs = double.parse(value).toInt();
      final allowedWeights = [100, 200, 300, 400, 500, 600, 700, 800, 900];

      if (allowedWeights.contains(abs)) {
        return 'FontWeight.w$abs';
      }
    }

    throw Exception('Unable to parse font weight with data: $value');
  }
}
