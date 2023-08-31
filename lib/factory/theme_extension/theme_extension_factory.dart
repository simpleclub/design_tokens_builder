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
}) {
  List<ExtensionProperty> extensions = [];

  final tokenSets = getTokenSets(
    tokens,
    includeSourceSet: false,
    config: config,
  );
  for (final tokenSet in tokenSets) {
    final setData = tokens[tokenSet] as Map<String, dynamic>;
    var extensionProperties = buildExtensionPropertyList(setData);
    // Only keep classes for top level since we won't create global variables
    // for single tokens.
    extensionProperties
        .removeWhere((element) => element is ExtensionPropertyValue);

    for (final property in extensionProperties) {
      if (!extensions.any((element) => element.name == property.name)) {
        extensions.add(property);
      }
    }
  }

  return extensions.cast<ExtensionPropertyClass>();
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
      return ExtensionPropertyValue(
        name: name,
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
