import 'package:design_tokens_builder/parsers/design_token_parser.dart';
import 'package:design_tokens_builder/parsers/dimension_parser.dart';
import 'package:design_tokens_builder/parsers/extensions/modifiers.dart';

/// Parses border radius according to
/// [Tokens Studio](https://docs.tokens.studio/available-tokens/border-radius-tokens)
/// and provides methods to return Flutter code.
///
/// E.g.
/// Figma design tokens:
///   "value": "42px"
///
/// Flutter generated code:
///   BorderRadius.all(Radius.circular(42.0))
class BorderRadiusParser extends DesignTokenParser {
  /// Constructs a [BorderRadiusParser].
  BorderRadiusParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => ['borderRadius'];

  @override
  String flutterType([dynamic value]) => 'BorderRadius';

  @override
  String buildValue(value, {TokenModifier? modifier}) {
    if (value is String) {
      final radiiValues = value.split(' ');
      final parseDimension = DimensionParser().parse;

      switch (radiiValues.length) {
        case 1:
          final r = parseDimension(radiiValues[0]);
          return 'BorderRadius.all(${_radius(r)})';
        case 2:
          final r1 = parseDimension(radiiValues[0]);
          final r2 = parseDimension(radiiValues[1]);

          return 'BorderRadius.only(topLeft: ${_radius(r1)}, topRight: ${_radius(r2)}, bottomLeft: ${_radius(r2)}, bottomRight: ${_radius(r1)})';
        case 3:
          final r1 = parseDimension(radiiValues[0]);
          final r2 = parseDimension(radiiValues[1]);
          final r3 = parseDimension(radiiValues[2]);

          return 'BorderRadius.only(topLeft: ${_radius(r1)}, topRight: ${_radius(r2)}, bottomLeft: ${_radius(r2)}, bottomRight: ${_radius(r3)})';
        case 4:
          final r1 = parseDimension(radiiValues[0]);
          final r2 = parseDimension(radiiValues[1]);
          final r3 = parseDimension(radiiValues[2]);
          final r4 = parseDimension(radiiValues[3]);

          return 'BorderRadius.only(topLeft: ${_radius(r1)}, topRight: ${_radius(r2)}, bottomLeft: ${_radius(r4)}, bottomRight: ${_radius(r3)})';
        default:
          throw Exception(
            'Cannot parse border radius since there are ${radiiValues.length} values. Please provide 1-4 values.',
          );
      }
    }

    throw Exception('Unable to parse border radius with data: $value');
  }

  String _radius(dynamic value) => 'Radius.circular($value)';
}
