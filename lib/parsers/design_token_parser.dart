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
import 'package:design_tokens_builder/parsers/spacing_parser.dart';
import 'package:design_tokens_builder/parsers/text_case_parser.dart';
import 'package:design_tokens_builder/parsers/text_decoration_parser.dart';
import 'package:design_tokens_builder/parsers/typography_parser.dart';
import 'package:yaml/yaml.dart';

DesignTokenParser parserForType(
  String type, {
  int indentationLevel = 1,
  YamlMap? config,
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
    ].firstWhere((element) => element.tokenType.contains(type));
  } catch (e) {
    throw Exception('No parser found for type $type');
  }
}

abstract class DesignTokenParser {
  DesignTokenParser([
    this.indentationLevel = 1,
    this.config,
  ]);

  final int indentationLevel;
  final YamlMap? config;

  List<String> get tokenType => throw UnimplementedError();
  String get flutterType => throw UnimplementedError();

  String parse(dynamic value) => throw UnimplementedError();
  String lerp(dynamic value) => throw UnimplementedError();
}
