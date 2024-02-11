import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/utils/string_utils.dart';
import 'package:design_tokens_builder/utils/token_set_utils.dart';

String buildThemeDataExtensions(
  Map<String, dynamic> tokens, {
  required BuilderConfig config,
}) {
  final extensions = getTokenSets(
    tokens,
    config: config,
    setType: TokenSetType.extension,
  );
  var output = '';
  var methods = <String>[];
  for (final extension in extensions.keys) {
    final extensionName = extension.prefix;
    final extensionClassName =
        '${extensionName.firstUpperCased}ExtensionTokenSet';
    methods.add(
        '''  ThemeData apply${extensionName.firstUpperCased}Extensions($extensionClassName $extensionName) {
    return overrideExtensionsWith($extensionName.extensions);
  }''');
  }

  output = methods.join('\n\n');

  if (output.isNotEmpty) {
    output = '\n\n$output';
  }

  return '''extension ExtensionOverrideThemeData on ThemeData {
  ThemeData overrideExtensionsWith(List<ThemeExtension<dynamic>> overrides) {
    var extensions = Map<Object, ThemeExtension<dynamic>>.from(this.extensions);

    for (final override in overrides) {
      extensions[override.type] = override;
    }

    // Delete all extensions where key is the type of the key of overrides.
    return copyWith(
      extensions: extensions.values,
    );
  }$output
}''';
}
