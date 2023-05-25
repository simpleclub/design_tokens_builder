import 'package:equatable/equatable.dart';
import 'package:yaml/yaml.dart';

/// Fallback value for `defaultSetName` config.
const _fallbackDefaultSetName = 'global';

String _tokenFilePath(YamlMap yaml) {
  if (!yaml.containsKey('tokenFilePath')) {
    throw Exception(
      'Unable to parse tokenbuilder.yaml due to missing required tokenFilePath key',
    );
  }

  return yaml['tokenFilePath'];
}

/// Class representing the structure of the required builder config file
/// `tokenbuilder.yaml`.
class BuilderConfig extends Equatable {
  /// Constructs a [BuilderConfig].
  BuilderConfig({
    required this.tokenFilePath,
    this.defaultSetName = _fallbackDefaultSetName,
    this.fontConfig = const [],
  });

  /// Constructs a [BuilderConfig] from a [yaml].
  BuilderConfig.fromYaml(YamlMap yaml)
      : tokenFilePath = _tokenFilePath(yaml),
        defaultSetName = yaml['defaultSetName'] ?? _fallbackDefaultSetName,
        fontConfig = (yaml['fontConfig'] ?? [])
            .map((e) => FontConfig.fromYaml(e))
            .toList()
            .cast<FontConfig>();

  /// The path leading to the json file containing the token data.
  final String tokenFilePath;

  /// The name of the default set.
  ///
  /// Used for populating general accessible tokens. No ThemeData gets generated
  /// for this set.
  final String defaultSetName;

  /// The config of the font the tokens use.
  final List<FontConfig> fontConfig;

  @override
  List<Object?> get props => [
        tokenFilePath,
        defaultSetName,
        fontConfig,
      ];
}

/// Class representing the configuration of fonts used in design token.
class FontConfig extends Equatable {
  /// Constructs a [FontConfig].
  FontConfig({required this.family, required this.flutterName});

  /// Constructs a [FontConfig] from a [yaml].
  FontConfig.fromYaml(YamlMap map)
      : family = map['family'] as String,
        flutterName = map['flutterName'] as String;

  /// The family name as seen in Figma.
  final String family;

  /// The name of the family according to the definition in your `pubspec.yaml`.
  final String flutterName;

  @override
  List<Object?> get props => [
        family,
        flutterName,
      ];
}
