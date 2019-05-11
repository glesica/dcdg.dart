import 'dart:io';

import 'package:analyzer/dart/element/element.dart';

abstract class DiagramBuilder {
  set excludeHasA(bool value);

  set excludeIsA(bool value);

  set excludePrivateClasses(bool value);

  set excludePrivateFields(bool value);

  set excludePrivateMethods(bool value);

  void addField(FieldElement element);

  void addMethod(MethodElement element);

  void finishClass(ClassElement element);

  void printContent(void printer(String content));

  void startClass(ClassElement element);

  void writeContent(File file);
}
