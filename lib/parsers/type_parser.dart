extension DesignTokenMap on Map<String, dynamic> {
  String get flutterType {
    if (!containsKey('type')) {
      throw Exception(
          'No \'type\' key found. Needed in order to figure out flutter represented type.');
    }
    final type = this['type'] as String;

    switch (type) {
      case 'color':
        return 'Color';
      case 'fontFamilies':
      case 'textCase':
        return 'String';
      case 'fontWeights':
        return 'FontWeight';
      case 'fontSizes':
      case 'letterSpacing':
      case 'paragraphSpacing':
      case 'dimension':
      case 'borderWidth':
      case 'sizing':
      case 'lineHeights':
        return 'double';
      case 'textDecoration':
        return 'TextDecoration';
      case 'spacing':
        return 'EdgeInsets';
      case 'borderRadius':
        return 'BorderRadius';
      case 'boxShadow':
        return 'List<BoxShadow>';
      case 'border':
        return 'BoxBorder';
    }

    throw Exception('No flutter represented type found for type $type.');
  }
}
