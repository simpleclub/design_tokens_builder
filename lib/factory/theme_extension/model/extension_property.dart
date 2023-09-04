import 'package:equatable/equatable.dart';

/// A abstract property that can be used in a theme extension.
abstract class ExtensionProperty extends Equatable {
  /// Default constructor.
  ExtensionProperty({required this.name});

  /// The name of the property.
  final String name;

  /// Builds the property.
  ///
  /// Creates a string representation of the property used for Theme extension
  /// generation.
  String build({int indentationLevel = 0, bool includeName = false});

  /// The associated flutter type of the property.
  String get flutterType;

  @override
  List<Object> get props => [name];
}
