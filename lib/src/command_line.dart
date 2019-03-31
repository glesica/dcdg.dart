import 'package:args/args.dart';
import 'package:dartagram/src/uml_builder_factories.dart';

const exludeOption = 'exclude';
const builderOption = 'builder';
const helpOption = 'help';
const outputPathOption = 'output';
const packagePathOption = 'package';
const includeOption = 'include';

final argParser = new ArgParser(usageLineLength: 80)
  ..addMultiOption(
    exludeOption,
    abbr: 'e',
    help: 'Class / type names to ignore',
  )
  ..addFlag(
    helpOption,
    abbr: 'h',
    help: 'Show usage information',
    negatable: false,
  )
  ..addOption(
    builderOption,
    abbr: 'b',
    help: 'Builder to use to construct a UML diagram',
    valueHelp: 'NAME',
    defaultsTo: availableBuilders().first,
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
  ..addMultiOption(
    includeOption,
    abbr: 'i',
    help: 'Class / type names to include',
  );

String makeHelp() {
  final usage = argParser.usage;
  return '''Usage: dartagram [options]

$usage

Available builders:
  * ${availableBuilders().join('\n  * ')}

Note: If both excludes and includes are supplied, types that are in
both lists will be removed from the includes list and then the
includes list will be applied as usual.''';
}
