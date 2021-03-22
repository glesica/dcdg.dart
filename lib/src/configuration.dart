import 'package:args/args.dart';
import 'package:dcdg/src/builder_factories.dart';
import 'package:dcdg/src/builders/diagram_builder.dart';
import 'package:dcdg/src/command_line.dart';

/// A full configuration to allow fetching classes and running
/// a builder against a Dart package.
abstract class Configuration {
  DiagramBuilder? get builder;

  String get builderName;

  Iterable<RegExp> get excludeExpressions;

  bool get excludeHasA;

  bool get excludeIsA;

  bool get exportedOnly;

  bool get excludePrivateClasses;

  bool get excludePrivateFields;

  bool get excludePrivateMethods;

  Iterable<RegExp> get hasAExpressions;

  Iterable<RegExp> get includeExpressions;

  Iterable<RegExp> get isAExpressions;

  String get outputPath;

  String get packagePath;

  String get searchPath;

  bool get shouldShowHelp;

  bool get shouldShowVersion;

  bool get verbose;

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

    final excludeHasA = results[excludeHasAOption];
    final excludeIsA = results[excludeIsAOption];

    final excludeExpressions =
        (results[excludeOption] as Iterable<String>).map((s) => RegExp(s));
    final includeExpressions =
        (results[includeOption] as Iterable<String>).map((s) => RegExp(s));

    final hasAExpressions =
        (results[hasAOption] as Iterable<String>).map((s) => RegExp(s));
    final isAExpressions =
        (results[isAOption] as Iterable<String>).map((s) => RegExp(s));

    final builderName = results[builderOption];
    final builder = getBuilder(builderName);

    return ConfigurationImpl(
      builder: builder,
      builderName: builderName,
      excludeExpressions: excludeExpressions,
      excludeHasA: excludeHasA,
      excludeIsA: excludeIsA,
      excludePrivateClasses: excludePrivateClasses,
      excludePrivateFields: excludePrivateFields,
      excludePrivateMethods: excludePrivateMethods,
      exportedOnly: results[exportedOnlyOption]!,
      hasAExpressions: hasAExpressions,
      includeExpressions: includeExpressions,
      isAExpressions: isAExpressions,
      outputPath: results[outputPathOption]!,
      packagePath: results[packagePathOption]!,
      searchPath: results[searchPathOption]!,
      shouldShowHelp: results[helpOption]!,
      shouldShowVersion: results[versionOption]!,
      verbose: results[verboseOption]!,
    );
  }

  factory Configuration.fromCommandLine(Iterable<String> arguments) {
    final results = argParser.parse(arguments);
    return Configuration.fromArgResults(results);
  }
}

class ConfigurationImpl implements Configuration {
  @override
  final DiagramBuilder? builder;

  @override
  final String builderName;

  @override
  final Iterable<RegExp> excludeExpressions;

  @override
  final bool excludeHasA;

  @override
  final bool excludeIsA;

  @override
  final bool excludePrivateClasses;

  @override
  final bool excludePrivateFields;

  @override
  final bool excludePrivateMethods;

  @override
  final bool exportedOnly;

  @override
  Iterable<RegExp> hasAExpressions;

  @override
  final Iterable<RegExp> includeExpressions;

  @override
  Iterable<RegExp> isAExpressions;

  @override
  final String outputPath;

  @override
  final String packagePath;

  @override
  final String searchPath;

  @override
  final bool shouldShowHelp;

  @override
  final bool shouldShowVersion;

  @override
  final bool verbose;

  ConfigurationImpl({
    required this.builder,
    required this.builderName,
    required this.excludeExpressions,
    required this.excludeHasA,
    required this.excludeIsA,
    required this.excludePrivateClasses,
    required this.excludePrivateFields,
    required this.excludePrivateMethods,
    required this.exportedOnly,
    required this.hasAExpressions,
    required this.includeExpressions,
    required this.isAExpressions,
    required this.outputPath,
    required this.packagePath,
    required this.searchPath,
    required this.shouldShowHelp,
    required this.shouldShowVersion,
    required this.verbose,
  });
}
