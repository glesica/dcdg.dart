import 'package:args/args.dart';
import 'package:dcdg/src/uml_builder_factories.dart';
import 'package:dcdg/src/command_line.dart';
import 'package:dcdg/src/uml_builder.dart';
import 'package:meta/meta.dart';

abstract class Configuration {
  UmlBuilder get builder;

  String get builderName;

  String get outputPath;

  String get packagePath;

  bool get shouldShowHelp;

  Iterable<String> get typeExcludes;

  Iterable<String> get typeIncludes;

  factory Configuration.fromArgResults(ArgResults results) => ConfigurationImpl(
        builder: getBuilder(results[builderOption]),
        builderName: results[builderOption],
        outputPath: results[outputPathOption],
        packagePath: results[packagePathOption],
        shouldShowHelp: results[helpOption],
        typeExcludes: results[exludeOption],
        typeIncludes: results[includeOption],
      );

  factory Configuration.fromCommandLine(List<String> arguments) {
    final results = argParser.parse(arguments);
    return Configuration.fromArgResults(results);
  }
}

class ConfigurationImpl implements Configuration {
  @override
  final UmlBuilder builder;

  @override
  final String builderName;

  @override
  final String outputPath;

  @override
  final String packagePath;

  @override
  final bool shouldShowHelp;

  @override
  final Iterable<String> typeExcludes;

  @override
  final Iterable<String> typeIncludes;

  ConfigurationImpl({
    @required this.builder,
    @required this.builderName,
    @required this.outputPath,
    @required this.packagePath,
    @required this.shouldShowHelp,
    @required this.typeExcludes,
    @required this.typeIncludes,
  });
}
