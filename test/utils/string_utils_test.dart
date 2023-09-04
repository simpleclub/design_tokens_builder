import 'package:design_tokens_builder/utils/string_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('to capitalized', () => expect('someText'.toCapitalized(), 'Sometext'));

  test('first upper cased',
      () => expect('someText'.firstUpperCased, 'SomeText'));

  test('first lower cased',
      () => expect('SomeText'.firstLowerCased, 'someText'));

  test('indentation', () => expect(indentation(level: 4), '        '));
}
