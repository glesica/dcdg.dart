import 'package:analyzer/dart/element/element.dart';

/// Determine and return the most sensible "name" for the given
/// [Element].
String typeName(
  final Element element, {
  bool withNullability = true,
  String leftBracket = '<',
  String rightBracket = '>',
  bool stripParens = false,
}) {
  // If we're building a has-a relationship then we get the
  // field that induces the relationship and we have to do a
  // little extra work to get the type.
  String name;
  if (element is FieldElement) {
    name = element.type.getDisplayString(withNullability: withNullability);
  } else {
    name = element.displayName;
  }

  name = name.replaceAll('<', leftBracket).replaceAll('>', rightBracket);

  if (stripParens) {
    name = name.replaceAll('(', '').replaceAll(')', '');
  }

  if (withNullability) {
    return name;
  }

  name = name.replaceFirst('?', '').replaceFirst('*', '');

  return name;
}
