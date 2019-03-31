import 'dart:async';
import 'dart:io';

import 'package:dartagram/dartagram.dart';
import 'package:path/path.dart' as path;

// TODO: Export the necessary stuff
import 'package:dartagram/src/command_line.dart';
import 'package:dartagram/src/configuration.dart';
import 'package:dartagram/src/find_libraries.dart';

Future<Null> main(Iterable<String> arguments) async {
  final config = Configuration.fromCommandLine(arguments);

  if (config.shouldShowHelp) {
    print(makeHelp());
    exit(0);
  }

  // TODO: Move validation to the Configuration itself for easier testing

  if (config.builder == null) {
    outputError('Builder "${config.builderName}" was not found');
    exit(1);
  }

  final pubspec = File(path.join(config.packagePath, 'pubspec.yaml'));
  if (!pubspec.existsSync()) {
    outputError('No Dart package found at ${config.packagePath}');
    exit(1);
  }

  final libraries = await findLibraries(packagePath: config.packagePath);

  buildUml(
    builder: config.builder,
    libraries: libraries,
    excludes: config.typeExcludes,
    includes: config.typeIncludes,
  );

  if (config.outputPath == '') {
    config.builder.printContent(print);
  } else {
    final outFile = File(config.outputPath);
    try {
      config.builder.writeContent(outFile);
    } on FileSystemException catch (exception) {
      outputError(
        'Failed writing to file ${exception.path} (${exception.osError})',
        exception,
      );
      exit(1);
    }
  }
}

void outputError(String message, [Exception exception]) {
  stderr.writeln('Error: $message');
  if (exception != null) {
    stderr.writeln(exception.toString());
  }
}
