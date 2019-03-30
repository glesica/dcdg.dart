import 'package:args/args.dart';
import 'package:dartagram/src/command_line.dart';
import 'package:meta/meta.dart';

abstract class Configuration {
  String get outputPath;

  String get packagePath;

  bool get shouldShowHelp;

  Iterable<String> get typeBlacklist;

  Iterable<String> get typeWhitelist;

  factory Configuration.fromArgResults(ArgResults results) => ConfigurationImpl(
        outputPath: results[outputPathOption],
        packagePath: results[packagePathOption],
        shouldShowHelp: results[helpOption],
        typeBlacklist: results[blacklistOption],
        typeWhitelist: results[whitelistOption],
      );

  factory Configuration.fromCommandLine(List<String> arguments) {
    final results = argParser.parse(arguments);
    return Configuration.fromArgResults(results);
  }
}

class ConfigurationImpl implements Configuration {
  @override
  final String outputPath;

  @override
  final String packagePath;

  @override
  final bool shouldShowHelp;

  @override
  final Iterable<String> typeBlacklist;

  @override
  final Iterable<String> typeWhitelist;

  ConfigurationImpl({
    @required this.outputPath,
    @required this.packagePath,
    @required this.shouldShowHelp,
    @required this.typeBlacklist,
    @required this.typeWhitelist,
  });
}
