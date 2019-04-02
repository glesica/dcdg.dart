import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:meta/meta.dart';

typedef OnElementHandler<T extends Element> = void Function(T element);

void _defaultOnClass(ClassElement element) {
  throw StateError('No onStartClass was provided');
}

void _noopOnElement(_) {}

class DiagramVisitor extends RecursiveElementVisitor<void> {
  final bool _excludePrivateClasses;

  final bool _excludePrivateFields;

  final bool _excludePrivateMethods;

  final Set<String> _excludes;

  final bool _exportedOnly;

  final Set<String> _includes;

  final OnElementHandler<FieldElement> _onFieldElement;

  final OnElementHandler<ClassElement> _onFinishClassElement;

  final OnElementHandler<MethodElement> _onMethodElement;

  final OnElementHandler<ClassElement> _onStartClassElement;

  DiagramVisitor({
    @required OnElementHandler<ClassElement> onStartClass,
    bool excludePrivateClasses,
    bool excludePrivateFields,
    bool excludePrivateMethods,
    Iterable<String> excludes,
    bool exportedOnly,
    Iterable<String> includes,
    OnElementHandler<FieldElement> onField,
    OnElementHandler<ClassElement> onFinishClass,
    OnElementHandler<MethodElement> onMethod,
  })  : _excludePrivateClasses = excludePrivateClasses ?? false,
        _excludePrivateFields = excludePrivateFields ?? false,
        _excludePrivateMethods = excludePrivateMethods ?? false,
        _excludes = Set.from(excludes ?? []),
        _exportedOnly = exportedOnly ?? false,
        _includes = Set.from(includes ?? []),
        _onFieldElement = onField ?? _noopOnElement,
        _onFinishClassElement = onFinishClass ?? _noopOnElement,
        _onMethodElement = onMethod ?? _noopOnElement,
        _onStartClassElement = onStartClass ?? _defaultOnClass;

  bool _shouldInclude(Element element) {
    if (_excludes.contains(element.name)) {
      return false;
    }

    if (_includes.contains(element.name)) {
      return true;
    }

    return _includes.isEmpty;
  }

  /// Applies the excludes / includes logic.
  ///
  /// When both an excludes list and an includes list are provided,
  /// the excludes list takes precedence.
  ///
  bool shouldIncludeClass(ClassElement element) {
    if (_excludePrivateClasses && element.isPrivate) {
      return false;
    }

    return _shouldInclude(element);
  }

  bool shouldIncludeField(FieldElement element) {
    if (_excludePrivateFields && element.isPrivate) {
      return false;
    }

    return _shouldInclude(element);
  }

  bool shouldIncludeMethod(MethodElement element) {
    if (_excludePrivateMethods && element.isPrivate) {
      return false;
    }

    return _shouldInclude(element);
  }

  @override
  void visitClassElement(ClassElement element) {
    if (!shouldIncludeClass(element)) {
      return;
    }

    _onStartClassElement(element);
    super.visitClassElement(element);
    _onFinishClassElement(element);
  }

  @override
  void visitFieldElement(FieldElement element) {
    if (!shouldIncludeField(element)) {
      return;
    }

    _onFieldElement(element);
  }

  void visitMethodElement(MethodElement element) {
    if (!shouldIncludeMethod(element)) {
      return;
    }

    _onMethodElement(element);
  }
}
