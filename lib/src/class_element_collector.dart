import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';

/// A visitor that collects all class elements defined within
/// a particular library.
///
/// The visitor can optionally limit the classes collected to those that
/// are exported from the library. This means that they are public,
/// and are either not subject to any `show` or `hide` clause, are
/// included in a `show` clause, or are not included in a `hide` clause.
class ClassElementCollector extends RecursiveElementVisitor<void> {
  final List<ClassElement> _classElements = [];

  final bool _exportOnly;

  ClassElementCollector({
    bool exportOnly,
  }) : _exportOnly = exportOnly ?? false;

  Iterable<ClassElement> get classElements => _classElements;

  @override
  void visitClassElement(ClassElement element) {
    _classElements.add(element);
  }

  @override
  void visitExportElement(ExportElement element) {
    final Set<String> _hiddenNames = {};
    final Set<String> _shownNames = {};

    for (final combinator in element.combinators) {
      if (combinator is HideElementCombinator) {
        _hiddenNames.addAll(combinator.hiddenNames);
      }

      if (combinator is ShowElementCombinator) {
        _shownNames.addAll(combinator.shownNames);
      }
    }

    final collector = ClassElementCollector(
      exportOnly: _exportOnly,
    );
    element.exportedLibrary.accept(collector);

    final exportedElements = collector.classElements
        .where(
          (e) =>
              _exportOnly &&
              _shownNames.isNotEmpty &&
              _shownNames.contains(e.name),
        )
        .where(
          (e) =>
              _exportOnly &&
              _hiddenNames.isNotEmpty &&
              !_hiddenNames.contains(e.name),
        );
    _classElements.addAll(exportedElements);
  }
}
