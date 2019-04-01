import 'dart:io';

ProcessResult runWith(Iterable<String> arguments) =>
    Process.runSync('pub', ['run', 'dcdg']..addAll(arguments));
