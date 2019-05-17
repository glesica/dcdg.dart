import 'package:analyzer/dart/element/element.dart';
import 'package:dcdg/src/builders/type_namespace.dart';
import 'package:dcdg/src/constants.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group('typeNamespace', () {
    Element element;
    LibraryElement library;

    setUp(() {
      element = MockElement();
      library = MockLibraryElement();

      when(element.name).thenReturn('class');
      when(element.library).thenReturn(library);
    });

    test('should concatenate package and class name', () {
      when(library.identifier).thenReturn('package:pkg/entry.dart');
      final namespace = typeNamespace(element);
      expect(
        namespace,
        [
              'pkg',
              'entry.dart',
            ].join(namespaceSeparator) +
            namespaceSeparator,
      );
    });

    test('should convert a dart:core prefix to dart::core', () {
      when(library.identifier).thenReturn('dart:core/entry.dart');
      final namespace = typeNamespace(element);
      expect(
        namespace,
        [
              'dart',
              'core',
              'entry.dart',
            ].join(namespaceSeparator) +
            namespaceSeparator,
      );
    });

    test('should allow a custom namespace separator', () {
      when(library.identifier).thenReturn('package:pkg/entry.dart');
      final separator = '+';
      final namespace = typeNamespace(element, separator: separator);
      expect(
        namespace,
        [
              'pkg',
              'entry.dart',
            ].join(separator) +
            separator,
      );
    });
  });
}

class MockElement extends Mock implements Element {}

class MockLibraryElement extends Mock implements LibraryElement {}
