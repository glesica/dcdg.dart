import 'dart:async';
import 'dart:io';

import 'package:dcdg/dcdg.dart';
import 'package:dcdg/src/command_line.dart';
import 'package:path/path.dart' as path;

Future<Null> main(Iterable<String> arguments) async {
  final config = Configuration.fromCommandLine(arguments);

  if (config.shouldShowHelp) {
    print(makeHelp());
    exit(0);
  }

  if (config.shouldShowVersion) {
    print(makeVersion());
    exit(0);
  }

  // TODO: Move validation to the Configuration itself for easier testing

  if (config.builder == null) {
    outputError('Builder "${config.builderName}" was not found');
    exit(1);
  }
  final builder = config.builder!;

  final pubspec = File(path.join(config.packagePath, 'pubspec.yaml'));
  if (!pubspec.existsSync()) {
    outputError('No Dart package found at "${config.packagePath}"');
    exit(1);
  }

  final classes = await findClassElements(
    exportedOnly: config.exportedOnly,
    packagePath: config.packagePath,
    searchPath: config.searchPath,
  );

  buildDiagram(
    builder: builder,
    classElements: classes,
    excludeHasA: config.excludeHasA,
    excludeIsA: config.excludeIsA,
    excludePrivateClasses: config.excludePrivateClasses,
    excludePrivateFields: config.excludePrivateFields,
    excludePrivateMethods: config.excludePrivateMethods,
    excludes: config.excludeExpressions,
    hasA: config.hasAExpressions,
    includes: config.includeExpressions,
    isA: config.isAExpressions,
  );

  if (config.outputPath == '') {
    builder.printContent(print);
  } else {
    final outFile = File(config.outputPath);
    try {
      builder.writeContent(outFile);
    } on FileSystemException catch (exception) {
      outputError(
        'Failed writing to file ${exception.path} (${exception.osError})',
        exception,
      );
      exit(1);
    }
  }
}

void outputError(String message, [Exception? exception]) {
  stderr.writeln('Error: $message');
  if (exception != null) {
    stderr.writeln(exception.toString());
  }
}
