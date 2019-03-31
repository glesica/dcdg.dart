import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:dartagram/src/uml_builder.dart';

class UmlVisitor extends RecursiveElementVisitor<void> {
  final Set<String> _blacklist;

  final UmlBuilder _umlBuilder;

  final Set<String> _whitelist;

  UmlVisitor(this._umlBuilder, {
    Iterable<String> blacklist,
    Iterable<String> whitelist,
  })  : assert(_umlBuilder != null),
        _blacklist = Set.from(blacklist ?? []),
        _whitelist = Set.from(whitelist ?? []);

  /// Applies the blacklist / whitelist logic.
  ///
  /// When both a blacklist and a whitelist are provided,
  /// the blacklist takes precedent.
  bool shouldProcess(ClassElement element) {
    if (_blacklist.contains(element.name)) {
      return false;
    }

    if (_whitelist.contains(element.name)) {
      return true;
    }

    return _whitelist.isEmpty;
  }

  @override
  void visitClassElement(ClassElement element) {
    if (shouldProcess(element)) {
      _umlBuilder.processClass(element);
    }
  }
}
