import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:dcdg/src/builders/diagram_builder.dart';
import 'package:dcdg/src/type_name.dart';
import 'package:dcdg/src/type_namespace.dart';

class PlantUmlBuilder implements DiagramBuilder {
  String? _currentClass;

  final List<String> _lines = [
    'classDiagram',
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
    // TODO: implement addInterface
  }

  @override
  void addMethod(MethodElement element) {
    // TODO: implement addMethod
  }

  @override
  void addMixin(InterfaceType element) {
    // TODO: implement addMixin
  }

  @override
  void addSuper(InterfaceType element) {
    // TODO: implement addSuper
  }

  @override
  void beginClass(ClassElement element) {
    // TODO: implement beginClass
  }

  @override
  void endClass(ClassElement element) {
    // TODO: implement endClass
  }

  @override
  void printContent(void Function(String content) printer) {
    // TODO: implement printContent
  }

  @override
  void writeContent(File file) {
    // TODO: implement writeContent
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
}
