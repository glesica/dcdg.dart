import 'dart:async';
import 'dart:io';

import 'package:dartagram/dartagram.dart';
// TODO: Export the necessary stuff
import 'package:dartagram/src/command_line.dart';
import 'package:dartagram/src/configuration.dart';

Future<Null> main(Iterable<String> arguments) async {
  final config = Configuration.fromCommandLine(arguments);

  if (config.shouldShowHelp) {
    print(makeHelp());
    exit(0);
  }

  String plantUml;
  try {
    plantUml = await buildPlantUml(config.packagePath);
  } on ArgumentError catch (_) {
    outputError('Package path is not a Dart package (${config.packagePath}');
    exit(1);
  }

  if (config.outputPath == '') {
    print(plantUml);
  } else {
    final plantUmlFile = new File(config.outputPath);
    try {
      plantUmlFile.writeAsStringSync(plantUml);
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
