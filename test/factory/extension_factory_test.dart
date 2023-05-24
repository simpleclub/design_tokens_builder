import 'package:design_tokens_builder/factory/extension_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Build extension name', () {
    final result = buildExtensionName('contentColors');
    expect(result, 'ContentColorsThemeExtension');
  });
}
