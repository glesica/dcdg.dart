import 'package:analyzer/dart/element/element.dart';

/// Determine and return the most sensible "name" for the given
/// [Element].
String typeName(final Element element) {
  if (element is ClassElement) {
    element.displayName;
  }

  if (element is FieldElement) {
    return element.type.displayName;
  }

  if (element is TypeDefiningElement) {
    return element.type.displayName;
  }

  return element.displayName;
}
