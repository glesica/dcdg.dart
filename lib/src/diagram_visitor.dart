import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';

import 'type_name.dart';
import 'type_namespace.dart';

typedef OnElementHandler<T extends Element> = void Function(T element);

typedef OnTypeHandler<T extends DartType> = void Function(T element);

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

  final bool _verbose;

  DiagramVisitor({
    required OnElementHandler<ClassElement> onBeginClass,
    bool excludeHasA = false,
    bool excludeIsA = false,
    bool excludePrivateClasses = false,
    bool excludePrivateFields = false,
    bool excludePrivateMethods = false,
    Iterable<RegExp> excludes = const <RegExp>[],
    Iterable<RegExp> hasA = const <RegExp>[],
    Iterable<RegExp> includes = const <RegExp>[],
    Iterable<RegExp> isA = const <RegExp>[],
    OnElementHandler<FieldElement> onAggregateField = _noopHandler,
    OnElementHandler<FieldElement> onField = _noopHandler,
    OnElementHandler<ClassElement> onEndClass = _noopHandler,
    OnTypeHandler<InterfaceType> onInterface = _noopHandler,
    OnElementHandler<MethodElement> onMethod = _noopHandler,
    OnTypeHandler<InterfaceType> onMixin = _noopHandler,
    OnTypeHandler<InterfaceType> onSuper = _noopHandler,
    bool verbose = false,
  })  : _excludeHasA = excludeHasA,
        _excludeIsA = excludeIsA,
        _excludePrivateClasses = excludePrivateClasses,
        _excludePrivateFields = excludePrivateFields,
        _excludePrivateMethods = excludePrivateMethods,
        _excludes = excludes,
        _hasA = hasA,
        _includes = includes,
        _isA = isA,
        _onAggregateFieldElement = onAggregateField,
        _onBeginClassElement = onBeginClass,
        _onEndClassElement = onEndClass,
        _onFieldElement = onField,
        _onInterfaceType = onInterface,
        _onMethodElement = onMethod,
        _onMixinType = onMixin,
        _onSuperType = onSuper,
        _verbose = verbose;

  /// Whether the given class contains a field whose type matches
  /// one of those provided in the `hasA` constructor parameter.
  bool hasA(ClassElement element) {
    for (final field in element.fields) {
      final typeName = field.type.element?.name ?? '';

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
    var current = element.thisType;
    while (true) {
      if (_isA.any((r) => r.hasMatch(current.element.name))) {
        return true;
      }

      final superclass = current.superclass;
      if (superclass == null) {
        break;
      }

      current = superclass;
    }

    for (final needle in _isA) {
      if (element.interfaces.any((i) => needle.hasMatch(i.element.name))) {
        return true;
      }

      if (element.mixins.any((m) => needle.hasMatch(m.element.name))) {
        return true;
      }
    }

    return false;
  }

  String _namespacedTypeName(Element element) =>
      '${typeNamespace(element)}${typeName(element)}';

  /// Whether an element should be included based on the `includes`
  /// and `excludes` lists alone, assuming it isn't excluded for
  /// any other reason.
  bool shouldInclude(Element element) {
    final fqName = _namespacedTypeName(element);
    if (_verbose) {
      stderr.writeln('shouldInclude: ${element.name} ($fqName)');
    }
    if (_excludes.any((r) {
      final isMatch = r.hasMatch(fqName) || r.hasMatch(element.name ?? '');
      if (_verbose) {
        stderr.writeln(
            'Matches exclude pattern "${r.pattern}" -> ${isMatch ? 'EXCLUDED' : 'no'}');
      }
      return isMatch;
    })) {
      return false;
    }

    if (_includes.any((r) => r.hasMatch(element.name ?? ''))) {
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

    // TODO: Apply more regex filtering?
    if (!_excludeIsA) {
      final superType = element.supertype;
      final superElement = superType?.element;

      final superIsObject = superType?.isDartCoreObject == true;
      final superIsPrivate = superType?.element.isPrivate == true;
      final superIsIncluded =
          (superElement != null) && shouldInclude(superElement);

      if (superType != null &&
          !superIsObject &&
          !(_excludePrivateClasses && superIsPrivate) &&
          superIsIncluded) {
        _onSuperType(superType);
      }

      for (final mixinType in element.mixins) {
        if (mixinType.isDartCoreObject) {
          continue;
        }

        if (_excludePrivateClasses && mixinType.element.isPrivate) {
          continue;
        }

        _onMixinType(mixinType);
      }

      for (final interfaceType in element.interfaces) {
        if (interfaceType.isDartCoreObject) {
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
          type.isDartCoreObject ||
          type.isDynamic ||
          type.isVoid) {
        return;
      }

      // We ignore things in dart:core because they're everywhere
      // and we generally don't care about them.
      if (type.element?.library?.isDartCore == true) {
        return;
      }

      _onAggregateFieldElement(element);
    }
  }

  @override
  void visitMethodElement(MethodElement element) {
    if (!shouldIncludeMethod(element)) {
      return;
    }

    _onMethodElement(element);
  }
}
