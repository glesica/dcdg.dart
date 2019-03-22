import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:dartagram/src/constants.dart';
import 'package:dartagram/src/visitor.dart';
import 'package:path/path.dart' as path;

Future<Null> buildDiagram() async {
  final contextCollection = new AnalysisContextCollection(
    includedPaths: [
      path.normalize(path.absolute('lib/')),
      path.normalize(path.absolute('lib/src/')),
    ],
  );
  final files = new Directory('lib/').listSync(recursive: true);
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

  final umlFile = new File('out.puml');
  umlFile.writeAsStringSync(lines.join('\n'));
}
