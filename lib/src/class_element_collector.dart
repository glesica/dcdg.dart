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
    bool exportedOnly,
  }) : _exportOnly = exportedOnly ?? false;

  Iterable<ClassElement> get classElements => _classElements;

  @override
  void visitClassElement(ClassElement element) {
    _classElements.add(element);
  }

  @override
  void visitExportElement(ExportElement element) {
    final Set<String> hiddenNames = {};
    final Set<String> shownNames = {};

    for (final combinator in element.combinators) {
      if (combinator is ShowElementCombinator) {
        shownNames.addAll(combinator.shownNames);
      }

      if (combinator is HideElementCombinator) {
        hiddenNames.addAll(combinator.hiddenNames);
      }
    }

    final collector = ClassElementCollector(
      exportedOnly: _exportOnly,
    );
    element.exportedLibrary.accept(collector);

    final exportedElements = collector.classElements
        .where(
          (e) =>
              !_exportOnly ||
              shownNames.isEmpty ||
              shownNames.contains(e.name),
        )
        .where(
          (e) =>
              !_exportOnly ||
              hiddenNames.isEmpty ||
              !hiddenNames.contains(e.name),
        );
    _classElements.addAll(exportedElements);
  }
}
