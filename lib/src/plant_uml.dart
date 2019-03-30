import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:dartagram/src/constants.dart';
import 'package:dartagram/src/visitor.dart';
import 'package:path/path.dart' as path;

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
  final lines = <String>[
    '@startuml',
    'set namespaceSeparator $namespaceSeparator'
  ];

  final visitor = new PlantUmlVisitor();

  for (final file in files) {
    final filePath = path.normalize(path.absolute(file.path));
    final context = contextCollection.contextFor(filePath);
    final library = await context.currentSession.getResolvedLibrary(filePath);

    library.element.accept(visitor);
  }

  if (visitor.lines.isNotEmpty) {
    lines.addAll(visitor.lines);
    lines.add('');
  }

  lines.add('@enduml');

  return lines.join('\n');
}
