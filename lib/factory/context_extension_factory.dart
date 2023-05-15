import 'package:design_tokens_builder/factory/extension_factory.dart';
import 'package:design_tokens_builder/utils/string_utils.dart';

/// Generates an extension on `BuildContext` to access extensions and theme
/// properties more easily.
String buildContextExtension(Map<String, dynamic> tokens) {
  final extensions = getExtensions(tokens);
  var extensionShortcuts = <String>[];
  var extensionPart = '';

  if (extensions.isNotEmpty) {
    for (final entry in extensions.entries) {
      final name = buildExtensionName(entry);
      extensionShortcuts.add(
          '$name get ${name.firstLowerCased} => theme.extension<$name>()!;');
    }

    extensionPart += '// Extension shortcuts.\n  ';
    extensionPart += extensionShortcuts.join('\n');
    extensionPart += '\n\n  ';
  }

  return '''extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  
  $extensionPart// Theme shortcuts.
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
}''';
}
