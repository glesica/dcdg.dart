import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:meta/meta.dart';

typedef OnClassHandler = void Function(ClassElement element);

void _defaultOnClass(ClassElement element) {
  throw StateError('No onClassHandler provided');
}

class UmlVisitor extends RecursiveElementVisitor<void> {
  final bool _excludePrivateClasses;

  final bool _excludePrivateFields;

  final bool _excludePrivateMethods;

  final Set<String> _excludes;

  final bool _exportedOnly;

  final Set<String> _includes;

  final OnClassHandler _onClassElement;

  UmlVisitor({
    @required OnClassHandler onClass,
    bool excludePrivateClasses,
    bool excludePrivateFields,
    bool excludePrivateMethods,
    Iterable<String> excludes,
    bool exportedOnly,
    Iterable<String> includes,
  })  : _excludePrivateClasses = excludePrivateClasses ?? false,
        _excludePrivateFields = excludePrivateFields ?? false,
        _excludePrivateMethods = excludePrivateMethods ?? false,
        _excludes = Set.from(excludes ?? []),
        _exportedOnly = exportedOnly ?? false,
        _includes = Set.from(includes ?? []),
        _onClassElement = onClass ?? _defaultOnClass;

  /// Applies the excludes / includes logic.
  ///
  /// When both an excludes list and an includes list are provided,
  /// the excludes list takes precedence.
  ///
  /// TODO: Figure out how to make this work for fields and methods
  bool shouldProcess(ClassElement element) {
    if (_excludePrivateClasses && element.isPrivate) {
      return false;
    }

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
