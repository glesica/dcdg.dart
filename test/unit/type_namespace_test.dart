import 'package:test/test.dart';

import 'package:dcdg/src/builders/type_namespace.dart';
import 'package:dcdg/src/constants.dart';

import 'fakes.dart';

void main() {
  group('typeNamespace', () {
    test('should concatenate package and class name', () {
      final library = FakeLibraryElement('package:pkg/entry.dart');
      final element = FakeElement('class', library);

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
      final library = FakeLibraryElement('dart:core/entry.dart');
      final element = FakeElement('class', library);

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
      final library = FakeLibraryElement('package:pkg/entry.dart');
      final element = FakeElement('class', library);

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
