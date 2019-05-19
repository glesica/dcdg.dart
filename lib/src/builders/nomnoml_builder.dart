import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:dcdg/dcdg.dart';
import 'package:dcdg/src/builders/type_name.dart';

class NomnomlBuilder implements DiagramBuilder {
  List<String> _lines = [];

  List<FieldElement> _fields = [];

  List<MethodElement> _methods = [];

  @override
  void addAggregation(FieldElement element) {
    // TODO: implement addAggregation
  }

  @override
  void addField(FieldElement element) {
    _fields.add(element);
  }

  @override
  void addInterface(InterfaceType element) {
    // TODO: implement addInterface
  }

  @override
  void addMethod(MethodElement element) {
    _methods.add(element);
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
    final abstractModifier = element.isAbstract ? '<abstract>' : '';
    final className = typeName(element);
    _lines.add('[$abstractModifier$className');
  }

  @override
  void endClass(ClassElement element) {
    finalizeFields();
    finalizeMethods();
    _lines.add(']');
  }

  void finalizeFields() {
    _lines.add('  |');
    _lines.add(_fields.map((element) {
      final staticPrefix = element.isStatic ? '<static> ' : '';
      final visibilityPrefix = getVisibility(element);
      final fieldName = element.name;
      final fieldType = typeName(element);
      return '$staticPrefix$visibilityPrefix$fieldName: $fieldType';
    }).join(';\n  '));
  }

  void finalizeMethods() {
    _lines.add('  |');
    _lines.add(_methods.map((element) {
      final visibilityPrefix = getVisibility(element);
      final staticPrefix = element.isStatic ? '{static} ' : '';
      final methodName = element.name;
      final methodType = element.returnType.name;
      return '$staticPrefix$visibilityPrefix$methodType $methodName()';
    }).join(';\n  '));
  }

  String getVisibility(Element element) {
    return element.isPrivate ? '-' : element.hasProtected ? '#' : '+';
  }

  @override
  void printContent(void Function(String content) printer) {
    final content = ([]..addAll(_lines)).join('\n');
    printer(content);
  }

  @override
  void writeContent(File file) {
    printContent(file.writeAsStringSync);
  }
}
