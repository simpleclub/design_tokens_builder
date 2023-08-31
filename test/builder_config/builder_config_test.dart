import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('Parsing builder config', () {
    test('succeeds', () {
      final yaml = YamlMap.wrap({
        'tokenFilePath': 'some/path',
        'defaultSetName': 'core',
        'fontConfig': [
          {'family': 'First Font', 'flutterName': 'FirstFont'},
          {'family': 'Second Font', 'flutterName': 'SecondFont'},
        ],
      });

      expect(
        BuilderConfig.fromYaml(yaml),
        BuilderConfig(
          sourceSetName: 'core',
          fontConfig: [
            FontConfig(family: 'First Font', flutterName: 'FirstFont'),
            FontConfig(family: 'Second Font', flutterName: 'SecondFont'),
          ],
        ),
      );
    });

    test('succeeds with default values', () {
      final yaml = YamlMap.wrap({
        'tokenFilePath': 'some/path',
      });

      expect(
        BuilderConfig.fromYaml(yaml),
        BuilderConfig(
          sourceSetName: 'global',
          fontConfig: [],
        ),
      );
    });
  });
}
