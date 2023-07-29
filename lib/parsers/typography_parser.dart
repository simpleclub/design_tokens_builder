import 'package:collection/collection.dart';
import 'package:design_tokens_builder/parsers/color_parser.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';
import 'package:design_tokens_builder/parsers/font_family_parser.dart';
import 'package:design_tokens_builder/parsers/font_weight_parser.dart';
import 'package:design_tokens_builder/parsers/line_height_parser.dart';
import 'package:design_tokens_builder/parsers/number_parser.dart';
import 'package:design_tokens_builder/parsers/text_decoration_parser.dart';

/// Parses the text style and transforms design tokens json values to Flutter
/// readable values.
///
/// E.g.
/// Figma design tokens:
///   "value": {
///     "fontFamily": "MyFont",
///     "fontWeight": "400",
///     "lineHeight": "1.1",
///     "fontSize": "17",
///   }
///
/// Flutter generated code:
///   TextStyle(
///     fontFamily: "MyFlutterFont",
///     fontWeight: FontWeight.w400,
///     height: 1.1,
///     fontSize: 17,
///   )
class TypographyParser extends DesignTokenParser {
  /// Constructs a [TypographyParser].
  TypographyParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => ['typography'];

  @override
  String get flutterType => 'TextStyle';

  @override
  String buildValue(value) {
    if (value is Map<String, dynamic>) {
      final transformedEntries = value.entries
          .map((e) => _transform(e))
          .where((element) => element != null)
          .cast<MapEntry<String, dynamic>>()
          .toList();
      final family = value['fontFamily'] as String?;
      final package = _fontPackage(family);

      if (package != null) {
        transformedEntries.add(MapEntry('package', '\'$package\''));
      }

      final content = transformedEntries
          .map((e) => '${e.key}: ${e.value}')
          .join(',\n${indent()}');

      return 'TextStyle(\n${indent()}$content,\n${indent(-1)})';
    }

    throw Exception('Unable to parse typography with data: $value');
  }

  MapEntry<String, dynamic>? _transform(MapEntry<String, dynamic> data) {
    final value = data.value;
    switch (data.key) {
      case 'fontFamily':
        final parser = FontFamilyParser(indentationLevel, config);
        return MapEntry(
          'fontFamily',
          parser.parse(value),
        );
      case 'fontWeight':
        final parser = FontWeightParser(indentationLevel, config);
        return MapEntry('fontWeight', parser.parse(value));
      case 'lineHeight':
        final parser = LineHeightParser(indentationLevel, config);
        return MapEntry('height', parser.parse(value));
      case 'fontSize':
        final parser = NumberParser(indentationLevel, config);
        return MapEntry('fontSize', parser.parse(value));
      case 'letterSpacing':
        return MapEntry('letterSpacing', value);
      case 'paragraphSpacing':
        return null;
      case 'paragraphIndent':
        return null;
      case 'textCase':
        return null;
      case 'textDecoration':
        final parser = TextDecorationParser(indentationLevel, config);
        return MapEntry('decoration', parser.parse(value));
      case 'color':
        var colorValue = value;
        // Parse color if hex color.
        if (value is String && value.startsWith('#')) {
          final parser = ColorParser(indentationLevel, config);
          colorValue = parser.parse(value);
        }

        return MapEntry('color', colorValue);
    }

    throw Exception('Unable to transform value with unknown key: ${data.key}');
  }

  String? _fontPackage(String? fontFamily) {
    if (fontFamily == null) return null;

    final fontConfig = config?.fontConfig.firstWhereOrNull(
      (config) => config.family == fontFamily,
    );
    return fontConfig?.package;
  }
}
