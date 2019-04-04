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

  void addClass(ClassElement element) {
    final decl = element.isAbstract ? 'abstract class' : 'class';
    _lines.add('$decl $_currentClass {');
  }

  @override
  void addField(FieldElement element) {
    final visibilityPrefix = getVisibility(element);
    final staticPrefix = element.isStatic ? '{static} ' : '';
    final name = element.name;
    // TODO: Make this work properly for typedefs (currently null)
    final type = element.type.name;
    _lines.add('  $staticPrefix$visibilityPrefix$type $name');
  }

  void addInterfaces(ClassElement element) {
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
    final superElement = element.supertype.element;

    if (superElement.name == 'Object') {
      return;
    }

    final superClass = getNamespacedTypeName(superElement);
    _lines.add('$superClass <|-- $_currentClass');
  }

  @override
  void addMethod(MethodElement element) {
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
