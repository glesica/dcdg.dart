import 'dart:io';

import 'package:path/path.dart' as path;

bool _hasPubGetRun = false;

void pubGetFixtures() {
  if (_hasPubGetRun) {
    return;
  }

  Directory('test/fixtures/').listSync().whereType<Directory>().forEach((d) {
    final files = d.listSync().whereType<File>();

    // Skip the directory if it isn't a valid package.
    if (!files.any((f) => f.path.endsWith('${path.separator}pubspec.yaml'))) {
      return;
    }

    // Try to short circuit if the lock file is up-to-date.
    // This shaves about 2 minutes off the time to run the full test suite,
    // or about 40%.
    if (files.any((f) => f.path.endsWith('${path.separator}pubspec.lock'))) {
      final yaml = files
          .firstWhere((f) => f.path.endsWith('${path.separator}pubspec.yaml'));
      final lock = files
          .firstWhere((f) => f.path.endsWith('${path.separator}pubspec.lock'));

      final yamlMod = yaml.lastModifiedSync();
      final lockMod = lock.lastModifiedSync();
      if (lockMod.isAfter(yamlMod)) {
        return;
      }
    }

    final result =
        Process.runSync('dart', ['pub', 'get'], workingDirectory: d.path);
    if (result.exitCode != 0) {
      throw ProcessException(
        'dart',
        ['pub', 'get'],
        'dart pub get failed on fixture ${d.path}',
        result.exitCode,
      );
    }
  });

  _hasPubGetRun = true;
}

ProcessResult runWith(Iterable<String> arguments, String against) =>
    Process.runSync(
      'dart',
      [
        'run',
        '--verbosity',
        'all',
        'dcdg',
        ...arguments,
      ],
      workingDirectory: against,
    );
