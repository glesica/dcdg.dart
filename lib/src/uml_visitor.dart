import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:meta/meta.dart';

typedef OnClassHandler = void Function(ClassElement element);

void _defaultOnClass(ClassElement element) {
  throw StateError('No onClassHandler provided');
}

class UmlVisitor extends RecursiveElementVisitor<void> {
  final Set<String> _excludes;

  final Set<String> _includes;

  final OnClassHandler _onClassElement;

  UmlVisitor({
    @required OnClassHandler onClass,
    Iterable<String> excludes,
    Iterable<String> includes,
  })  : _excludes = Set.from(excludes ?? []),
        _includes = Set.from(includes ?? []),
        _onClassElement = onClass ?? _defaultOnClass;

  /// Applies the excludes / includes logic.
  ///
  /// When both an excludes list and an includes list are provided,
  /// the excludes list takes precedence.
  bool shouldProcess(ClassElement element) {
    if (_excludes.contains(element.name)) {
      return false;
    }

    if (_includes.contains(element.name)) {
      return true;
    }

    return _includes.isEmpty;
  }

  @override
  void visitClassElement(ClassElement element) {
    if (shouldProcess(element)) {
      _onClassElement(element);
    }
  }
}
