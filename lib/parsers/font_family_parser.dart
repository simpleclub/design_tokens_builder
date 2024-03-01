import 'package:design_tokens_builder/parsers/design_token_parser.dart';
import 'package:design_tokens_builder/parsers/extensions/modifiers.dart';

/// Parses and return a flutter readable code for font family.
///
/// Replaces the font name of the token value with its configured Flutter name
/// found in `tokenbuilder.yaml`.
/// Returns `value` if no font config was set in `config` or no `config` was
/// provided.
///
/// E.g.
/// Figma design tokens:
///   "value": "My Font"
///
/// Flutter generated code:
///   "MyFlutterFont"
class FontFamilyParser extends DesignTokenParser {
  /// Constructs a [FontFamilyParser].
  FontFamilyParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => ['fontFamilies'];

  @override
  String flutterType([dynamic value]) => 'String';

  @override
  String buildLerp(String token, dynamic value) {
    return 'other.$token';
  }

  @override
  String buildValue(value, {TokenModifier? modifier}) {
    if (config != null && config!.fontConfig.isNotEmpty) {
      final mappedFonts = config!.fontConfig;
      if (!mappedFonts.any((element) => element.family == value)) {
        return '\'$value\'';
      }

      final currentFont =
          mappedFonts.firstWhere((element) => element.family == value);

      return '\'${currentFont.flutterName}\'';
    }

    return '\'$value\'';
  }
}
