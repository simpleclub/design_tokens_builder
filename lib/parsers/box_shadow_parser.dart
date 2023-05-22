import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';
import 'package:design_tokens_builder/utils/color_utils.dart';

/// Parses box shadows according to
/// [Tokens Studio](https://docs.tokens.studio/available-tokens/shadow-tokens)
/// and provides methods to return Flutter code.
class BoxShadowParser extends DesignTokenParser {
  BoxShadowParser([super.indentationLevel, super.config]);
  @override
  List<String> get tokenType => ['boxShadow'];

  @override
  String get flutterType => 'List<BoxShadow>';

  @override
  String lerp(value) {
    // TODO: implement lerp
    throw UnimplementedError();
  }

  @override
  String parse(value) {
    if (value is Map<String, dynamic>) {
      return '[${_parseShadow(value)}]';
    } else if (value is List<dynamic>) {
      var parsedShadows = <String>[];

      for (final shadow in value) {
        parsedShadows.add(_parseShadow(shadow));
      }

      return '[${parsedShadows.join(',')}]';
    }

    throw Exception('Unable to parse box shadow with data: $value');
  }

  String _parseShadow(Map<String, dynamic> shadow) {
    final x = parsePixel(shadow['x']) ?? 0;
    final y = parsePixel(shadow['y']) ?? 0;
    final offset = 'Offset($x, $y)';
    final spread = parsePixel(shadow['spread']) ?? 0;
    final color = parseColor(shadow['color']);
    final blur = parsePixel(shadow['blur']) ?? 0;
    final style =
        shadow['type'] == 'dropShadow' ? 'BlurStyle.normal' : 'BlurStyle.inner';

    return 'BoxShadow(color: $color, offset: $offset, blurRadius: $blur, spreadRadius: $spread, blurStyle: $style)';
  }
}
