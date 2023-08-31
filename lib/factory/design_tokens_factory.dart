import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/factory/context_extension_factory.dart';
import 'package:design_tokens_builder/factory/theme_extension/theme_extension_factory.dart'
    as ef;
import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:design_tokens_builder/utils/transformer_utils.dart';
import 'package:glob/glob.dart';
import 'package:yaml/yaml.dart';

/// Main builder.
Builder designTokensFactory(BuilderOptions _) => DesignTokensFactory();

/// Builder for generating tokens based on design token data.
class DesignTokensFactory implements Builder {
  @override
  final Map<String, List<String>> buildExtensions = {
    'tokens.json': ['tokens.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final outputId = inputId.changeExtension('.dart');
    final configFile =
        (await buildStep.findAssets(Glob('**/tokenbuilder.yaml')).toList())
            .first;
    final configString = await buildStep.readAsString(configFile);
    final yaml = loadYaml(configString) as YamlMap;
    final config = BuilderConfig.fromYaml(yaml);

    final string = await buildStep.readAsString(inputId);
    final token = jsonDecode(string) as Map<String, dynamic>;

    final processedToken = prepareTokens(token);
    final processedDefaultSet = processedToken[config.sourceSetName];

    await buildStep.writeAsString(
      outputId,
      '''// GENERATED CODE - DO NOT MODIFY BY HAND

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final attributes = ${buildAttributeMap(processedDefaultSet, config)};

abstract class GeneratedThemeData {
  const GeneratedThemeData();

  ThemeData get themeData;
}

class BrightnessAdapted<T> {
  const BrightnessAdapted({required this.light, required this.dark});

  final T light;
  final T dark;
}

${buildTokenSet(processedToken, config: config)}

${ef.buildExtensions(processedToken, config: config)}

${buildContextExtension(processedToken, config: config)}\n''',
    );
  }
}
