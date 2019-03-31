import 'package:analyzer/dart/element/element.dart';

abstract class UmlBuilder<T> {
  void processClass(ClassElement element);

  T build();
}
