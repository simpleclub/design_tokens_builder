import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/factory/theme_extension/theme_extension_factory.dart';

/// Generates an extension on `BuildContext` to access extensions and theme
/// properties more easily.
String buildContextExtension(
  Map<String, dynamic> tokens, {
  required BuilderConfig config,
}) {
  final extensions = getExtensions(tokens, config: config);
  var extensionShortcuts = <String>[];
  var extensionPart = '';

  return '';
//   if (extensions.isNotEmpty) {
//     for (final entry in extensions.entries) {
//       final name = buildExtensionName(entry.key);
//       extensionShortcuts.add(
//         '$name get ${entry.key.firstLowerCased} => theme.extension<$name>()!;',
//       );
//     }
//
//     extensionPart += extensionShortcuts.join('\n${indentation()}');
//     extensionPart += '\n${indentation()}';
//   }
//
//   return '''extension BuildContextExtension on BuildContext {
//   ThemeData get theme => Theme.of(this);
//
//   ${extensionPart}ColorScheme get colorScheme => theme.colorScheme;
//   TextTheme get textTheme => theme.textTheme;
// }''';
}
