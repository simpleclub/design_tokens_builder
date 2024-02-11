import 'package:collection/collection.dart';
import 'package:design_tokens_builder/utils/string_utils.dart';
import 'package:yaml/yaml.dart';

/// Fallback value for `defaultSetName` config.
const _fallbackDefaultSetName = 'global';

/// Class representing the structure of the required builder config file
/// `tokenbuilder.yaml`.
class BuilderConfig {
  /// Constructs a [BuilderConfig].
  BuilderConfig({
    required this.tokenSetConfigs,
    this.fontConfig = const [],
  });

  /// Constructs a [BuilderConfig] from a [yaml].
  BuilderConfig.fromYaml(YamlMap yaml)
      : assert(
          yaml['tokenSetConfigs']
              .any((e) => e['type'] == TokenSetType.source.name),
          'At least one source token set must be defined in tokenSetConfigs.',
        ),
        fontConfig = (yaml['fontConfig'] ?? [])
            .map((e) => FontConfig.fromYaml(e))
            .toList()
            .cast<FontConfig>(),
        tokenSetConfigs = (yaml['tokenSetConfigs'] ?? [])
            .map((e) => TokenSetConfig.fromYaml(e))
            .toList()
            .cast<TokenSetConfig>();

  final List<TokenSetConfig> tokenSetConfigs;

  /// The config of the font the tokens use.
  final List<FontConfig> fontConfig;

  TokenSetConfig get sourceSetConfig =>
      tokenSetConfigs.firstWhere((e) => e.type == TokenSetType.source);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BuilderConfig &&
          runtimeType == other.runtimeType &&
          DeepCollectionEquality().equals(fontConfig, other.fontConfig);

  @override
  int get hashCode => tokenSetConfigs.hashCode ^ fontConfig.hashCode;

  @override
  String toString() {
    return 'BuilderConfig(tokenSetConfigs: ${tokenSetConfigs.toString()}, fontConfig: ${fontConfig.toString()})';
  }
}

enum TokenSetType {
  source(1),
  flutter(2),
  extension(3),
  themeData(4);

  const TokenSetType(this.sortPriority);

  final int sortPriority;
}

class TokenSetConfig {
  const TokenSetConfig({
    required this.prefix,
    required this.type,
  });

  TokenSetConfig.fromYaml(YamlMap yaml)
      : prefix = yaml['prefix'] as String? ?? '',
        type = TokenSetType.values.firstWhere(
          (e) => e.name == yaml['type'],
        );

  final String prefix;
  final TokenSetType type;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenSetConfig &&
          runtimeType == other.runtimeType &&
          prefix == other.prefix &&
          type == other.type;

  @override
  int get hashCode => prefix.hashCode ^ type.hashCode;

  @override
  String toString() {
    return 'TokenSetConfig(prefix: $prefix, type: $type)';
  }

  String setName(String name) {
    if (type == TokenSetType.source || type == TokenSetType.flutter) {
      return name;
    }

    return prefix + (prefix.isNotEmpty ? name.firstUpperCased : name);
  }
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

  @override
  String toString() {
    return 'FontConfig(family: $family, flutterName: $flutterName, package: $package)';
  }
}
