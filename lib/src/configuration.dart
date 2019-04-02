import 'package:args/args.dart';
import 'package:dcdg/src/uml_builder_factories.dart';
import 'package:dcdg/src/command_line.dart';
import 'package:dcdg/src/diagram_builder.dart';
import 'package:meta/meta.dart';

abstract class Configuration {
  DiagramBuilder get builder;

  String get builderName;

  bool get exportedOnly;

  bool get excludePrivateClasses;

  bool get excludePrivateFields;

  bool get excludePrivateMethods;

  String get outputPath;

  String get packagePath;

  bool get shouldShowHelp;

  Iterable<String> get typeExcludes;

  Iterable<String> get typeIncludes;

  factory Configuration.fromArgResults(ArgResults results) {
    final excludePrivateValues =
        results[excludePrivateOption] as Iterable<String>;
    final excludePrivateAll = excludePrivateValues.contains('all');
    final excludePrivateClasses =
        excludePrivateAll || excludePrivateValues.contains('class');
    final excludePrivateFields =
        excludePrivateAll || excludePrivateValues.contains('field');
    final excludePrivateMethods =
        excludePrivateAll || excludePrivateValues.contains('method');

    return ConfigurationImpl(
      builder: getBuilder(results[builderOption]),
      builderName: results[builderOption],
      excludePrivateClasses: excludePrivateClasses,
      excludePrivateFields: excludePrivateFields,
      excludePrivateMethods: excludePrivateMethods,
      exportedOnly: results[exportedOnlyOption],
      outputPath: results[outputPathOption],
      packagePath: results[packagePathOption],
      shouldShowHelp: results[helpOption],
      typeExcludes: results[excludeOption],
      typeIncludes: results[includeOption],
    );
  }

  factory Configuration.fromCommandLine(List<String> arguments) {
    final results = argParser.parse(arguments);
    return Configuration.fromArgResults(results);
  }
}

class ConfigurationImpl implements Configuration {
  @override
  final DiagramBuilder builder;

  @override
  final String builderName;

  @override
  final bool excludePrivateClasses;

  @override
  final bool excludePrivateFields;

  @override
  final bool excludePrivateMethods;

  @override
  final bool exportedOnly;

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
    @required this.exportedOnly,
    @required this.excludePrivateClasses,
    @required this.excludePrivateFields,
    @required this.excludePrivateMethods,
    @required this.outputPath,
    @required this.packagePath,
    @required this.shouldShowHelp,
    @required this.typeExcludes,
    @required this.typeIncludes,
  });
}
