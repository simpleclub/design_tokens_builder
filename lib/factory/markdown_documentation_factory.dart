import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/utils/transformer_utils.dart';
import 'package:glob/glob.dart';
import 'package:yaml/yaml.dart';

/// Builder for generating markdown documentation from design tokens.
Builder markdownDocumentationFactory(BuilderOptions _) =>
    MarkdownDocumentationFactory();

/// Builder for generating a Markdown file that documents all tokens with their
/// resolved values.
class MarkdownDocumentationFactory implements Builder {
  @override
  final Map<String, List<String>> buildExtensions = {
    r'$lib$': ['tokens.md'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final configFile =
        (await buildStep.findAssets(Glob('lib/tokenbuilder.yaml')).toList())
            .first;
    final configString = await buildStep.readAsString(configFile);
    final yaml = loadYaml(configString) as YamlMap;
    final config = BuilderConfig.fromYaml(yaml);
    final tokenFilePath = config.tokenFilePath;

    final tokenAsset = await buildStep.findAssets(Glob(tokenFilePath)).toList();
    final string = await buildStep.readAsString(tokenAsset.first);
    final token = jsonDecode(string);

    final processedToken = prepareTokens(token);

    await buildStep.writeAsString(
      AssetId(buildStep.inputId.package, 'lib/tokens.md'),
      _generateMarkdown(processedToken, config),
    );
  }

  /// Generates the markdown documentation from processed tokens.
  String _generateMarkdown(
    Map<String, dynamic> tokens,
    BuilderConfig config,
  ) {
    final buffer = StringBuffer();
    buffer.writeln('# Design Tokens Documentation');
    buffer.writeln();
    buffer.writeln(
      'This document lists all design tokens with their resolved values.',
    );
    buffer.writeln();

    // Process each token set
    for (final setEntry in tokens.entries) {
      final setName = setEntry.key;

      // Skip metadata entries
      if (setName.startsWith('\$')) continue;

      buffer.writeln('## Token Set: $setName');
      buffer.writeln();

      final setData = setEntry.value as Map<String, dynamic>;
      _processTokenGroup(buffer, setData, setName);
      buffer.writeln();
    }

    return buffer.toString();
  }

  /// Recursively processes a token group and adds entries to the buffer.
  void _processTokenGroup(
    StringBuffer buffer,
    Map<String, dynamic> group,
    String prefix,
  ) {
    for (final entry in group.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is Map<String, dynamic>) {
        // Check if this is a leaf token (has 'value' and 'type' keys)
        if (value.containsKey('value') && value.containsKey('type')) {
          final tokenPath = '$prefix.$key';
          final tokenValue = value['value'];
          final tokenType = value['type'];

          buffer.writeln('- **$tokenPath**');
          buffer.writeln('  - Type: `$tokenType`');
          buffer.writeln('  - Value: `$tokenValue`');
          buffer.writeln();
        } else {
          // This is a nested group, recurse
          _processTokenGroup(buffer, value, '$prefix.$key');
        }
      }
    }
  }
}
