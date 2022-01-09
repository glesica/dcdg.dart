import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:dcdg/src/class_element_collector.dart';
import 'package:path/path.dart' as path;

/// Fetch and return the desired class elements from the package
/// rooted at the given path.
Future<Iterable<ClassElement>> findClassElements({
  required String packagePath,
  required bool exportedOnly,
  required String searchPath,
}) async {
  String makePackageSubPath(String part0, [String part1 = '']) =>
      path.normalize(
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
      makePackageSubPath('lib'),
      makePackageSubPath('lib', 'src'),
      makePackageSubPath('bin'),
      makePackageSubPath('web'),
    ],
  );

  final dartFiles = Directory(makePackageSubPath(searchPath))
      .listSync(recursive: true)
      .where((file) => path.extension(file.path) == '.dart')
      .where((file) => !exportedOnly || !file.path.contains('lib/src/'));

  final collector = ClassElementCollector(
    exportedOnly: exportedOnly,
  );
  for (final file in dartFiles) {
    final filePath = path.normalize(path.absolute(file.path));
    final context = contextCollection.contextFor(filePath);

    final unitResult = await context.currentSession.getResolvedUnit(filePath);
    if (unitResult is ResolvedUnitResult) {
      // Skip parts files to avoid duplication.
      if (!unitResult.isPart) {
        unitResult.libraryElement.accept(collector);
      }
    }
  }

  return collector.classElements;
}
