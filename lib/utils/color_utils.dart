/// Parses a HEX color to Flutter Color code.
String parseColor(String color) {
  // Validating HEX color.
  final regex = RegExp('(?:[0-9a-fA-F]{3,4}){1,2}\$');
  if (!regex.hasMatch(color)) throw Exception('Invalid color code: $color');

  color = color.replaceAll('#', '');
  final rgb = color.substring(0, 6);
  // Check if opacity is present.
  if (color.length == 6) {
    return 'Color(0xFF$rgb)';
  }
  final o = color.substring(6, 8);
  final hexCode = '$o$rgb';

  return 'Color(0x$hexCode)';
}
