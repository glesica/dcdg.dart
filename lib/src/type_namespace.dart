import 'package:analyzer/dart/element/element.dart';
import 'package:dcdg/src/constants.dart';

/// Build a namespace for the given element based on the definition
/// of its type.
String typeNamespace(final Element element,
    {String separator = namespaceSeparator}) {
  var library = element.library;

  // If we're building a has-a relationship then we get the
  // field that induces the relationship and we have to do a
  // little extra work to get the type.
  if (element is FieldElement) {
    library =
        element.type.element?.library ?? element.type.alias?.element.library;
  }

  final namespace = library?.identifier
      .replaceFirst('package:', '')
      .replaceFirst('dart:', 'dart::')
      .split('/')
      .join(separator);
  return '$namespace$separator';
}
