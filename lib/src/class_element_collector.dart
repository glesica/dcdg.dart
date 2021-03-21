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
    bool exportedOnly = false,
  }) : _exportOnly = exportedOnly;

  Iterable<ClassElement> get classElements => _classElements;

  @override
  void visitClassElement(ClassElement element) {
    _classElements.add(element);
  }

  @override
  void visitExportElement(ExportElement element) {
    if (!_exportOnly) {
      return;
    }

    final _hiddenNames = <String>{};
    final _shownNames = <String>{};

    for (final combinator in element.combinators) {
      if (combinator is HideElementCombinator) {
        _hiddenNames.addAll(combinator.hiddenNames);
      }

      if (combinator is ShowElementCombinator) {
        _shownNames.addAll(combinator.shownNames);
      }
    }

    final collector = ClassElementCollector(
      exportedOnly: _exportOnly,
    );
    element.exportedLibrary?.accept(collector);

    bool shouldInclude(ClassElement element) {
      if (_shownNames.isEmpty && _hiddenNames.isEmpty) {
        return true;
      }

      final shouldShow =
          _shownNames.isNotEmpty && _shownNames.contains(element.name);
      final shouldHide =
          _hiddenNames.isNotEmpty && _hiddenNames.contains(element.name);
      return _exportOnly ? (shouldShow && !shouldHide) : true;
    }

    collector.classElements.where(shouldInclude).forEach(visitClassElement);
  }
}
