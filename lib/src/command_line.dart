import 'package:args/args.dart';

const blacklistOption = 'blacklist';
const helpOption = 'help';
const outputPathOption = 'output';
const packagePathOption = 'package';
const whitelistOption = 'whitelist';

final argParser = new ArgParser(usageLineLength: 80)
  ..addMultiOption(
    blacklistOption,
    abbr: 'b',
    help: 'Class / type names to ignore',
  )
  ..addFlag(
    helpOption,
    abbr: 'h',
    help: 'Show usage information',
    negatable: false,
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
    whitelistOption,
    abbr: 'w',
    help: 'Class / type names to include',
  );

String makeHelp() {
  final usage = argParser.usage;
  return '''Usage: dartagram [options]

$usage

Note: If both blacklist and whitelist are supplied, types in both lists
will be removed from the whitelist and then the whitelist will be applied
as usual.''';
}
