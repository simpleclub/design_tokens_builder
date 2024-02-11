import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/utils/token_set_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Get token sets', () {
    final themeDataSetConfig =
        TokenSetConfig(prefix: '', type: TokenSetType.themeData);
    final customDataSetConfig =
        TokenSetConfig(prefix: 'custom', type: TokenSetType.themeData);
    final sourceSetConfig =
        TokenSetConfig(prefix: 'global', type: TokenSetType.source);
    final flutterSetConfig =
        TokenSetConfig(prefix: 'flutter', type: TokenSetType.flutter);
    final config = BuilderConfig(
      tokenSetConfigs: [
        themeDataSetConfig,
        customDataSetConfig,
        sourceSetConfig,
        flutterSetConfig,
      ],
    );

    test('succeeds', () {
      final result = getTokenSets(
        {
          r'$metadata': {
            'tokenSetOrder': ['global', 'light', 'dark'],
          },
        },
        config: config,
      );

      expect(result, {
        themeDataSetConfig: ['light', 'dark'],
      });

      final result2 = getTokenSets(
        {
          r'$metadata': {
            'tokenSetOrder': ['global', 'light', 'dark'],
          },
        },
        includeSourceSet: true,
        config: config,
      );

      expect(result2, {
        sourceSetConfig: ['global'],
        themeDataSetConfig: ['light', 'dark'],
      });
    });

    test('succeeds with prioritisation', () {
      final data = {
        r'$metadata': {
          'tokenSetOrder': ['light', 'dark', 'global'],
        },
      };

      final result1 = getTokenSets(
        data,
        config: config,
        includeSourceSet: true,
        prioritisedSet: 'dark',
      );

      expect(result1, {
        sourceSetConfig: ['global'],
        themeDataSetConfig: ['dark', 'light'],
      });

      final result2 = getTokenSets(
        data,
        config: config,
        includeSourceSet: true,
        prioritisedSet: 'light',
      );

      expect(result2, {
        sourceSetConfig: ['global'],
        themeDataSetConfig: ['light', 'dark'],
      });
    });

    test('succeeds without default theme', () {
      final result = getTokenSets(
        {
          r'$metadata': {
            'tokenSetOrder': ['light', 'dark'],
          },
        },
        config: config,
      );

      expect(result, {
        themeDataSetConfig: ['light', 'dark'],
      });
    });

    test('succeeds with getting specific set types', () {
      final result = getTokenSets(
        {
          r'$metadata': {
            'tokenSetOrder': ['light', 'dark', 'global'],
          },
        },
        includeSourceSet: true,
        setType: TokenSetType.themeData,
        config: config,
      );

      expect(result, {
        themeDataSetConfig: ['light', 'dark'],
      });

      final result2 = getTokenSets(
        {
          r'$metadata': {
            'tokenSetOrder': ['light', 'dark', 'global'],
          },
        },
        includeSourceSet: true,
        setType: TokenSetType.source,
        config: config,
      );

      expect(result2, {
        sourceSetConfig: ['global'],
      });
    });

    test('succeeds with custom', () {
      final result = getTokenSets(
        {
          r'$metadata': {
            'tokenSetOrder': ['light', 'dark', 'custom'],
          },
        },
        config: config,
      );

      expect(result, {
        customDataSetConfig: [''],
        themeDataSetConfig: ['light', 'dark'],
      });
    });

    test('succeeds with flutter tokenSet', () {
      final result1 = getTokenSets(
        {
          r'$metadata': {
            'tokenSetOrder': ['light', 'dark', 'flutter'],
          },
        },
        includeFlutterMappingSet: false,
        config: config,
      );

      expect(result1, {
        themeDataSetConfig: ['light', 'dark'],
      });

      final result2 = getTokenSets(
        {
          r'$metadata': {
            'tokenSetOrder': ['light', 'dark', 'flutter'],
          },
        },
        includeFlutterMappingSet: true,
        config: config,
      );

      expect(result2, {
        flutterSetConfig: ['flutter'],
        themeDataSetConfig: ['light', 'dark'],
      });
    });
  });

  group('Override and merge token set', () {
    test('works properly', () {
      final result = overrideAndMergeTokenSet(
        {
          'key1': 'value1',
          'key2': 'value2',
        },
        withSet: {
          'key2': 'newValue2',
          'key3': 'value3',
        },
      );

      expect(result, {
        'key1': 'value1',
        'key2': 'newValue2',
        'key3': 'value3',
      });
    });
  });

  group('Has nested type', () {
    test('succeeds', () {
      final result = hasNestedType(
        const MapEntry(
          'display',
          {
            'small': {
              '1': {
                'type': 'someType',
              },
            },
          },
        ),
        type: 'someType',
      );

      expect(result, true);
    });

    test('fails', () {
      final result = hasNestedType(
        const MapEntry(
          'display',
          {
            'type': 'otherType',
          },
        ),
        type: 'someType',
      );

      expect(result, false);
    });
  });

  group('Get tokens of type', () {
    test('succeeds', () {
      final result = getTokensOfType(
        'someType',
        tokenSetData: {
          'small': {'value': 'Some value', 'type': 'someType'},
          'medium': {'value': 'Some value', 'type': 'someType 3'},
          'display': {
            'large': {'value': 'Some value', 'type': 'someType'},
          },
        },
      );

      expect(result, {
        'small': {'value': 'Some value', 'type': 'someType'},
        'display': {
          'large': {'value': 'Some value', 'type': 'someType'},
        },
      });
      expect(result['medium'], null);
    });

    test('succeeds with fallback', () {
      final result = getTokensOfType(
        'someType',
        tokenSetData: {
          'small': {'value': 'Some new value', 'type': 'someType'},
          'medium': {'value': 'Some value', 'type': 'someType 3'},
          'display': {
            'large': {'value': 'Some value', 'type': 'someType'},
          },
        },
        fallbackSetData: {
          'small': {'value': 'Some value', 'type': 'someType'},
          'large': {'value': 'Some value', 'type': 'someType'},
        },
      );

      expect(result.keys.length, 3);
      expect(result['small'], {'value': 'Some new value', 'type': 'someType'});
      expect(result['large'], {'value': 'Some value', 'type': 'someType'});
      expect(result['display'], {
        'large': {'value': 'Some value', 'type': 'someType'},
      });
      expect(result['medium'], null);
    });
  });
}
