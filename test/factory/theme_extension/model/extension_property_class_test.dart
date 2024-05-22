import 'package:design_tokens_builder/factory/theme_extension/model/extension_property_class.dart';
import 'package:design_tokens_builder/factory/theme_extension/model/extension_property_value.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final emptyExtensionPropertyClass = ExtensionPropertyClass(
    name: 'name',
    prefixedName: 'someName',
    properties: [],
  );
  final extensionPropertyClass = ExtensionPropertyClass(
    name: 'name',
    prefixedName: 'someName',
    properties: [
      ExtensionPropertyClass(
        name: 'otherName',
        prefixedName: 'someOtherName',
        properties: [
          ExtensionPropertyValue(
            name: 'someValue',
            value: '42',
            type: 'number',
            modifier: null,
          ),
        ],
      ),
      ExtensionPropertyValue(
        name: 'someValue',
        value: '42',
        type: 'number',
        modifier: null,
      ),
    ],
  );

  test('class setup', () {
    expect(extensionPropertyClass.flutterType, 'SomeNameThemeExtension');
    expect(
      extensionPropertyClass.toString(),
      'ExtensionPropertyClass(name: name, prefixedName: someName, properties: [ExtensionPropertyClass(name: otherName, prefixedName: someOtherName, properties: [ExtensionPropertyValue(name: someValue, value: 42, type: number)]), ExtensionPropertyValue(name: someValue, value: 42, type: number)])',
    );
    expect(extensionPropertyClass == extensionPropertyClass, true);
    expect(extensionPropertyClass != emptyExtensionPropertyClass, true);
  });

  group('build', () {
    test(
      'succeeds with include name',
      () => expect(
        emptyExtensionPropertyClass.build(includeName: true),
        'name: SomeNameThemeExtension()',
      ),
    );

    test(
      'succeeds without include name',
      () => expect(
        emptyExtensionPropertyClass.build(),
        'SomeNameThemeExtension()',
      ),
    );

    test(
      'succeeds with one property',
      () {
        expect(
          extensionPropertyClass.build(),
          'SomeNameThemeExtension(\n  otherName: SomeOtherNameThemeExtension(\n    someValue: 42.0,\n  ),\n  someValue: 42.0,\n)',
        );
      },
    );
  });

  group('build class', () {
    test(
      'succeeds with one property',
      () => expect(extensionPropertyClass.buildClasses(), '''
class SomeNameThemeExtension extends ThemeExtension<SomeNameThemeExtension> {
  const SomeNameThemeExtension({
    required this.otherName,
    required this.someValue,
  });

  final SomeOtherNameThemeExtension otherName;
  final double someValue;

  @override
  SomeNameThemeExtension copyWith({
    SomeOtherNameThemeExtension? otherName,
    double? someValue,
  }) {
    return SomeNameThemeExtension(
      otherName: otherName ?? this.otherName,
      someValue: someValue ?? this.someValue,
    );
  }

  @override
  SomeNameThemeExtension lerp(SomeNameThemeExtension? other, double t) {
    if (other is! SomeNameThemeExtension) {
      return this;
    }
    return SomeNameThemeExtension(
      otherName: otherName.lerp(other.otherName, t),
      someValue: lerpDouble(someValue, other.someValue, t) ?? other.someValue,
    );
  }
}

class SomeOtherNameThemeExtension extends ThemeExtension<SomeOtherNameThemeExtension> {
  const SomeOtherNameThemeExtension({
    required this.someValue,
  });

  final double someValue;

  @override
  SomeOtherNameThemeExtension copyWith({
    double? someValue,
  }) {
    return SomeOtherNameThemeExtension(
      someValue: someValue ?? this.someValue,
    );
  }

  @override
  SomeOtherNameThemeExtension lerp(SomeOtherNameThemeExtension? other, double t) {
    if (other is! SomeOtherNameThemeExtension) {
      return this;
    }
    return SomeOtherNameThemeExtension(
      someValue: lerpDouble(someValue, other.someValue, t) ?? other.someValue,
    );
  }
}
'''),
    );
  });

  group('build lerp for property', () {
    test(
      'succeeds for class',
      () => expect(
        extensionPropertyClass.buildLerpForProperty(extensionPropertyClass),
        'name.lerp(other.name, t)',
      ),
    );

    test(
      'succeeds for value',
      () => expect(
        extensionPropertyClass
            .buildLerpForProperty(extensionPropertyClass.properties.last),
        'lerpDouble(someValue, other.someValue, t) ?? other.someValue',
      ),
    );
  });
}
