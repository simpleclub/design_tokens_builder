import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/factory/theme_extension/model/extension_property.dart';
import 'package:design_tokens_builder/factory/theme_extension/model/extension_property_class.dart';
import 'package:design_tokens_builder/factory/theme_extension/model/extension_property_value.dart';
import 'package:design_tokens_builder/utils/string_utils.dart';
import 'package:design_tokens_builder/utils/token_set_utils.dart';

/// Generates all extension.
///
/// Creates an extension for each token group that is not `sys`.
String buildExtensions(
  Map<String, dynamic> tokens, {
  required BuilderConfig config,
}) {
  final extensions = getExtensions(tokens, config: config);

  var output = extensions.map((e) => e.buildClasses()).join('\n\n');
  output += '''\nextension GeneratedTheme on ThemeData {
  ${extensions.map((e) {
    final extensionTypeName = buildExtensionName(e.prefixedName);
    final extensionVariableName = e.name;
    return '$extensionTypeName? get $extensionVariableName => extension<$extensionTypeName>();';
  }).join('\n${indentation(level: 1)}')}
}''';

  return output;
}

/// Returns the name for a single extension.
///
/// Consists out of the name of the custom group & its type.
/// E.g.
/// Design token:
/// ```
/// specialColors: {
///   color1: {
///     value: #000000,
///     type: color
///   }
/// }
/// ```
/// to name -> `SpecialColorsThemeExtension`
String buildExtensionName(String extensionName) {
  return '${extensionName.firstUpperCased}ThemeExtension';
}

/// Returns a map consisting of all available extensions.
///
/// The data is formatted as followed:
/// ```
/// {
///   extensionName: [
///     [
///       extensionProperty1,
///       {
///         value: #000000,
///         type: color
///       }
///     ],
///      [
///       extensionProperty2,
///       {
///         value: #ffffff,
///         type: color
///       }
///     ]
///   ]
/// }
/// ```
List<ExtensionPropertyClass> getExtensions(
  Map<String, dynamic> tokens, {
  required BuilderConfig config,
  String? prioritisedSet,
  String? prioritisedBrightness,
}) {
  List<ExtensionProperty> extensions = [];

  final tokenSets = getTokenSets(
    tokens,
    includeSourceSet: true,
    config: config,
    prioritisedSet: prioritisedSet,
    prioritisedBrightness: prioritisedBrightness,
  );

  for (final tokenSet in tokenSets) {
    if ((tokens[tokenSet] as Map).isNotEmpty) {
      final setData = tokens[tokenSet] as Map<String, dynamic>;
      var extensionProperties = buildExtensionPropertyList(setData);
      // Only keep classes for top level since we won't create global variables
      // for single tokens.
      extensionProperties
          .removeWhere((element) => element is ExtensionPropertyValue);

      for (final property in extensionProperties) {
        deepMergeProperty(extensions, withProperty: property);
      }
    }
  }

  return extensions.cast<ExtensionPropertyClass>();
}

/// Deep merges a property into a list of properties.
///
/// That means if the property already exists in the list, an it is a class,
/// we merge all of the properties by adding the ones that don't exist yet. This
/// works recursively with classes contained in a class.
void deepMergeProperty(
  List<ExtensionProperty> properties, {
  required ExtensionProperty withProperty,
}) {
  if (properties.any((element) => element.name == withProperty.name)) {
    final property = properties.firstWhere(
      (element) => element.name == withProperty.name,
    );

    if (property is ExtensionPropertyValue &&
        withProperty is ExtensionPropertyValue) {
      return;
    } else if (property is ExtensionPropertyValue &&
        withProperty is ExtensionPropertyClass) {
      return;
    } else if (property is ExtensionPropertyClass &&
        withProperty is ExtensionPropertyValue) {
      deepMergeProperty(property.properties, withProperty: withProperty);
    } else if (property is ExtensionPropertyClass &&
        withProperty is ExtensionPropertyClass) {
      for (final newProperty in withProperty.properties) {
        deepMergeProperty(property.properties, withProperty: newProperty);
      }
    }
  } else {
    properties.add(withProperty);
  }
}

/// Builds a list of [ExtensionProperty]s from a map recursively.
List<ExtensionProperty> buildExtensionPropertyList(
  Map<String, dynamic> data, {
  String namePrefix = '',
}) {
  return data.entries.map((entry) {
    final name = entry.key;
    final map = entry.value as Map<String, dynamic>;
    if (map.containsKey('value')) {
      // Check if name is solely numeric.
      final regexPattern = r'^[0-9]+$';
      final regex = RegExp(regexPattern);
      final solelyNumeric = regex.hasMatch(name);
      final prefixedName = solelyNumeric
          ? '${namePrefix.substring(0, 1)}${name.firstUpperCased}'
          : name;
      return ExtensionPropertyValue(
        name: prefixedName,
        value: map['value'],
        type: map['type'] as String,
      );
    } else {
      final prefixedName =
          namePrefix.isNotEmpty ? '$namePrefix${name.firstUpperCased}' : name;
      return ExtensionPropertyClass(
        name: name,
        prefixedName: prefixedName,
        properties: buildExtensionPropertyList(map, namePrefix: prefixedName),
      );
    }
  }).toList();
}
