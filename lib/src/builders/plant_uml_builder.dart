import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:dcdg/src/builders/type_name.dart';
import 'package:dcdg/src/builders/type_namespace.dart';
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

    final observedTypes = Set<String>();

    for (final field in element.fields) {
      if (excludePrivateFields && field.isPrivate) {
        continue;
      }

      final type = field.type;

      // We ignore parameter types since they're not meaningful
      // until they're reified anyway.
      if (type is TypeParameterType) {
        continue;
      }

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

      final fieldType = namespacedTypeName(field);

      // Ignore types in dart:core since they're everywhere and
      // we generally don't care about them.
      if (fieldType.contains('dart::core')) {
        continue;
      }

      if (observedTypes.contains(fieldType)) {
        continue;
      } else {
        observedTypes.add(fieldType);
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
    final type = typeName(element);
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
      final interfaceClass = namespacedTypeName(interfaceElement);
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
      final mixinClass = namespacedTypeName(mixinElement);
      _lines.add('$mixinClass <|-- $_currentClass');
    }
  }

  void addSuper(ClassElement element) {
    if (excludeIsA) {
      return;
    }

    final superElement = element.supertype.element;

    if (superElement.type.isObject) {
      return;
    }

    final superClass = namespacedTypeName(superElement);
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

  String namespacedTypeName(Element element) =>
      '"${typeNamespace(element)}${typeName(element)}"';

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
    _currentClass = namespacedTypeName(element);

    _lines.add('');
    addClass(element);
  }

  @override
  void writeContent(File file) {
    printContent(file.writeAsStringSync);
  }
}
