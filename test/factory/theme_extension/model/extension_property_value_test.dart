import 'package:design_tokens_builder/factory/theme_extension/model/extension_property_value.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final extensionPropertyValue = ExtensionPropertyValue(
    name: 'someValue',
    value: '42',
    type: 'number',
  );

  test('class setup', () {
    expect(extensionPropertyValue.flutterType, 'double');
    expect(
      extensionPropertyValue.toString(),
      'ExtensionPropertyValue(name: someValue, value: 42, type: number)',
    );
    expect(extensionPropertyValue == extensionPropertyValue, true);
  });

  group('build', () {
    test(
      'succeeds with include name',
      () => expect(
        extensionPropertyValue.build(includeName: true),
        'someValue: 42.0',
      ),
    );

    test(
      'succeeds without include name',
      () => expect(
        extensionPropertyValue.build(),
        // We actually test with the same result as when including the name
        // since for a value we always want to include the name and therefore
        // ignoring includeName.
        'someValue: 42.0',
      ),
    );
  });
}
