import 'package:design_tokens_builder/parsers/design_token_parser.dart';
import 'package:design_tokens_builder/parsers/dimension_parser.dart';

/// Parses spacing according to
/// [Tokens Studio](https://docs.tokens.studio/available-tokens/spacing-tokens)
/// and provides methods to return Flutter code.
///
/// E.g.
/// Figma design tokens:
///   "value": "16px" or
///   "value": "16"
///
/// Flutter generated code:
///   EdgeInsets.all(16.0)
class SpacingParser extends DesignTokenParser {
  /// Constructs a [SpacingParser].
  SpacingParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => ['spacing'];

  @override
  String get flutterType => 'EdgeInsets';

  @override
  String buildValue(value) {
    if (value is String) {
      final parseDimension = DimensionParser().parse;
      final spacingValues = value.split(' ');

      switch (spacingValues.length) {
        case 1:
          final space = parseDimension(spacingValues[0]);
          return 'EdgeInsets.all($space)';
        case 2:
          final vSpace = parseDimension(spacingValues[0]);
          final hSpace = parseDimension(spacingValues[1]);

          return 'EdgeInsets.symmetric(vertical: $vSpace, horizontal: $hSpace)';
        case 3:
          final top = parseDimension(spacingValues[0]);
          final hSpace = parseDimension(spacingValues[1]);
          final bottom = parseDimension(spacingValues[2]);

          return 'EdgeInsets.only(top: $top, right: $hSpace, bottom: $bottom, left: $hSpace)';
        case 4:
          final top = parseDimension(spacingValues[0]);
          final right = parseDimension(spacingValues[1]);
          final bottom = parseDimension(spacingValues[2]);
          final left = parseDimension(spacingValues[3]);

          return 'EdgeInsets.only(top: $top, right: $right, bottom: $bottom, left: $left)';
        default:
          throw Exception(
            'Cannot parse spacing since there are ${spacingValues.length} values. Please provide 1-4 values.',
          );
      }
    }

    throw Exception('Unable to parse spacing with data: $value');
  }
}
