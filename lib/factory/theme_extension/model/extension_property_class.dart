import 'package:design_tokens_builder/factory/theme_extension/model/extension_property.dart';
import 'package:design_tokens_builder/factory/theme_extension/model/extension_property_value.dart';
import 'package:design_tokens_builder/factory/theme_extension/theme_extension_factory.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';
import 'package:design_tokens_builder/utils/string_utils.dart';

/// A property that can be used in a theme extension representing a class.
class ExtensionPropertyClass extends ExtensionProperty {
  /// Default constructor.
  ExtensionPropertyClass({
    required super.name,
    required this.prefixedName,
    required this.properties,
  });

  /// The name of the property with a prefix.
  ///
  /// E.g. if the name is `background` [prefixedName] could be
  /// `colorBackground`.
  final String prefixedName;

  /// A list of properties of the class.
  final List<ExtensionProperty> properties;

  @override
  String build({int indentationLevel = 0, bool includeName = false}) {
    final prefix =
        includeName ? '${indentation(level: indentationLevel)}$name: ' : '';
    return '$prefix${buildExtensionName(prefixedName)}(\n${properties.map((e) => e.build(indentationLevel: indentationLevel + 1, includeName: true)).join(',\n')},\n${indentation(level: indentationLevel)})';
  }

  /// Builds the the class representation of the property.
  String buildClasses() {
    final className = buildExtensionName(prefixedName);
    var result = '''
class $className extends ThemeExtension<$className> {
  const $className({
    ${properties.map((e) => 'required this.${e.name}').join(',\n${indentation(level: 2)}')},\n
  });
  
  ${properties.map((e) => 'final ${e.flutterType} ${e.name};').join('\n${indentation()}')}
  
  @override
  $className copyWith({
    ${properties.map((e) => '${e.flutterType}? ${e.name},').join('\n${indentation(level: 2)}')}
  }) {
    return $className(
      ${properties.map((e) => '${e.name}: ${e.name} ?? this.${e.name},').join('\n${indentation(level: 3)}')}
    );
  }

  @override
  $className lerp($className? other, double t) {
    if (other is! $className) {
      return this;
    }
    return $className(
      ${properties.map((e) => '${e.name}: ${_buildLerpForProperty(e, indentationLevel: 3)},').join('\n${indentation(level: 3)}')}
    );
  }
}
''';

    final containedClasses = properties.whereType<ExtensionPropertyClass>();
    if (containedClasses.isNotEmpty) {
      result += containedClasses.map((e) => e.buildClasses()).join('\n');
    }

    return result;
  }

  String _buildLerpForProperty(
    ExtensionProperty property, {
    int indentationLevel = 0,
  }) {
    if (property is ExtensionPropertyValue) {
      final parser =
          parserForType(property.type, indentationLevel: indentationLevel);
      return parser.buildLerp(property.name);
    } else if (property is ExtensionPropertyClass) {
      return '${property.name}.lerp(other.${property.name}, t)';
    }

    throw ('Unknown property type: $property');
  }

  @override
  String get flutterType => buildExtensionName(prefixedName);

  @override
  String toString() {
    return 'ExtensionPropertyClass(name: $name, prefixedName: $prefixedName, properties: [${properties.join(', ')}])';
  }

  @override
  List<Object> get props => [...super.props, prefixedName, properties];
}
