import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/utils/design_token_map_extension.dart';
import 'package:design_tokens_builder/utils/string_utils.dart';
import 'package:design_tokens_builder/utils/token_set_utils.dart';
import 'package:tuple/tuple.dart';

/// Generates all extension.
///
/// Creates an extension for each token group that is not `sys`.
String buildExtensions(
  Map<String, dynamic> tokens, {
  required BuilderConfig config,
}) {
  final extensions = getExtensions(tokens, config: config);

  var output = '';
  for (final entry in extensions.entries) {
    final extension = entry.value;
    final name = buildExtensionName(entry.key);
    output += '''class $name extends ThemeExtension<$name> {
  $name({\n${extension.map((e) => '    required this.${e.item1}').join(',\n')},\n  });

${extension.map((e) => '  final ${e.item2.flutterType} ${e.item1};').join('\n')}

  @override
  $name copyWith({
${extension.map((e) => '    ${e.item2.flutterType}? ${e.item1},').join('\n')}
  }) {
    return $name(
${extension.map((e) => '      ${e.item1}: ${e.item1} ?? this.${e.item1},').join('\n')}
    );
  }

  @override
  $name lerp($name? other, double t) {
    if (other is! $name) {
      return this;
    }
    return $name(
${extension.map((e) => '${indentation(level: 3)}${e.item1}: ${e.item2.parser.buildLerp(e.item1)},').join('\n')}
    );
  }
}

''';
  }

  output += '''extension GeneratedTheme on ThemeData {
${extensions.keys.map((e) {
    final extensionTypeName = buildExtensionName(e);
    final extensionVariableName = e.firstLowerCased;
    return '  $extensionTypeName? get $extensionVariableName => extension<$extensionTypeName>();';
  }).join('\n')}
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
Map<String, List<Tuple2<String, Map<String, dynamic>>>> getExtensions(
  Map<String, dynamic> tokens, {
  required BuilderConfig config,
}) {
  Map<String, List<Tuple2<String, Map<String, dynamic>>>> extensions = {};

  final tokenSets = getTokenSets(
    tokens,
    includeDefaultSet: true,
    config: config,
  );
  for (final tokenSet in tokenSets) {
    final setData = tokens[tokenSet] as Map<String, dynamic>;
    final setDataKeys = setData.keys.toList()..remove('sys');
    for (final key in setDataKeys) {
      if (!extensions.keys.contains(key)) {
        final extension = setData[key] as Map<String, dynamic>;
        // Only create an extension when the key does not have an value and
        // therefore is a group.
        if (!extension.containsKey('value')) {
          extensions[key] = extension.keys
              .map((e) => Tuple2(e, setData[key][e] as Map<String, dynamic>))
              .toList();
        }
      }
    }
  }

  return extensions;
}
