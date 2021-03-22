import 'package:analyzer/dart/element/element.dart';

class FakeElement implements Element {
  @override
  final LibraryElement? library;

  @override
  final String name;

  @override
  String get displayName => name;

  FakeElement(this.name, [this.library]);

  @override
  dynamic noSuchMethod(_) {}
}

class FakeLibraryElement implements LibraryElement {
  @override
  final String identifier;

  FakeLibraryElement(this.identifier);

  @override
  dynamic noSuchMethod(_) {}
}
