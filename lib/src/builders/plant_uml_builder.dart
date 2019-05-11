import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:dcdg/src/constants.dart';
import 'package:dcdg/src/builders/diagram_builder.dart';

class PlantUmlBuilder implements DiagramBuilder {
  String _currentClass;

  final List<String> _lines = [
    '@startuml',
    'set namespaceSeparator $namespaceSeparator',
  ];

  @override
  bool excludeHasA = false;

  @override
  bool excludeIsA = false;

  @override
  bool excludePrivateClasses = false;

  @override
  bool excludePrivateFields = false;

  @override
  bool excludePrivateMethods = false;

  void addAggregations(ClassElement element) {
    if (excludeHasA) {
      return;
    }

    if (element.fields.isEmpty) {
      return;
    }

    for (final field in element.fields) {
      if (excludePrivateFields && field.isPrivate) {
        continue;
      }

      final type = field.type;

      // We ignore certain types, such as those that don't exist
      // statically, and those that are built-in.
      if (type.isDartAsyncFuture ||
          type.isDartAsyncFutureOr ||
          type.isDartCoreBool ||
          type.isDartCoreDouble ||
          type.isDartCoreFunction ||
          type.isDartCoreInt ||
          type.isDartCoreNull ||
          type.isDynamic ||
          type.isObject ||
          type.isUndefined ||
          type.isVoid) {
        continue;
      }

      // Ignore types that come out null (for now) since they just
      // clutter the diagram.
      if (type.name == null) {
        continue;
      }

      final fieldType = getNamespacedTypeName(type.element);

      if (fieldType.startsWith('dart::core')) {
        continue;
      }

      _lines.add('$_currentClass o-- $fieldType');
    }
  }

  void addClass(ClassElement element) {
    final decl = element.isAbstract ? 'abstract class' : 'class';
    _lines.add('$decl $_currentClass {');
  }

  @override
  void addField(FieldElement element) {
    if (excludePrivateFields && element.isPrivate) {
      return;
    }

    final visibilityPrefix = getVisibility(element);
    final staticPrefix = element.isStatic ? '{static} ' : '';
    final name = element.name;
    // TODO: Make this work properly for typedefs (currently null)
    final type = element.type.name;
    _lines.add('  $staticPrefix$visibilityPrefix$type $name');
  }

  void addInterfaces(ClassElement element) {
    if (excludeIsA) {
      return;
    }

    if (element.interfaces.isEmpty) {
      return;
    }

    for (final interface in element.interfaces) {
      final interfaceElement = interface.element;
      final interfaceClass = getNamespacedTypeName(interfaceElement);
      _lines.add('$interfaceClass <|-- $_currentClass');
    }
  }

  void addMixins(ClassElement element) {
    if (excludeIsA) {
      return;
    }

    if (element.mixins.isEmpty) {
      return;
    }

    for (final mixin in element.mixins) {
      final mixinElement = mixin.element;
      final mixinClass = getNamespacedTypeName(mixinElement);
      _lines.add('$mixinClass <|-- $_currentClass');
    }
  }

  void addSuper(ClassElement element) {
    if (excludeIsA) {
      return;
    }

    final superElement = element.supertype.element;

    if (superElement.name == 'Object') {
      return;
    }

    final superClass = getNamespacedTypeName(superElement);
    _lines.add('$superClass <|-- $_currentClass');
  }

  @override
  void addMethod(MethodElement element) {
    if (excludePrivateMethods && element.isPrivate) {
      return;
    }

    final visibilityPrefix = getVisibility(element);
    final staticPrefix = element.isStatic ? '{static} ' : '';
    final name = element.name;
    final type = element.returnType.name;
    _lines.add('  $staticPrefix$visibilityPrefix$type $name()');
  }

  @override
  void finishClass(ClassElement element) {
    _lines.add('}');
    _lines.add('');

    addInterfaces(element);
    addMixins(element);
    addSuper(element);
    addAggregations(element);

    _lines.add('');

    _currentClass = null;
  }

  String getNamespacedTypeName(Element element) {
    final namespace = element.library.identifier
        .replaceFirst('package:', '')
        .replaceFirst('dart:', 'dart::')
        .split('/')
        .join(namespaceSeparator);
    final className = element.name;
    return '$namespace$namespaceSeparator$className';
  }

  String getVisibility(Element element) {
    return element.isPrivate ? '-' : element.hasProtected ? '#' : '+';
  }

  @override
  void printContent(void printer(String content)) {
    final content = ([]
          ..addAll(_lines)
          ..add('')
          ..add('@enduml'))
        .join('\n');
    printer(content);
  }

  @override
  void startClass(ClassElement element) {
    _currentClass = getNamespacedTypeName(element);

    _lines.add('');
    addClass(element);
  }

  @override
  void writeContent(File file) {
    printContent(file.writeAsStringSync);
  }
}
