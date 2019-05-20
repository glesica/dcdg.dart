import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:dcdg/dcdg.dart';
import 'package:dcdg/src/builders/type_name.dart';

class NomnomlBuilder implements DiagramBuilder {
  String _currentClass;

  List<String> _lines = [];

  List<FieldElement> _fields = [];

  List<MethodElement> _methods = [];

  Set<String> _relationships = {};

  @override
  void addAggregation(FieldElement element) {
    final typeElement = element.type.element;
    if (typeElement is ClassElement) {
      final className = fullClassName(typeElement);
      _relationships.add('[$className]o-[$_currentClass]');
    } else {
      final name = typeName(element);
      _relationships.add('[$name]o-[$_currentClass]');
    }
  }

  @override
  void addField(FieldElement element) {
    _fields.add(element);
  }

  @override
  void addInterface(InterfaceType element) {
    final interfaceName = fullClassName(element.element);
    _relationships.add('[$interfaceName]<:--[$_currentClass]');
  }

  @override
  void addMethod(MethodElement element) {
    _methods.add(element);
  }

  @override
  void addMixin(InterfaceType element) {
    final mixinName = fullClassName(element.element);
    _relationships.add('[$mixinName]<:-[$_currentClass]');
  }

  @override
  void addSuper(InterfaceType element) {
    final superName = fullClassName(element.element);
    _relationships.add('[$superName]<:-[$_currentClass]');
  }

  @override
  void beginClass(ClassElement element) {
    final name = fullClassName(element);
    _currentClass = name;

    _lines.add('[$name');
  }

  @override
  void endClass(ClassElement element) {
    finalizeFields();
    finalizeMethods();
    _lines.add(']');

    if (_relationships.isNotEmpty) {
      _lines.add('');
      _lines.addAll(_relationships);
    }

    _lines.add('');

    _currentClass = null;
    _fields.clear();
    _methods.clear();
    _relationships.clear();
  }

  void finalizeFields() {
    if (_fields.isEmpty) {
      return;
    }
    _lines.add('  |');
    _lines.add(_fields.map((element) {
      final staticPrefix = element.isStatic ? '<static>' : '';
      final visibilityPrefix = getVisibility(element);
      final fieldName = element.name;
      final fieldType = typeName(element);
      return '  $staticPrefix$visibilityPrefix$fieldName: $fieldType';
    }).join(';\n'));
  }

  void finalizeMethods() {
    if (_methods.isEmpty) {
      return;
    }
    _lines.add('  |');
    _lines.add(_methods.map((element) {
      final visibilityPrefix = getVisibility(element);
      final staticPrefix = element.isStatic ? '<static>' : '';
      final methodName = element.name;
      final methodType = element.returnType.name;
      return '  $staticPrefix$visibilityPrefix$methodType $methodName()';
    }).join(';\n'));
  }

  String fullClassName(ClassElement element) {
    final abstractModifier = element.isAbstract ? '<abstract>' : '';
    final className = typeName(element);
    return '$abstractModifier$className';
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
