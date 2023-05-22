import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';
import 'package:design_tokens_builder/utils/color_utils.dart';

/// Parses borders according to
/// [Tokens Studio](https://docs.tokens.studio/available-tokens/border-tokens)
/// and provides methods to return Flutter code.
///
/// Right now we only support solid borders since Flutter does support dashed
/// borders by default.
class BorderParser extends DesignTokenParser {
  BorderParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => ['border'];

  @override
  String get flutterType => 'BoxBorder';

  @override
  String lerp(value) {
    // TODO: implement lerp
    throw UnimplementedError();
  }

  @override
  String parse(value) {
    if (value is Map<String, dynamic>) {
      final color = parseColor(value['color']);
      final width = parsePixel(value['width']) ?? 0;

      if (value['style'] == 'dashed') {
        throw Exception(
            'Unable to parse dashed border. Please use solid instead.');
      }

      return 'Border.all(width: $width, color: const $color)';
    }

    throw Exception('Unable to parse border with data: $value');
  }
}
