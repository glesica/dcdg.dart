import 'package:analyzer/dart/element/element.dart';
import 'package:dcdg/src/constants.dart';

/// Build a namespace for the given element based on the definition
/// of its type.
String typeNamespace(final Element element, {String separator}) {
  LibraryElement library = element.library;

  if (element is FieldElement) {
    library = element.type.element.library;
  }

  separator = separator ?? namespaceSeparator;
  final namespace = library.identifier
      .replaceFirst('package:', '')
      .replaceFirst('dart:', 'dart::')
      .split('/')
      .join(separator);
  return '$namespace$separator';
}
