import 'package:design_tokens_builder/parsers/design_token_parser.dart';

/// Parses any token with type other.
/// Supports parsing durations.
///
/// E.g.
/// Figma design tokens:
///   "value": "200ms"
///
/// Flutter generated code:
///   Duration(milliseconds: 200)
class OtherParser extends DesignTokenParser {
  /// Constructs a [OtherParser].
  OtherParser([super.indentationLevel, super.config]);

  @override
  List<String> get tokenType => [
        'other',
      ];

  @override
  String get flutterType => 'Duration';

  @override
  String buildLerp(String token) {
    return 'lerpDouble($token, other.$token, t) ?? other.$token';
  }

  @override
  String buildValue(value) {
    // Check if value is a duration.
    final regex = r'\b(\d+(\.\d+)?)\s*(ms|s|m|h|d)\b';
    final match = RegExp(regex).firstMatch(value);
    if (match != null) {
      print('Match group -> ${match.group(1)}');
      final durationValue = int.parse(match.group(1)!);
      final unit = match.group(3);
      var unitParam = '';

      switch (unit) {
        case 'ms':
          unitParam = 'milliseconds';
          break;
        case 's':
          unitParam = 'seconds';
          break;
        case 'm':
          unitParam = 'minutes';
          break;
        case 'h':
          unitParam = 'hours';
          break;
        case 'd':
          unitParam = 'days';
          break;
      }

      return 'Duration($unitParam: $durationValue)';
    }

    throw Exception('Unable to parse token with type other with data: $value');
  }
}
