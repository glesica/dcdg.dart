import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:dcdg/src/builders/diagram_builder.dart';

class DotBuilder implements DiagramBuilder {
  String _currentClass;

  final List<String> _lines = [
    'strict digraph {',
    '',
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

  @override
  void addField(FieldElement element) {
    // TODO: implement addField
  }

  void addInterfaces(ClassElement element) {
    if (element.interfaces.isEmpty) {
      return;
    }

    for (final interface in element.interfaces) {
      final interfaceElement = interface.element;
      final interfaceClass = getNamespacedTypeName(interfaceElement);
      _lines.add('  $_currentClass -> $interfaceClass');
    }
  }

  @override
  void addMethod(MethodElement element) {
    // TODO: implement addMethod
  }

  void addMixins(ClassElement element) {
    if (element.mixins.isEmpty) {
      return;
    }

    for (final mixin in element.mixins) {
      final mixinElement = mixin.element;
      final mixinClass = getNamespacedTypeName(mixinElement);
      _lines.add('  $_currentClass -> $mixinClass');
    }
  }

  void addSuper(ClassElement element) {
    final superElement = element.supertype.element;

    if (superElement.name == 'Object') {
      return;
    }

    final superClass = getNamespacedTypeName(superElement);
    _lines.add('  $_currentClass -> $superClass');
  }

  @override
  void finishClass(ClassElement element) {
    _currentClass = null;
  }

  String getNamespacedTypeName(Element element) {
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
  void startClass(ClassElement element) {
    _currentClass = getNamespacedTypeName(element);

    addSuper(element);
    addInterfaces(element);
    addMixins(element);
  }

  @override
  void writeContent(File file) {
    printContent(file.writeAsStringSync);
  }
}
