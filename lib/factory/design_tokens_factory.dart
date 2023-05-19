import 'dart:async';
import 'dart:convert';

import 'package:design_tokens_builder/factory/context_extension_factory.dart';
import 'package:design_tokens_builder/factory/token_set_factory.dart';
import 'package:design_tokens_builder/factory/extension_factory.dart' as ef;
import 'package:design_tokens_builder/utils/transformer_utils.dart';
import 'package:glob/glob.dart';
import 'package:build/build.dart';
import 'package:yaml/yaml.dart';

Builder designTokensFactory(BuilderOptions _) => DesignTokensFactory();

/// Builder for generating tokens based on design token data.
class DesignTokensFactory implements Builder {
  @override
  final Map<String, List<String>> buildExtensions = {
    r'$lib$': ['tokens.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final configFile =
        (await buildStep.findAssets(Glob('lib/tokenbuilder.yaml')).toList())
            .first;
    final configString = await buildStep.readAsString(configFile);
    final config = loadYaml(configString);
    final tokenFilePath = config['tokenFilePath'];

    final tokenAsset = await buildStep.findAssets(Glob(tokenFilePath)).toList();
    final string = await buildStep.readAsString(tokenAsset.first);
    final token = jsonDecode(string);

    final processedToken = prepareTokens(token);

    await buildStep.writeAsString(
      AssetId(buildStep.inputId.package, 'lib/tokens.dart'),
      '''// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:flutter/material.dart';

const attributes = ${buildAttributeMap(processedToken['global'], config)};

abstract class GeneratedThemeData {
  ThemeData get themeData;
}

class BrightnessAdapted<T> {
  const BrightnessAdapted({required this.light, required this.dark});

  final T light;
  final T dark;
}

${buildTokenSet(processedToken, config: config)}

${ef.buildExtensions(processedToken)}

${buildContextExtension(processedToken)}''',
    );
  }
}
