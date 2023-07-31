import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/parsers/border_parser.dart';
import 'package:design_tokens_builder/parsers/border_radius_parser.dart';
import 'package:design_tokens_builder/parsers/box_shadow_parser.dart';
import 'package:design_tokens_builder/parsers/color_parser.dart';
import 'package:design_tokens_builder/parsers/dimension_parser.dart';
import 'package:design_tokens_builder/parsers/font_family_parser.dart';
import 'package:design_tokens_builder/parsers/font_weight_parser.dart';
import 'package:design_tokens_builder/parsers/line_height_parser.dart';
import 'package:design_tokens_builder/parsers/number_parser.dart';
import 'package:design_tokens_builder/parsers/opacity_parser.dart';
import 'package:design_tokens_builder/parsers/other_parser.dart';
import 'package:design_tokens_builder/parsers/spacing_parser.dart';
import 'package:design_tokens_builder/parsers/text_case_parser.dart';
import 'package:design_tokens_builder/parsers/text_decoration_parser.dart';
import 'package:design_tokens_builder/parsers/typography_parser.dart';
import 'package:design_tokens_builder/utils/string_utils.dart';

/// Returns the [DesignTokenParser] for the given type.
///
/// Therefore the method checks [DesignTokenParser.tokenType] array if it
/// contains the passed `type`.
/// Make to register one [DesignTokenParser] per type. Otherwise the wrong
/// parser might be returned.
DesignTokenParser parserForType(
  String type, {
  int indentationLevel = 1,
  BuilderConfig? config,
}) {
  try {
    return [
      BorderParser(indentationLevel, config),
      BorderRadiusParser(indentationLevel, config),
      BoxShadowParser(indentationLevel, config),
      ColorParser(indentationLevel, config),
      DimensionParser(indentationLevel, config),
      FontFamilyParser(indentationLevel, config),
      FontWeightParser(indentationLevel, config),
      LineHeightParser(indentationLevel, config),
      NumberParser(indentationLevel, config),
      OpacityParser(indentationLevel, config),
      SpacingParser(indentationLevel, config),
      TextCaseParser(indentationLevel, config),
      TextDecorationParser(indentationLevel, config),
      TypographyParser(indentationLevel, config),
      OtherParser(indentationLevel, config),
    ].firstWhere((element) => element.tokenType.contains(type));
  } catch (e) {
    throw Exception('No parser found for type $type');
  }
}

/// Abstract class for a parser that converts design token data to Flutter
/// readable code.
abstract class DesignTokenParser {
  /// Constructs a [DesignTokenParser].
  DesignTokenParser([
    this.indentationLevel = 1,
    this.config,
  ]);

  /// The indentation level that should be used while generating code.
  ///
  /// Defaults to `1`.
  final int indentationLevel;

  /// The global config of the builder.
  final BuilderConfig? config;

  /// The indentation string for [indentationLevel].
  String indent([int add = 0]) => indentation(level: indentationLevel + add);

  /// A list of token types that should use this parser.
  ///
  /// See [Design Token Studio Documentation](https://docs.tokens.studio/available-tokens/available-tokens)
  /// for a list of supported token types.
  List<String> get tokenType => throw UnimplementedError();

  /// Returns a string representing the Flutter type to which the token
  /// should be converted.
  String get flutterType => throw UnimplementedError();

  final _constTypes = [
    'Color',
    'TextStyle',
    'EdgeInsets',
    'BorderRadius',
    'List<BoxShadow>',
    'Duration',
  ];

  /// Parses the `value` and returns flutter readable code.
  ///
  /// Adds const by default for every Flutter type that wants to be const. By
  /// setting `isConst` to `false` you can return the parsed value without the
  /// `const` prefix.
  String parse(dynamic value, {bool isConst = true}) {
    final includeConst = isConst && _constTypes.contains(flutterType);
    final prefix = includeConst ? 'const ' : '';

    if (value is String && value.isEmpty) return 'null';

    return '$prefix${buildValue(value)}';
  }

  /// Builds the value for the specific type.
  ///
  /// Make sure to only override this method with any new [DesignTokenParser]
  /// you create. Please avoid directly calling this method outside
  /// [DesignTokenParser]. Prefer [DesignTokenParser.parse].
  String buildValue(dynamic value) => throw UnimplementedError();

  /// Builds Flutter code that's linearly interpolating the current type.
  ///
  /// This method only works if it is used in a context where a class wants to
  /// linearly interpolate between the current and `other` value.
  String buildLerp(String token) {
    return '$flutterType.lerp($token, other.$token, t) ?? other.$token';
  }
}
