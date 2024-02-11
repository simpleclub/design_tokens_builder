import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/factory/theme_extension/theme_extension_factory.dart';
import 'package:design_tokens_builder/utils/string_utils.dart';

/// Generates an extension on `BuildContext` to access extensions and theme
/// properties more easily.
String buildContextExtension(
  Map<String, dynamic> tokens, {
  required BuilderConfig config,
}) {
  print('  - Build context extensions');
  final extensions = getExtensions(tokens, config: config);
  var extensionShortcuts = <String>[];
  var extensionPart = '';

  if (extensions.isNotEmpty) {
    for (final extension in extensions) {
      final name = buildExtensionName(extension.prefixedName);
      extensionShortcuts.add(
        '$name get ${extension.name} => theme.${extension.name}!;',
      );
    }

    extensionPart += extensionShortcuts.join('\n${indentation()}');
    extensionPart += '\n${indentation()}';
  }

  return '''
extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ${extensionPart}ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
}''';
}
