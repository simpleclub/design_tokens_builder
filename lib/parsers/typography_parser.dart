import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';
import 'package:design_tokens_builder/parsers/font_family_parser.dart';
import 'package:design_tokens_builder/parsers/font_weight_parser.dart';
import 'package:design_tokens_builder/parsers/text_decoration_parser.dart';
import 'package:design_tokens_builder/utils/string_utils.dart';

/// Parses the text style and transforms design tokens json values to flutter
/// readable values.
class TypographyParser extends DesignTokenParser {
  TypographyParser([super.indentationLevel, super.config]);
  @override
  List<String> get tokenType => ['typography'];

  @override
  String get flutterType => 'TextStyle';

  @override
  String lerp(value) {
    // TODO: implement lerp
    throw UnimplementedError();
  }

  @override
  String parse(value) {
    if (value is Map<String, dynamic>) {
      final casted = value.cast<String, Map<String, dynamic>>();
      final transformedEntries = casted['value']
          ?.entries
          .map((e) => _transform(e))
          .where((element) => element != null)
          .toList()
          .cast<MapEntry<String, dynamic>>();
      final content = transformedEntries
          ?.map((e) => '${e.key}: ${e.value}')
          .join(',\n${indentation(level: indentationLevel + 1)}');

      if (content == null) return 'TextStyle()';
      return 'TextStyle(\n${indentation(level: indentationLevel + 1)}$content,\n${indentation(level: indentationLevel)})';
    }

    throw Exception('Unable to parse typography with data: $value');
  }

  MapEntry<String, dynamic>? _transform(MapEntry<String, dynamic> data) {
    switch (data.key) {
      case 'fontFamily':
        final parser = FontFamilyParser(indentationLevel, config);
        return MapEntry(
          'fontFamily',
          parser.parse(data.value),
        );
      case 'fontWeight':
        final parser = FontWeightParser();
        return MapEntry('fontWeight', parser.parse(data.value));
      case 'lineHeight':
        return MapEntry('height', parsePercentage(data.value));
      case 'fontSize':
        return MapEntry('fontSize', data.value);
      case 'letterSpacing':
        return MapEntry('letterSpacing', data.value);
      case 'paragraphSpacing':
        return null;
      case 'paragraphIndent':
        return null;
      case 'textCase':
        return null;
      case 'textDecoration':
        final parser = TextDecorationParser();
        return MapEntry('decoration', parser.parse(data.value));
    }

    return null;
  }
}
