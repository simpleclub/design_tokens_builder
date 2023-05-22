import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';

/// Parses spacing according to
/// [Tokens Studio](https://docs.tokens.studio/available-tokens/spacing-tokens)
/// and provides methods to return Flutter code.
class SpacingParser extends DesignTokenParser {
  SpacingParser([super.indentationLevel, super.config]);
  @override
  List<String> get tokenType => ['spacing'];

  @override
  String get flutterType => 'EdgeInsets';

  @override
  String lerp(value) {
    // TODO: implement lerp
    throw UnimplementedError();
  }

  @override
  String parse(value) {
    if (value is String) {
      final spacingValues = value.split(' ');

      switch (spacingValues.length) {
        case 1:
          final space = parsePixel(spacingValues[0]) ?? 0;
          return 'EdgeInsets.all($space)';
        case 2:
          final vSpace = parsePixel(spacingValues[0]) ?? 0;
          final hSpace = parsePixel(spacingValues[1]) ?? 0;

          return 'EdgeInsets.symmetric(vertical: $vSpace, horizontal: $hSpace)';
        case 3:
          final top = parsePixel(spacingValues[0]) ?? 0;
          final hSpace = parsePixel(spacingValues[1]) ?? 0;
          final bottom = parsePixel(spacingValues[2]) ?? 0;

          return 'EdgeInsets.only(top: $top, right: $hSpace, bottom: $bottom, left: $hSpace)';
        case 4:
          final top = parsePixel(spacingValues[0]) ?? 0;
          final right = parsePixel(spacingValues[1]) ?? 0;
          final bottom = parsePixel(spacingValues[2]) ?? 0;
          final left = parsePixel(spacingValues[3]) ?? 0;

          return 'EdgeInsets.only(top: $top, right: $right, bottom: $bottom, left: $left)';
        default:
          throw Exception(
              'Cannot parse spacing since there are ${spacingValues.length} values. Please provide 1-4 values.');
      }
    }

    throw Exception('Unable to parse spacing with data: $value');
  }
}
