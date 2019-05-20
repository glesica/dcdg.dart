import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:dcdg/src/builders/diagram_builder.dart';

class DotBuilder implements DiagramBuilder {
  String _currentClass;

  final List<String> _lines = [
    'strict digraph {',
    '',
  ];

  @override
  void addAggregation(FieldElement element) {
    // TODO: implement addAggregate
  }

  @override
  void addField(FieldElement element) {
    // TODO: implement addField
  }

  @override
  void addInterface(InterfaceType element) {
    final interfaceElement = element.element;
    final interfaceClass = namespacedTypeName(interfaceElement);
    _lines.add('  $_currentClass -> $interfaceClass');
  }

  @override
  void addMethod(MethodElement element) {
    // TODO: implement addMethod
  }

  @override
  void addMixin(InterfaceType element) {
    final mixinElement = element.element;
    final mixinClass = namespacedTypeName(mixinElement);
    _lines.add('  $_currentClass -> $mixinClass');
  }

  @override
  void addSuper(InterfaceType element) {
    final superElement = element.element;
    final superClass = namespacedTypeName(superElement);
    _lines.add('  $_currentClass -> $superClass');
  }

  @override
  void beginClass(ClassElement element) {
    _currentClass = namespacedTypeName(element);
  }

  @override
  void endClass(ClassElement element) {
    _currentClass = null;
  }

  String namespacedTypeName(Element element) {
    final namespace = element.library.identifier
        .replaceFirst('package:', '')
        .replaceFirst('dart:', '');
    final className = element.name;
    return '"$namespace$className"';
  }

  @override
  void printContent(void Function(String content) printer) {
    final content = ([]
          ..addAll(_lines)
          ..add('')
          ..add('}'))
        .join('\n');
    printer(content);
  }

  @override
  void writeContent(File file) {
    printContent(file.writeAsStringSync);
  }
}
