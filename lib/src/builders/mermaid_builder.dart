import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:dcdg/src/builders/diagram_builder.dart';
import 'package:dcdg/src/type_name.dart';
import 'package:dcdg/src/type_namespace.dart';

/*
TODO: Build the diagrams in the functional tests to verify that
 we're generating valid markup for the given builder.

TODO: Consider adding a field to DiagramBuilder that knows how
 to invoke the relevant compiler to produce an image

FIXME: Fields with a function type appear as methods because the
 type ends with ()
 */

class MermaidBuilder implements DiagramBuilder {
  String? _currentClass;

  final List<String> _lines = [
    'classDiagram',
  ];

  @override
  void addAggregation(FieldElement element) {
    final fieldType = namespacedTypeName(element);
    _lines.add('$_currentClass o-- $fieldType');
  }

  @override
  void addField(FieldElement element) {
    final visibilityPrefix = getVisibility(element);
    final staticSuffix = element.isStatic ? '\$' : '';
    final abstractSuffix = element.isAbstract ? '*' : '';
    final name = element.name;
    final type = typeName(element, leftBracket: '~', rightBracket: '~');
    _lines.add(
        '$_currentClass : $visibilityPrefix$name$staticSuffix$abstractSuffix $type');
  }

  @override
  void addInterface(InterfaceType element) {
    final interfaceElement = element.element;
    final interfaceClass = namespacedTypeName(interfaceElement);
    _lines.add('$interfaceClass <|.. $_currentClass');
  }

  @override
  void addMethod(MethodElement element) {
    final visibilityPrefix = getVisibility(element);
    final staticSuffix = element.isStatic ? '\$' : '';
    final abstractSuffix = element.isAbstract ? '*' : '';
    final name = element.name;
    final type = element.returnType.getDisplayString(withNullability: true);
    _lines.add(
        '$_currentClass : $visibilityPrefix$name()$staticSuffix$abstractSuffix $type');
  }

  @override
  void addMixin(InterfaceType element) {
    final mixinElement = element.element;
    final mixinClass = namespacedTypeName(mixinElement);
    _lines.add('$mixinClass <|-- $_currentClass');
  }

  @override
  void addSuper(InterfaceType element) {
    final superElement = element.element;
    final superClass = namespacedTypeName(superElement);
    _lines.add('$superClass <|-- $_currentClass');
  }

  @override
  void beginClass(ClassElement element) {
    _currentClass = namespacedTypeName(element);
    _lines.add('class $_currentClass');
    if (element.isAbstract) {
      _lines.add('<<abstract>> $_currentClass');
    }
    if (element.isEnum) {
      _lines.add('<<enumeration>> $_currentClass');
    }
  }

  @override
  void endClass(ClassElement element) {
    _lines.add('');
    _currentClass = null;
  }

  @override
  void printContent(void Function(String content) printer) {
    final content = (_lines).join('\n');
    printer(content);
  }

  @override
  void writeContent(File file) {
    printContent(file.writeAsStringSync);
  }

  static String namespacedTypeName(Element element) =>
      '${typeName(element, withNullability: false, leftBracket: '~', rightBracket: '~', stripParens: true)}';

  static String getVisibility(Element element) {
    return element.isPrivate
        ? '-'
        : element.hasProtected
            ? '#'
            : '+';
  }
}
