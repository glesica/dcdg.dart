import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:dartagram/src/plant_uml_builder.dart';
import 'package:dartagram/src/uml_visitor.dart';
import 'package:path/path.dart' as path;

// Convert this function to just take a generic UmlBuilder and then
// do the right thing with it. The actual file format generated
// can be handled elsewhere. This way new formats (like DOT) can be
// added more easily.

// TODO: This function should take an iterable of libraries?
Future<String> buildPlantUml(
  String packagePath, {
  Iterable<String> blacklist,
  Iterable<String> whitelist,
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

  final pubspec = File(makePackageSubPath('pubspec.yaml'));
  if (!pubspec.existsSync()) {
    throw new ArgumentError.value(packagePath, 'packagePath');
  }

  final contextCollection = new AnalysisContextCollection(
    includedPaths: [
      // TODO: Handle other possible directories like web/ and bin/
      makePackageSubPath('lib'),
      makePackageSubPath('lib', 'src'),
    ],
  );
  // TODO: Allow the starting point to be customized on the command line
  final files =
      new Directory(makePackageSubPath('lib')).listSync(recursive: true);

  final builder = new PlantUmlBuilder();
  final visitor = new UmlVisitor(
    builder,
    blacklist: blacklist,
    whitelist: whitelist,
  );

  for (final file in files) {
    final filePath = path.normalize(path.absolute(file.path));
    final context = contextCollection.contextFor(filePath);
    final library = await context.currentSession.getResolvedLibrary(filePath);
    library.element.accept(visitor);
  }

  return builder.build();
}
