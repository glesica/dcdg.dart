import 'package:analyzer/dart/element/element.dart';

abstract class UmlBuilder<T> {
  T build();

  void processClass(ClassElement element);
}
