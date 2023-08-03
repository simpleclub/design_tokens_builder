import 'package:design_tokens_builder/parsers/color_parser.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';
import 'package:design_tokens_builder/parsers/dimension_parser.dart';

/// Parses borders according to
/// [Tokens Studio](https://docs.tokens.studio/available-tokens/border-tokens)
/// and provides methods to return Flutter code.
///
/// Right now we only support solid borders since Flutter does support dashed
/// borders by default.
///
/// E.g.
/// Figma design tokens:
///   "value": {
///     "color": "#FFFFFF",
///     "width": "3",
///     "style": "solid"
///   }
///
/// Flutter generated code:
///   Border.all(
///     width: 3.0,
///     color: Color(0xFFFFFFFF),
///   )
class BorderParser extends DesignTokenParser {
  /// Constructs a [BorderParser].
  BorderParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => ['border'];

  @override
  String get flutterType => 'BoxBorder';

  @override
  String buildValue(value) {
    if (value is Map<String, dynamic>) {
      final color = ColorParser().parse(value['color']);
      final width = DimensionParser().parse(value['width']);

      if (color == 'null' || width == 'null') {
        return 'null';
      }

      if (value['style'] == 'dashed') {
        throw Exception(
          'Unable to parse dashed border. Please use solid instead.',
        );
      }

      return 'Border.all(\n${indent()}width: $width,\n${indent()}color: $color,\n${indent(-1)})';
    }

    throw Exception('Unable to parse border with data: $value');
  }
}
