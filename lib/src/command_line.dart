import 'package:args/args.dart';
import 'package:dcdg/src/builder_factories.dart';
import 'package:dcdg/src/version.dart';

const builderOption = 'builder';
const excludeOption = 'exclude';
const excludeHasAOption = 'exclude-has-a';
const excludeIsAOption = 'exclude-is-a';
const excludePrivateOption = 'exclude-private';
const exportedOnlyOption = 'exported-only';
const hasAOption = 'has-a';
const helpOption = 'help';
const includeOption = 'include';
const isAOption = 'is-a';
const outputPathOption = 'output';
const packagePathOption = 'package';
const searchPathOption = 'search-path';
const versionOption = 'version';
const verboseOption = 'verbose';

final argParser = ArgParser(usageLineLength: 80)
  ..addOption(
    builderOption,
    abbr: 'b',
    help: 'Builder to use to construct a class diagram',
    valueHelp: 'NAME',
    defaultsTo: availableBuilders().first.name,
  )
  ..addMultiOption(
    excludeOption,
    abbr: 'e',
    help: 'Class / type names to exclude, can be a regular expression',
    valueHelp: 'TYPE',
  )
  ..addMultiOption(
    excludePrivateOption,
    help: 'Exclude private entities (field, method, class, or all)',
    valueHelp: 'KIND',
  )
  ..addFlag(
    excludeHasAOption,
    help: 'Exclude has-a / aggregation relationships from the diagram output',
    negatable: false,
  )
  ..addFlag(
    excludeIsAOption,
    help: 'Exclude is-a / extension relationships from the diagram output',
    negatable: false,
  )
  ..addFlag(
    exportedOnlyOption,
    help: 'Include only classes exported from the Dart package',
    negatable: false,
    defaultsTo: false,
  )
  ..addMultiOption(
    hasAOption,
    help:
        'Include only classes with a has-a relationship to any of the named classes',
    valueHelp: 'CLASS',
  )
  ..addMultiOption(
    isAOption,
    help:
        'Include only classes with an is-a relationship to any of the named classes',
    valueHelp: 'CLASS',
  )
  ..addFlag(
    helpOption,
    abbr: 'h',
    help: 'Show usage information',
    negatable: false,
    defaultsTo: false,
  )
  ..addFlag(
    verboseOption,
    abbr: 'V',
    help: 'Show verbose output',
    negatable: false,
    defaultsTo: false,
  )
  ..addMultiOption(
    includeOption,
    abbr: 'i',
    help: 'Class / type names to include, can be a regular expression',
    valueHelp: 'TYPE',
  )
  ..addOption(
    outputPathOption,
    abbr: 'o',
    help: 'File to which output should be written (stdout if omitted)',
    valueHelp: 'FILE',
    defaultsTo: '',
  )
  ..addOption(
    packagePathOption,
    abbr: 'p',
    help: 'Path to the root of the Dart package to scan',
    valueHelp: 'DIR',
    defaultsTo: '.',
  )
  ..addOption(
    searchPathOption,
    abbr: 's',
    help: 'Directory relative to the package root to search for classes',
    valueHelp: 'DIR',
    defaultsTo: 'lib',
  )
  ..addFlag(
    versionOption,
    abbr: 'v',
    help: 'Show the version number and exit',
    negatable: false,
    defaultsTo: false,
  );

/// Return a string that contains the usage and help information
/// based on the arguments defined and the available builders.
String makeHelp() {
  final usage = argParser.usage;
  return '''Usage: dcdg [options]

$usage

Available builders:
  * ${availableBuilders().join('\n  * ')}

The --$includeOption, --$excludeOption, --$hasAOption, and --$isAOption
options accept regular expressions. These options accept multiple values,
separated by commas, or they can be passed multiple times.

Note: If both $excludeOption and $includeOption are supplied, types that
are in both lists will be removed from the includes list and then the
includes list will be applied as usual.''';
}

/// Return the version string we show on --version.
String makeVersion() {
  return 'dcdg $version';
}
