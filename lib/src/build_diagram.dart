import 'package:analyzer/dart/element/element.dart';
import 'package:dcdg/src/builders/diagram_builder.dart';
import 'package:dcdg/src/diagram_visitor.dart';
import 'package:meta/meta.dart';

/// Build a diagram using the given builder from the given class
/// elements.
void buildDiagram({
  @required DiagramBuilder builder,
  @required Iterable<ClassElement> classElements,
  bool excludePrivateClasses,
  bool excludePrivateFields,
  bool excludePrivateMethods,
  Iterable<RegExp> excludes,
  Iterable<RegExp> includes,
}) {
  final visitor = DiagramVisitor(
    onField: builder.addField,
    onFinishClass: builder.finishClass,
    onMethod: builder.addMethod,
    onStartClass: builder.startClass,
    excludePrivateClasses: excludePrivateClasses,
    excludePrivateFields: excludePrivateMethods,
    excludePrivateMethods: excludePrivateMethods,
    excludes: excludes,
    includes: includes,
  );

  for (final element in classElements) {
    element.accept(visitor);
  }
}
