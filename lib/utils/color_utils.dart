/// Parses a hex color to flutter readable color.
String parseColor(String color) {
  try {
    color = color.replaceAll('#', '');

    // Parse R, G, B, O from color string.
    final r = int.parse(color.substring(0, 2), radix: 16);
    final g = int.parse(color.substring(2, 4), radix: 16);
    final b = int.parse(color.substring(4, 6), radix: 16);

    // Check if opacity is present.
    if (color.length == 6) return 'Color.fromRGBO($r, $g, $b, 1.0)';

    final o = int.parse(color.substring(6, 8), radix: 16) / 255;
    return 'Color.fromRGBO($r, $g, $b, $o)';
  } catch (e) {
    print('Error parsing color: $color');
    return 'Color(0xFFFF0000)';
  }
}
