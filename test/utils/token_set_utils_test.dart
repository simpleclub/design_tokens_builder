import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/utils/token_set_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Get token sets', () {
    final config = BuilderConfig(sourceSetName: 'global');

    test('succeeds', () {
      final result = getTokenSets(
        {
          r'$metadata': {
            'tokenSetOrder': ['global', 'light', 'dark'],
          },
        },
        config: config,
      );

      expect(result, ['light', 'dark']);
    });

    test('succeeds with prioritisation', () {
      final data = {
        r'$metadata': {
          'tokenSetOrder': ['light', 'dark', 'core'],
        },
      };

      final result1 = getTokenSets(
        data,
        config: config,
        prioritisedSet: 'dark',
      );

      expect(result1, ['dark', 'light', 'core']);

      final result2 = getTokenSets(
        data,
        config: config,
        prioritisedSet: 'light',
      );

      expect(result2, ['light', 'dark', 'core']);
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

      expect(result, ['light', 'dark']);
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
