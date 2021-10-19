import 'package:analyzer/dart/element/element.dart';

/// Determine and return the most sensible "name" for the given
/// [Element].
String typeName(final Element element, {bool withNullability = true}) {
  // If we're building a has-a relationship then we get the
  // field that induces the relationship and we have to do a
  // little extra work to get the type.
  if (element is FieldElement) {
    return element.type.getDisplayString(withNullability: withNullability);
  }

  final name = element.displayName;
  if (withNullability) {
    return name;
  }

  return name.replaceFirst('?', '').replaceFirst('*', '');
}
