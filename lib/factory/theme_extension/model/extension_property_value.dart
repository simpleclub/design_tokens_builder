import 'package:design_tokens_builder/factory/theme_extension/model/extension_property.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';
import 'package:design_tokens_builder/utils/string_utils.dart';

/// A property that can be used in a theme extension representing a value.
class ExtensionPropertyValue extends ExtensionProperty {
  /// Default constructor.
  ExtensionPropertyValue({
    required super.name,
    required this.value,
    required this.type,
  });

  /// The value of the property.
  final dynamic value;

  /// The type of the property.
  final String type;

  @override
  String build({int indentationLevel = 0, bool includeName = false}) {
    final parser = parserForType(type, indentationLevel: indentationLevel);
    return '${indentation(level: indentationLevel)}$name: ${parser.parse(value)}';
  }

  @override
  String toString() {
    return 'ExtensionPropertyValue(name: $name, value: $value, type: $type)';
  }

  @override
  String get flutterType => parserForType(type).flutterType;
}
