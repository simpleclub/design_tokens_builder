import 'package:design_tokens_builder/parsers/design_token_parser.dart';

/// Parses tokens of type `color` to Flutter code.
///
/// E.g.
/// Figma design tokens:
///   "value": "#FFFFFF"
///
/// Flutter generated code:
///   Color(0xFFFFFFFF)
class ColorParser extends DesignTokenParser {
  /// Constructs a [ColorParser].
  ColorParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => ['color'];

  @override
  String get flutterType => 'Color';

  @override
  String buildValue(value) {
    if (value is String) {
      // Validating HEX color.
      final regex = RegExp('(?:[0-9a-fA-F]{3,4}){1,2}\$');
      if (!regex.hasMatch(value)) throw Exception('Invalid color code: $value');

      value = value.replaceAll('#', '');
      final rgb = value.substring(0, 6);
      // Check if opacity is present.
      if (value.length == 6) {
        return 'Color(0xFF$rgb)';
      }
      final o = value.substring(6, 8);
      final hexCode = '$o$rgb';

      return 'Color(0x$hexCode)';
    }

    throw Exception('Unable to parse color with data: $value');
  }
}
