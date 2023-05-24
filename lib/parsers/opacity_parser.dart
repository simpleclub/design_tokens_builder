import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';

/// Parses opacity token to Flutter double.
///
/// Supports percentages but also floating numbers.
///
/// E.g.
/// Figma design tokens:
///   "value": "42%" or
///   "value": "0.42"
///
/// Flutter generated code:
///   0.42
class OpacityParser extends DesignTokenParser {
  /// Constructs a [OpacityParser].
  OpacityParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => ['opacity'];

  @override
  String get flutterType => 'double';

  @override
  String buildLerp(String token) {
    return 'lerpDouble($token, other.$token, t)';
  }

  @override
  String buildValue(value) {
    if (value is String) {
      var opacity = 0.0;
      if (value.contains('%')) {
        opacity = parsePercentage(value);
      } else {
        try {
          opacity = double.parse(value);
        } catch (e) {
          throw Exception('Unable to parse opacity with data: $value');
        }
      }

      if (opacity < 0 || opacity > 1) {
        throw Exception(
          'Opacity value needs to be between 0 and 1. Current value: $value',
        );
      }

      return opacity.toString();
    }

    throw Exception('Unable to parse opacity with data: $value');
  }
}
