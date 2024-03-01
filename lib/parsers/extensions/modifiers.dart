const studioTokensKey = 'studio.tokens';

sealed class TokenModifier {
  TokenModifier();

  factory TokenModifier.fromMap(Map<String, dynamic> map) {
    final type = map['type'] as String;
    switch (type) {
      case 'alpha':
        return TokenModifierAlpha.fromMap(map);
      default:
        throw Exception('Unknown token modifier type: $type');
    }
  }
}

class TokenModifierAlpha extends TokenModifier {
  TokenModifierAlpha({
    required this.value,
    required this.space,
  });

  TokenModifierAlpha.fromMap(Map<String, dynamic> map)
      : value = double.parse((map['value'] as String)),
        space = map['space'] as String;

  final double value;
  final String space;
}
