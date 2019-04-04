import 'package:args/args.dart';
import 'package:dcdg/src/uml_builder_factories.dart';
import 'package:dcdg/src/command_line.dart';
import 'package:dcdg/src/diagram_builder.dart';
import 'package:meta/meta.dart';

abstract class Configuration {
  DiagramBuilder get builder;

  String get builderName;

  Iterable<RegExp> get excludeExpressions;

  bool get exportedOnly;

  bool get excludePrivateClasses;

  bool get excludePrivateFields;

  bool get excludePrivateMethods;

  Iterable<RegExp> get includeExpressions;

  String get outputPath;

  String get packagePath;

  bool get shouldShowHelp;

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

    final excludeExpressions =
        (results[excludeOption] as Iterable<String>).map((s) => RegExp(s));
    final includeExpressions =
        (results[includeOption] as Iterable<String>).map((s) => RegExp(s));

    return ConfigurationImpl(
      builder: getBuilder(results[builderOption]),
      builderName: results[builderOption],
      excludeExpressions: excludeExpressions,
      excludePrivateClasses: excludePrivateClasses,
      excludePrivateFields: excludePrivateFields,
      excludePrivateMethods: excludePrivateMethods,
      exportedOnly: results[exportedOnlyOption],
      includeExpressions: includeExpressions,
      outputPath: results[outputPathOption],
      packagePath: results[packagePathOption],
      shouldShowHelp: results[helpOption],
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
  final Iterable<RegExp> excludeExpressions;

  @override
  final bool excludePrivateClasses;

  @override
  final bool excludePrivateFields;

  @override
  final bool excludePrivateMethods;

  @override
  final bool exportedOnly;

  @override
  final Iterable<RegExp> includeExpressions;

  @override
  final String outputPath;

  @override
  final String packagePath;

  @override
  final bool shouldShowHelp;

  ConfigurationImpl({
    @required this.builder,
    @required this.builderName,
    @required this.excludeExpressions,
    @required this.excludePrivateClasses,
    @required this.excludePrivateFields,
    @required this.excludePrivateMethods,
    @required this.exportedOnly,
    @required this.includeExpressions,
    @required this.outputPath,
    @required this.packagePath,
    @required this.shouldShowHelp,
  });
}
