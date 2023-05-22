import 'package:design_tokens_builder/factory/extension_factory.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

void main() {
  test('Build extension name', () {
    const extensionEntry = MapEntry('content', [
      Tuple2('color1', {
        'value': '#000000',
        'type': 'color',
      })
    ]);

    final result = buildExtensionName(extensionEntry);
    expect(result, 'ContentColors');
  });
}
