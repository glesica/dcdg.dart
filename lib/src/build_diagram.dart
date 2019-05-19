import 'package:analyzer/dart/element/element.dart';
import 'package:dcdg/src/builders/diagram_builder.dart';
import 'package:dcdg/src/diagram_visitor.dart';
import 'package:meta/meta.dart';

/// Build a diagram using the given builder from the given class
/// elements.
void buildDiagram({
  @required DiagramBuilder builder,
  @required Iterable<ClassElement> classElements,
  bool excludeHasA,
  bool excludeIsA,
  bool excludePrivateClasses,
  bool excludePrivateFields,
  bool excludePrivateMethods,
  Iterable<RegExp> excludes,
  Iterable<RegExp> hasA,
  Iterable<RegExp> includes,
  Iterable<RegExp> isA,
}) {
  final visitor = DiagramVisitor(
    onAggregateField: builder.addAggregation,
    onField: builder.addField,
    onFinishClass: builder.endClass,
    onInterface: builder.addInterface,
    onMethod: builder.addMethod,
    onMixin: builder.addMixin,
    onStartClass: builder.beginClass,
    onSuper: builder.addSuper,
    excludeHasA: excludeHasA,
    excludeIsA: excludeIsA,
    excludePrivateClasses: excludePrivateClasses,
    excludePrivateFields: excludePrivateMethods,
    excludePrivateMethods: excludePrivateMethods,
    excludes: excludes,
    hasA: hasA,
    includes: includes,
    isA: isA,
  );

  for (final element in classElements) {
    element.accept(visitor);
  }
}
