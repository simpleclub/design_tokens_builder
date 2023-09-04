import 'package:design_tokens_builder/parsers/other_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = OtherParser();

  test('correct setup', () {
    expect(parser.tokenType, ['other']);
    expect(parser.flutterType, 'Duration');
  });

  group('build value', () {
    test('Parse different durations', () {
      final tests = {
        '42ms': 'milliseconds: 42',
        '42s': 'seconds: 42',
        '42m': 'minutes: 42',
        '42h': 'hours: 42',
        '42d': 'days: 42',
      };

      for (final test in tests.entries) {
        final result = parser.buildValue(test.key);
        expect(result, 'Duration(${test.value})');
      }
    });

    test('fails', () {
      expect(() => parser.buildValue('some'), throwsException);
    });
  });

  group('build lerp', () {
    test('succeeds', () {
      expect(
        parser.buildLerp('someOther'),
        'lerpDuration(someOther, other.someOther, t)',
      );
    });
  });
}
