import 'package:analyzer/dart/element/element.dart';

/// An [ElementVisitor] implementation that can build up a UML
/// diagram as a text file of some sort.
abstract class UmlBuilder implements ElementVisitor<void> {
  Iterable<String> get lines;
}
