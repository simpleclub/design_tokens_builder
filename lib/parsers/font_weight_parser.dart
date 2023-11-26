import 'package:collection/collection.dart';
import 'package:design_tokens_builder/parsers/design_token_parser.dart';

/// [Figma FontWeight Data Type](https://www.figma.com/widget-docs/api/type-FontWeight).
enum FigmaFontWeight {
  /// Thin weight.
  thin(100, 'thin'),

  /// Extra light weight.
  extraLight(200, 'extra-light'),

  /// Light weight.
  light(300, 'light'),

  /// Normal weight.
  regular(400, 'regular'),

  /// Medium weight.
  medium(500, 'medium'),

  /// Semi bold weight.
  semiBold(600, 'semi-bold'),

  /// Bold weight.
  bold(700, 'bold'),

  /// Extra bold weight.
  extraBold(800, 'extra-bold'),

  /// Black weight.
  black(900, 'black');

  const FigmaFontWeight(this.numerical, this.string);

  /// The numerical value
  final int numerical;

  /// The String value
  final String string;

  /// Parse [source] as a FontWeight literal and return its value.
  ///
  /// Example:
  /// ```dart
  /// var value = FontWeight.tryParse('600'); // FontWeight.semiBold
  /// value = FontWeight.tryParse('semi-bold'); // FontWeight.semiBold
  /// value = FontWeight.tryParse('Semi Bold'); // FontWeight.semiBold
  /// value = FontWeight.tryParse('SemiBold'); // FontWeight.semiBold
  /// value = FontWeight.tryParse('650'); // null
  /// ```
  static FigmaFontWeight? tryParse(String source) {
    source = source.toLowerCase().replaceAll('-', '').replaceAll(' ', '');
    return FigmaFontWeight.values.singleWhereOrNull(
      (e) => e.numerical.toString() == source || e.string.replaceAll('-', '') == source,
    );
  }
}

/// Parses tokens of type `fontWeights` to Flutter code.
///
/// The font weight needs to be part of the specified [_allowedWeights] in order
/// to be parsed correctly.
///
/// E.g.
/// Figma design tokens:
///   "value": "400" or
///   "value": "Regular"
///
/// Flutter generated code:
///   FontWeight.w400
class FontWeightParser extends DesignTokenParser {
  /// Constructs a [FontWeightParser].
  FontWeightParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => ['fontWeights'];

  @override
  String get flutterType => 'FontWeight';

  final _allowedWeights = [100, 200, 300, 400, 500, 600, 700, 800, 900];

  @override
  String buildValue(value) {
    if (value is String) {
      late final abs = FigmaFontWeight.tryParse(value)?.numerical;

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
