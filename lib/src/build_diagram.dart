import 'package:analyzer/dart/element/element.dart';
import 'package:dcdg/src/builders/diagram_builder.dart';
import 'package:dcdg/src/diagram_visitor.dart';

/// Build a diagram using the given builder from the given class
/// elements.
void buildDiagram({
  required DiagramBuilder builder,
  required Iterable<ClassElement> classElements,
  required bool excludeHasA,
  required bool excludeIsA,
  required bool excludePrivateClasses,
  required bool excludePrivateFields,
  required bool excludePrivateMethods,
  required Iterable<RegExp> excludes,
  required Iterable<RegExp> hasA,
  required Iterable<RegExp> includes,
  required Iterable<RegExp> isA,
  required bool verbose,
}) {
  final visitor = DiagramVisitor(
    onAggregateField: builder.addAggregation,
    onField: builder.addField,
    onEndClass: builder.endClass,
    onInterface: builder.addInterface,
    onMethod: builder.addMethod,
    onMixin: builder.addMixin,
    onBeginClass: builder.beginClass,
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
    verbose: verbose,
  );

  for (final element in classElements) {
    element.accept(visitor);
  }
}
