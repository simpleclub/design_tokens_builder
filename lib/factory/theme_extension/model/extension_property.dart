abstract class ExtensionProperty {
  ExtensionProperty({required this.name});

  final String name;

  String build({int indentationLevel = 0});

  String get flutterType;
}
