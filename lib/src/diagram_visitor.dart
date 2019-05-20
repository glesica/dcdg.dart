import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:meta/meta.dart';

typedef OnElementHandler<T extends Element> = void Function(T element);

typedef OnTypeHandler<T extends DartType> = void Function(T element);

void _defaultOnClass(ClassElement element) {
  throw StateError('No onStartClass was provided');
}

void _noopHandler(_) {}

class DiagramVisitor extends RecursiveElementVisitor<void> {
  final bool _excludeHasA;

  final bool _excludeIsA;

  final bool _excludePrivateClasses;

  final bool _excludePrivateFields;

  final bool _excludePrivateMethods;

  final Iterable<RegExp> _excludes;

  final Iterable<RegExp> _hasA;

  final Iterable<RegExp> _includes;

  final Iterable<RegExp> _isA;

  final OnElementHandler<FieldElement> _onAggregateFieldElement;

  final OnElementHandler<ClassElement> _onBeginClassElement;

  final OnElementHandler<ClassElement> _onEndClassElement;

  final OnElementHandler<FieldElement> _onFieldElement;

  final OnTypeHandler<InterfaceType> _onInterfaceType;

  final OnElementHandler<MethodElement> _onMethodElement;

  final OnTypeHandler<InterfaceType> _onMixinType;

  final OnTypeHandler<InterfaceType> _onSuperType;

  DiagramVisitor({
    @required OnElementHandler<ClassElement> onBeginClass,
    bool excludeHasA,
    bool excludeIsA,
    bool excludePrivateClasses,
    bool excludePrivateFields,
    bool excludePrivateMethods,
    Iterable<RegExp> excludes,
    Iterable<RegExp> hasA,
    Iterable<RegExp> includes,
    Iterable<RegExp> isA,
    OnElementHandler<FieldElement> onAggregateField,
    OnElementHandler<FieldElement> onField,
    OnElementHandler<ClassElement> onEndClass,
    OnTypeHandler<InterfaceType> onInterface,
    OnElementHandler<MethodElement> onMethod,
    OnTypeHandler<InterfaceType> onMixin,
    OnTypeHandler<InterfaceType> onSuper,
  })  : _excludeHasA = excludeHasA ?? false,
        _excludeIsA = excludeIsA ?? false,
        _excludePrivateClasses = excludePrivateClasses ?? false,
        _excludePrivateFields = excludePrivateFields ?? false,
        _excludePrivateMethods = excludePrivateMethods ?? false,
        _excludes = excludes ?? const <RegExp>[],
        _hasA = hasA ?? const <RegExp>[],
        _includes = includes ?? const <RegExp>[],
        _isA = isA ?? const <RegExp>[],
        _onAggregateFieldElement = onAggregateField ?? _noopHandler,
        _onBeginClassElement = onBeginClass ?? _defaultOnClass,
        _onEndClassElement = onEndClass ?? _noopHandler,
        _onFieldElement = onField ?? _noopHandler,
        _onInterfaceType = onInterface ?? _noopHandler,
        _onMethodElement = onMethod ?? _noopHandler,
        _onMixinType = onMixin ?? _noopHandler,
        _onSuperType = onSuper ?? _noopHandler;

  /// Whether the given class contains a field whose type matches
  /// one of those provided in the `hasA` constructor parameter.
  bool hasA(ClassElement element) {
    for (final field in element.fields) {
      final typeName = field.type.name;

      if (typeName == null) {
        // Some types, like typedefs, don't have a string
        // representation that we can use.
        continue;
      }

      if (_hasA.any((r) => r.hasMatch(typeName))) {
        return true;
      }
    }

    return false;
  }

  /// Whether the given class inherits from or implements any of
  /// the classes named in the iterable provided to the `isA`
  /// constructor parameter.
  bool isA(ClassElement element) {
    //
    InterfaceType current = element.type;
    while (current != null) {
      //
      if (_isA.any((r) => r.hasMatch(current.name))) {
        return true;
      }

      current = current.superclass;
    }

    return false;
  }

  /// Whether an element should be included based on the `includes`
  /// and `excludes` lists alone, assuming it isn't excluded for
  /// any other reason.
  bool shouldInclude(Element element) {
    if (_excludes.any((r) => r.hasMatch(element.name))) {
      return false;
    }

    if (_includes.any((r) => r.hasMatch(element.name))) {
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

    return shouldInclude(element);
  }

  bool shouldIncludeField(FieldElement element) {
    if (_excludePrivateFields && element.isPrivate) {
      return false;
    }

    return shouldInclude(element);
  }

  bool shouldIncludeHasA(ClassElement element) {
    if (_hasA.isEmpty) {
      return true;
    }

    return hasA(element);
  }

  bool shouldIncludeIsA(ClassElement element) {
    if (_isA.isEmpty) {
      return true;
    }

    return isA(element);
  }

  bool shouldIncludeMethod(MethodElement element) {
    if (_excludePrivateMethods && element.isPrivate) {
      return false;
    }

    return shouldInclude(element);
  }

  @override
  void visitClassElement(ClassElement element) {
    if (!shouldIncludeClass(element)) {
      return;
    }

    if (!shouldIncludeHasA(element)) {
      return;
    }

    if (!shouldIncludeIsA(element)) {
      return;
    }

    _onBeginClassElement(element);
    super.visitClassElement(element);

    // TODO: Apply regex filters
    if (!_excludeIsA) {
      final superType = element.supertype;
      final hasSuper = superType != null;
      final superIsObject = superType?.isObject == true;
      final isPrivate = superType?.element?.isPrivate == true;
      if (hasSuper &&
          !superIsObject &&
          !(_excludePrivateClasses && isPrivate)) {
        _onSuperType(superType);
      }

      for (final mixinType in element.mixins) {
        if (mixinType.isObject) {
          continue;
        }

        if (_excludePrivateClasses && mixinType.element.isPrivate) {
          continue;
        }

        _onMixinType(mixinType);
      }

      for (final interfaceType in element.interfaces) {
        if (interfaceType.isObject) {
          continue;
        }

        if (_excludePrivateClasses && interfaceType.element.isPrivate) {
          continue;
        }

        _onInterfaceType(interfaceType);
      }
    }

    _onEndClassElement(element);
  }

  @override
  void visitFieldElement(FieldElement element) {
    if (!shouldIncludeField(element)) {
      return;
    }

    _onFieldElement(element);

    if (!_excludeHasA) {
      final type = element.type;

      // We ignore parameter types since they're not meaningful
      // until they're reified anyway.
      if (type is TypeParameterType) {
        return;
      }

      // We ignore certain types, such as those that don't exist
      // statically, and those that are built-in.
      if (type.isDartAsyncFuture ||
          type.isDartAsyncFutureOr ||
          type.isDynamic ||
          type.isObject ||
          type.isUndefined ||
          type.isVoid) {
        return;
      }

      // We ignore things in dart:core because they're everywhere
      // and we generally don't care about them.
      if (type.element.library.isDartCore) {
        return;
      }

      _onAggregateFieldElement(element);
    }
  }

  void visitMethodElement(MethodElement element) {
    if (!shouldIncludeMethod(element)) {
      return;
    }

    _onMethodElement(element);
  }
}
