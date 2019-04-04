import 'dart:io';

import 'package:analyzer/dart/element/element.dart';

abstract class DiagramBuilder {
  void addField(FieldElement element);

  void addMethod(MethodElement element);

  void finishClass(ClassElement element);

  void printContent(void printer(String content));

  void startClass(ClassElement element);

  void writeContent(File file);
}
