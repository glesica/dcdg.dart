import 'package:analyzer/dart/element/element.dart';
import 'package:dcdg/src/builders/diagram_builder.dart';
import 'package:dcdg/src/diagram_visitor.dart';
import 'package:meta/meta.dart';

void buildDiagram({
  @required DiagramBuilder builder,
  @required Iterable<LibraryElement> libraries,
  bool excludePrivateClasses,
  bool excludePrivateFields,
  bool excludePrivateMethods,
  Iterable<RegExp> excludes,
  bool exportedOnly,
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
    exportedOnly: exportedOnly,
    includes: includes,
  );

  for (final library in libraries) {
    library.accept(visitor);
  }
}
