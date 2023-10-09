import 'package:design_tokens_builder/parsers/design_token_parser.dart';

/// Parses tokens of type `fontWeights` to Flutter code.
///
/// The font weight needs to be part of the specified [_allowedWeights] in order
/// to be parsed correctly.
///
/// E.g.
/// Figma design tokens:
///   "value": "400"
///
/// Flutter generated code:
///   FontWeight.w400
class FontWeightParser extends DesignTokenParser {
  /// Constructs a [FontWeightParser].
  FontWeightParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => ['fontWeights'];

  @override
  String flutterType([dynamic value]) => 'FontWeight';

  final _allowedWeights = [100, 200, 300, 400, 500, 600, 700, 800, 900];

  @override
  String buildValue(value) {
    if (value is String) {
      final abs = double.parse(value).toInt();

      if (_allowedWeights.contains(abs)) {
        return 'FontWeight.w$abs';
      } else {
        throw Exception(
          'Unsupported font weight: $value. Please use one of these weights: 100, 200, 300, 400, 500, 600, 700, 800, 900.',
        );
      }
    }

    throw Exception('Unable to parse font weight with data: $value');
  }
}
