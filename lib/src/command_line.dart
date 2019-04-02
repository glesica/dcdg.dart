import 'package:args/args.dart';
import 'package:dcdg/src/uml_builder_factories.dart';

const builderOption = 'builder';
const excludeOption = 'exclude';
const excludePrivateOption = 'exclude-private';
const exportedOnlyOption = 'exported-only';
const helpOption = 'help';
const includeOption = 'include';
const outputPathOption = 'output';
const packagePathOption = 'package';

final argParser = ArgParser(usageLineLength: 80)
  ..addOption(
    builderOption,
    abbr: 'b',
    help: 'Builder to use to construct a class diagram',
    valueHelp: 'NAME',
    defaultsTo: availableBuilders().first,
  )
  ..addMultiOption(
    excludeOption,
    abbr: 'e',
    help: 'Class / type names to ignore',
    valueHelp: 'TYPE',
  )
  ..addMultiOption(
    excludePrivateOption,
    help: 'Exclude private entities (field, method, class, or all)',
    valueHelp: 'KIND',
  )
  ..addFlag(
    exportedOnlyOption,
    help: 'Include only classes exported from the Dart package (coming soon)',
    negatable: false,
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
    help: 'Class / type names to include',
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
  );

String makeHelp() {
  final usage = argParser.usage;
  return '''Usage: dcdg [options]

$usage

Available builders:
  * ${availableBuilders().join('\n  * ')}

Note: If both excludes and includes are supplied, types that are in
both lists will be removed from the includes list and then the
includes list will be applied as usual.''';
}
