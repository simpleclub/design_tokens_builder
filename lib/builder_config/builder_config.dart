import 'package:collection/collection.dart';
import 'package:yaml/yaml.dart';

/// Fallback value for `defaultSetName` config.
const _fallbackDefaultSetName = 'global';

/// Class representing the structure of the required builder config file
/// `tokenbuilder.yaml`.
class BuilderConfig {
  /// Constructs a [BuilderConfig].
  BuilderConfig({
    this.defaultSetName = _fallbackDefaultSetName,
    this.fontConfig = const [],
  });

  /// Constructs a [BuilderConfig] from a [yaml].
  BuilderConfig.fromYaml(YamlMap yaml)
      : defaultSetName = yaml['defaultSetName'] ?? _fallbackDefaultSetName,
        fontConfig = (yaml['fontConfig'] ?? [])
            .map((e) => FontConfig.fromYaml(e))
            .toList()
            .cast<FontConfig>();

  /// The name of the default set.
  ///
  /// Used for populating general accessible tokens. No ThemeData gets generated
  /// for this set.
  final String defaultSetName;

  /// The config of the font the tokens use.
  final List<FontConfig> fontConfig;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BuilderConfig &&
          runtimeType == other.runtimeType &&
          defaultSetName == other.defaultSetName &&
          DeepCollectionEquality().equals(fontConfig, other.fontConfig);

  @override
  int get hashCode => defaultSetName.hashCode ^ fontConfig.hashCode;
}

/// Class representing the configuration of fonts used in design token.
class FontConfig {
  /// Constructs a [FontConfig].
  FontConfig({
    required this.family,
    required this.flutterName,
    this.package,
  });

  /// Constructs a [FontConfig] from a [yaml].
  FontConfig.fromYaml(YamlMap map)
      : family = map['family'] as String,
        flutterName = map['flutterName'] as String,
        package = map['package'] as String?;

  /// The family name as seen in Figma.
  final String family;

  /// The name of the family according to the definition in your `pubspec.yaml`.
  final String flutterName;

  /// The package where the font files are found.
  ///
  /// `package` property on `TextStyle` will not be set if `null`.
  final String? package;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FontConfig &&
          runtimeType == other.runtimeType &&
          family == other.family &&
          flutterName == other.flutterName &&
          package == other.package;

  @override
  int get hashCode => family.hashCode ^ flutterName.hashCode ^ package.hashCode;
}
