import 'package:design_tokens_builder/builder_config/builder_config.dart';
import 'package:design_tokens_builder/parsers/extensions/modifiers.dart';

/// A abstract property that can be used in a theme extension.
abstract class ExtensionProperty {
  /// Default constructor.
  ExtensionProperty({required this.name});

  /// The name of the property.
  final String name;

  /// Builds the property.
  ///
  /// Creates a string representation of the property used for Theme extension
  /// generation.
  String build({
    int indentationLevel = 0,
    bool includeName = false,
    BuilderConfig? config,
  });

  /// The associated flutter type of the property.
  String get flutterType;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ExtensionProperty &&
            runtimeType == other.runtimeType &&
            name == other.name;
  }

  @override
  int get hashCode => name.hashCode;
}
