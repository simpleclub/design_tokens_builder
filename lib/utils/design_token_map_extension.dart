import 'package:design_tokens_builder/parsers/design_token_parser.dart';

/// An extension on Map<String, dynamic> for handling a general map that is
/// created from the design token json.
extension DesignTokenMap on Map<String, dynamic> {
  /// Returns a parser according to the `type` key in the [DesignTokenMap].
  ///
  /// Throws exception when no parser was found for the type to parse.
  DesignTokenParser get parser {
    if (!containsKey('type')) {
      throw Exception(
        'No \'type\' key found. Needed in order to figure out Flutter represented type.',
      );
    }

    final type = this['type'] as String;
    return parserForType(type);
  }

  /// Returns the Flutter type according to the `type` key in the
  /// [DesignTokenMap].
  ///
  /// Throws exception when no type was found for the type to parse.
  String get flutterType {
    try {
      return parser.flutterType;
    } catch (e) {
      throw Exception(
        'No Flutter represented type found for type ${this['type']}.',
      );
    }
  }
}
