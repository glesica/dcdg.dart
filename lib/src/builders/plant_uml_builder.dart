import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:dcdg/src/builders/diagram_builder.dart';
import 'package:dcdg/src/constants.dart';
import 'package:dcdg/src/type_name.dart';
import 'package:dcdg/src/type_namespace.dart';

class PlantUmlBuilder implements DiagramBuilder {
  String? _currentClass;

  final List<String> _lines = [
    '@startuml',
    'set namespaceSeparator $namespaceSeparator',
    '',
  ];

  final Set<String> _relationships = {};

  @override
  void addAggregation(FieldElement element) {
    final fieldType = namespacedTypeName(element);
    _relationships.add('$_currentClass o-- $fieldType');
  }

  @override
  void addField(FieldElement element) {
    final visibilityPrefix = getVisibility(element);
    final staticPrefix = element.isStatic ? '{static} ' : '';
    final name = element.name;
    final type = typeName(element);
    _lines.add('  $staticPrefix$visibilityPrefix$type $name');
  }

  @override
  void addInterface(InterfaceType element) {
    final interfaceElement = element.element;
    final interfaceClass = namespacedTypeName(interfaceElement);
    _relationships.add('$interfaceClass <|-- $_currentClass');
  }

  @override
  void addMethod(MethodElement element) {
    final visibilityPrefix = getVisibility(element);
    final staticPrefix = element.isStatic ? '{static} ' : '';
    final name = element.name;
    final type = element.returnType.getDisplayString(withNullability: true);
    _lines.add('  $staticPrefix$visibilityPrefix$type $name()');
  }

  @override
  void addMixin(InterfaceType element) {
    final mixinElement = element.element;
    final mixinClass = namespacedTypeName(mixinElement);
    _relationships.add('$mixinClass <|-- $_currentClass');
  }

  @override
  void addSuper(InterfaceType element) {
    final superElement = element.element;
    final superClass = namespacedTypeName(superElement);
    _relationships.add('$superClass <|-- $_currentClass');
  }

  @override
  void beginClass(ClassElement element) {
    _currentClass = namespacedTypeName(element);
    final decl = element.isAbstract ? 'abstract class' : 'class';
    _lines.add('$decl $_currentClass {');
  }

  @override
  void endClass(ClassElement element) {
    _lines.add('}');
    if (_relationships.isNotEmpty) {
      _lines.add('');
      _lines.addAll(_relationships);
    }
    _lines.add('');

    _currentClass = null;
    _relationships.clear();
  }

  String namespacedTypeName(Element element) =>
      '"${typeNamespace(element)}${typeName(element, withNullability: false)}"';

  String getVisibility(Element element) {
    return element.isPrivate
        ? '-'
        : element.hasProtected
            ? '#'
            : '+';
  }

  @override
  void printContent(void Function(String content) printer) {
    final content = ([..._lines, '', '@enduml']).join('\n');
    printer(content);
  }

  @override
  void writeContent(File file) {
    printContent(file.writeAsStringSync);
  }
}
