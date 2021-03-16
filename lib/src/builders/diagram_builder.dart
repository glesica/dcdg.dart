import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

abstract class DiagramBuilder {
  void addAggregation(FieldElement element);

  void addField(FieldElement element);

  void addInterface(InterfaceType element);

  void addMethod(MethodElement element);

  void addMixin(InterfaceType element);

  void addSuper(InterfaceType element);

  void beginClass(ClassElement element);

  void endClass(ClassElement element);

  void printContent(void Function(String content) printer);

  void writeContent(File file);
}
