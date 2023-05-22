import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';

/// Parses border radius according to
/// [Tokens Studio](https://docs.tokens.studio/available-tokens/border-radius-tokens)
/// and provides methods to return Flutter code.
class BorderRadiusParser extends DesignTokenParser {
  BorderRadiusParser([super.indentationLevel, super.config]);
  @override
  List<String> get tokenType => ['borderRadius'];

  @override
  String get flutterType => 'BorderRadius';

  @override
  String lerp(value) {
    // TODO: implement lerp
    throw UnimplementedError();
  }

  @override
  String parse(value) {
    if (value is String) {
      final radiiValues = value.split(' ');

      switch (radiiValues.length) {
        case 1:
          final r = parsePixel(radiiValues[0]);
          return 'BorderRadius.all(${_radius(r)})';
        case 2:
          final r1 = parsePixel(radiiValues[0]);
          final r2 = parsePixel(radiiValues[1]);

          return 'BorderRadius.only(topLeft: ${_radius(r1)}, topRight: ${_radius(r2)}, bottomLeft: ${_radius(r2)}, bottomRight: ${_radius(r1)})';
        case 3:
          final r1 = parsePixel(radiiValues[0]);
          final r2 = parsePixel(radiiValues[1]);
          final r3 = parsePixel(radiiValues[2]);

          return 'BorderRadius.only(topLeft: ${_radius(r1)}, topRight: ${_radius(r2)}, bottomLeft: ${_radius(r2)}, bottomRight: ${_radius(r3)})';
        case 4:
          final r1 = parsePixel(radiiValues[0]);
          final r2 = parsePixel(radiiValues[1]);
          final r3 = parsePixel(radiiValues[2]);
          final r4 = parsePixel(radiiValues[3]);

          return 'BorderRadius.only(topLeft: ${_radius(r1)}, topRight: ${_radius(r2)}, bottomLeft: ${_radius(r4)}, bottomRight: ${_radius(r3)})';
        default:
          throw Exception(
              'Cannot parse border radius since there are ${radiiValues.length} values. Please provide 1-4 values.');
      }
    }

    throw Exception('Unable to parse border radius with data: $value');
  }

  String _radius(dynamic value) => 'Radius.circular($value)';
}
