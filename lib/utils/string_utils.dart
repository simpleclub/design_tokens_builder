/// Extension on string for case related helpers.
extension StringCasingExtension on String {
  /// Capitalizes the first letter and lower cases everything else.
  ///
  /// E.g. someText -> Sometext
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  /// Capitalizes the first letter.
  ///
  /// E.g. someText -> SomeText
  String get firstUpperCased =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';

  /// Lower cases the first letter.
  ///
  /// E.g. SomeText -> someText
  String get firstLowerCased =>
      length > 0 ? '${this[0].toLowerCase()}${substring(1)}' : '';
}

String indentation({int level = 1}) => '  ' * level;
