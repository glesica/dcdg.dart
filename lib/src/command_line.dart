import 'package:args/args.dart';
import 'package:dcdg/src/builder_factories.dart';

const builderOption = 'builder';
const excludeOption = 'exclude';
const excludePrivateOption = 'exclude-private';
const exportedOnlyOption = 'exported-only';
const hasAOption = 'has-a';
const helpOption = 'help';
const includeOption = 'include';
const isAOption = 'is-a';
const outputPathOption = 'output';
const packagePathOption = 'package';
const searchPathOption = 'search-path';

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
    exportedOnlyOption,
    help: 'Include only classes exported from the Dart package',
    negatable: false,
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
    defaultsTo: null,
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
options accept regular expressions.

Note: If both excludes and includes are supplied, types that are in
both lists will be removed from the includes list and then the
includes list will be applied as usual.''';
}
