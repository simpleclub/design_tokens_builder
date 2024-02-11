import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('Parsing builder config', () {
    test('succeeds', () {
      final yaml = YamlMap.wrap({
        'tokenFilePath': 'some/path',
        'tokenSetConfigs': [
          {'prefix': 'themeDate', 'type': 'themeData'},
          {'prefix': 'core', 'type': 'source'},
          {'prefix': 'platform', 'type': 'extension'},
          {'prefix': 'flutterMapping', 'type': 'flutter'},
        ],
        'fontConfig': [
          {'family': 'First Font', 'flutterName': 'FirstFont'},
          {'family': 'Second Font', 'flutterName': 'SecondFont'},
        ],
      });

      expect(
        BuilderConfig.fromYaml(yaml),
        BuilderConfig(
          tokenSetConfigs: [
            TokenSetConfig(prefix: 'themeDate', type: TokenSetType.themeData),
            TokenSetConfig(prefix: 'core', type: TokenSetType.source),
            TokenSetConfig(prefix: 'platform', type: TokenSetType.extension),
            TokenSetConfig(
                prefix: 'flutterMapping', type: TokenSetType.flutter),
          ],
          fontConfig: [
            FontConfig(family: 'First Font', flutterName: 'FirstFont'),
            FontConfig(family: 'Second Font', flutterName: 'SecondFont'),
          ],
        ),
      );
    });

    test('succeeds with default values', () {
      final yaml = YamlMap.wrap({
        'tokenSetConfigs': [
          {'prefix': 'core', 'type': 'source'},
        ],
        'tokenFilePath': 'some/path',
      });

      expect(
        BuilderConfig.fromYaml(yaml),
        BuilderConfig(
          tokenSetConfigs: [
            TokenSetConfig(prefix: 'core', type: TokenSetType.source),
          ],
          fontConfig: [],
        ),
      );
    });

    test('fails without source token set config set', () {
      final yaml = YamlMap.wrap({
        'tokenSetConfigs': [],
        'tokenFilePath': 'some/path',
      });

      expect(
        () => BuilderConfig.fromYaml(yaml),
        throwsAssertionError,
      );
    });
  });
}
