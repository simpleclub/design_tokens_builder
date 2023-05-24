import 'package:design_tokens_builder/parsers/design_token_parser.dart';
import 'package:yaml/yaml.dart';

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
  String get flutterType => 'String';

  @override
  String buildLerp(String token) {
    return 'other.$token';
  }

  @override
  String buildValue(value) {
    if (config != null && config!.containsKey('fontConfig')) {
      final mappedFonts = config!['fontConfig'] as YamlList;
      if (!mappedFonts.any((element) => element['family'] == value)) {
        return '\'$value\'';
      }

      final currentFont =
          mappedFonts.firstWhere((element) => element['family'] == value);

      return '\'${currentFont['flutterName']}\'';
    }

    return '\'$value\'';
  }
}
