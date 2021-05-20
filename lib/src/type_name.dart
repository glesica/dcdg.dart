import 'package:analyzer/dart/element/element.dart';

/// Determine and return the most sensible "name" for the given
/// [Element].
String typeName(final Element element, {bool withNullability = true}) {
  if (element is FieldElement) {
    return element.type.getDisplayString(withNullability: withNullability);
  }

  final name = element.displayName;
  if (withNullability) {
    return name;
  }

  return name.replaceFirst('?', '').replaceFirst('*', '');
}
