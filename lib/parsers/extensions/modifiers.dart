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

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TokenModifier && runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => runtimeType.hashCode;
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

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TokenModifierAlpha &&
            runtimeType == other.runtimeType &&
            value == other.value &&
            space == other.space;
  }

  @override
  int get hashCode => value.hashCode ^ space.hashCode;
}
