import 'dart:async';
import 'dart:io';

import 'package:dartagram/dartagram.dart';

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

  try {
    final libraries = await findLibraries(packagePath: config.packagePath);

    buildUml(
      builder: config.builder,
      libraries: libraries,
      excludes: config.typeExcludes,
      includes: config.typeIncludes,
    );
  } on ArgumentError catch (_) {
    outputError('Package path is not a Dart package (${config.packagePath}');
    exit(1);
  }

  if (config.outputPath == '') {
    print(config.builder.build());
  } else {
    final plantUmlFile = File(config.outputPath);
    try {
      plantUmlFile.writeAsStringSync(config.builder.build());
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
