import 'package:analyzer/dart/element/element.dart';

/// Determine and return the most sensible "name" for the given
/// [Element].
String typeName(final Element element) {
  if (element is ClassElement) {
    element.displayName;
  }

  if (element is FieldElement) {
    return element.type.getDisplayString(withNullability: true);
  }

  if (element is TypeDefiningElement) {
    return element.displayName;
  }

  return element.displayName;
}
