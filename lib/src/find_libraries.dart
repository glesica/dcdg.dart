import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:dcdg/src/class_element_collector.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

Future<Iterable<ClassElement>> findClassElements({
  @required String packagePath,
  bool exportOnly,
}) async {
  String makePackageSubPath(String part0, [String part1]) => path.normalize(
        path.absolute(
          path.join(
            packagePath,
            part0,
            part1,
          ),
        ),
      );

  final contextCollection = AnalysisContextCollection(
    includedPaths: [
      // TODO: Handle other possible directories like web/ and bin/
      makePackageSubPath('lib'),
      makePackageSubPath('lib', 'src'),
    ],
  );

  // TODO: Allow the starting point to be customized on the command line
  final dartFiles =
      Directory(makePackageSubPath('lib')).listSync(recursive: true);

  final collector = ClassElementCollector(
    exportOnly: exportOnly,
  );
  for (final file in dartFiles) {
    final filePath = path.normalize(path.absolute(file.path));
    final context = contextCollection.contextFor(filePath);

    final libraryResult =
        await context.currentSession.getResolvedLibrary(filePath);
    libraryResult.element.accept(collector);
  }

  return collector.classElements;
}
