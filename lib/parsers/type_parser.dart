import 'package:design_tokens_builder/parsers/design_token_parser.dart';

extension DesignTokenMap on Map<String, dynamic> {
  String get flutterType {
    if (!containsKey('type')) {
      throw Exception(
          'No \'type\' key found. Needed in order to figure out flutter represented type.');
    }

    final type = this['type'] as String;
    try {
      return parserForType(type).flutterType;
    } catch (e) {
      throw Exception('No flutter represented type found for type $type.');
    }
  }
}
