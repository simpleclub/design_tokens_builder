extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String get firstUpperCased =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String get firstLowerCased =>
      length > 0 ? '${this[0].toLowerCase()}${substring(1)}' : '';
}
