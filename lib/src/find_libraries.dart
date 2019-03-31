import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

Future<Iterable<LibraryElement>> findLibraries({
  @required String packagePath,
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

  // Attempt to verify that the package path contains a Dart package
  // of some sort.
  final pubspec = File(makePackageSubPath('pubspec.yaml'));
  if (!pubspec.existsSync()) {
    // TODO: Make this exception easier to distinguish from other errors
    throw ArgumentError.value(packagePath, 'packagePath');
  }

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

  final libraries = <LibraryElement>[];
  for (final file in dartFiles) {
    final filePath = path.normalize(path.absolute(file.path));
    final context = contextCollection.contextFor(filePath);
    final libraryResult =
        await context.currentSession.getResolvedLibrary(filePath);
    libraries.add(libraryResult.element);
  }

  return libraries;
}
