import 'package:analyzer/dart/element/element.dart';
import 'package:dcdg/src/uml_builder.dart';
import 'package:dcdg/src/uml_visitor.dart';
import 'package:meta/meta.dart';

void buildUml({
  @required UmlBuilder builder,
  @required Iterable<LibraryElement> libraries,
  Iterable<String> excludes,
  Iterable<String> includes,
}) {
  final visitor = UmlVisitor(
    onClass: (element) {
      builder.processClass(element);
    },
    excludes: excludes,
    includes: includes,
  );

  for (final library in libraries) {
    library.accept(visitor);
  }
}
