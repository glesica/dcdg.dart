import 'dart:io';

import 'package:analyzer/dart/element/element.dart';

abstract class UmlBuilder {
  void printContent(void printer(String content));

  void processClass(ClassElement element);

  void writeContent(File file);
}
