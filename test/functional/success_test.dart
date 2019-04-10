import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('dcdg tool (success cases)', () {
    test('should produce plantuml output by default', () {
      final result = runWith(['-p', 'test/fixtures/simple/']);
      expect(result.exitCode, 0);
      expect(result.stdout, contains('PublicExternalPublic'));
      expect(result.stdout, contains('_PrivateExternalPrivate'));
      expect(result.stdout, contains('PublicInternalPublic'));
      expect(result.stdout, contains('_PrivateInternalPrivate'));
      expect(result.stdout, contains('PublicPartInternalPartPublic'));
      expect(result.stdout, contains('_PrivatePartInternalPartPrivate'));
    });

    test('should ignore excluded classes', () {
      final result = runWith([
        '-e',
        'PublicInternalPublic',
        '-p',
        'test/fixtures/simple/',
      ]);
      expect(result.exitCode, 0);
      expect(result.stdout, contains('PublicExternalPublic'));
      expect(result.stdout, contains('_PrivateExternalPrivate'));
      expect(result.stdout, isNot(contains('PublicInternalPublic')));
      expect(result.stdout, contains('_PrivateInternalPrivate'));
      expect(result.stdout, contains('PublicPartInternalPartPublic'));
      expect(result.stdout, contains('_PrivatePartInternalPartPrivate'));
    });

    test('should ignore excluded classes based on a regex', () {
      final result = runWith([
        '-e',
        '.*Internal.*',
        '-p',
        'test/fixtures/simple/',
      ]);
      expect(result.exitCode, 0);
      expect(result.stdout, contains('PublicExternalPublic'));
      expect(result.stdout, contains('_PrivateExternalPrivate'));
      expect(result.stdout, isNot(contains('PublicInternalPublic')));
      expect(result.stdout, isNot(contains('_PrivateInternalPrivate')));
      expect(result.stdout, isNot(contains('PublicPartInternalPartPublic')));
      expect(result.stdout, isNot(contains('_PrivatePartInternalPartPrivate')));
    });

    test('should limit to included classes', () {
      final result = runWith([
        '-i',
        'PublicInternalPublic',
        '-p',
        'test/fixtures/simple/',
      ]);
      expect(result.exitCode, 0);
      expect(result.stdout, isNot(contains('PublicExternalPublic')));
      expect(result.stdout, isNot(contains('_PrivateExternalPrivate')));
      expect(result.stdout, contains('PublicInternalPublic'));
      expect(result.stdout, isNot(contains('_PrivateInternalPrivate')));
      expect(result.stdout, isNot(contains('PublicPartInternalPartPublic')));
      expect(result.stdout, isNot(contains('_PrivatePartInternalPartPrivate')));
    });

    test('should limit to included classes based on a regex', () {
      final result = runWith([
        '-i',
        '.*Internal.*',
        '-p',
        'test/fixtures/simple/',
      ]);
      expect(result.exitCode, 0);
      expect(result.stdout, isNot(contains('PublicExternalPublic')));
      expect(result.stdout, isNot(contains('_PrivateExternalPrivate')));
      expect(result.stdout, contains('PublicInternalPublic'));
      expect(result.stdout, contains('_PrivateInternalPrivate'));
      expect(result.stdout, contains('PublicPartInternalPartPublic'));
      expect(result.stdout, contains('_PrivatePartInternalPartPrivate'));
    });

    test('should ignore unexported classes', () {
      final result = runWith([
        '--exported-only',
        '-p',
        'test/fixtures/simple/',
      ]);
      expect(result.exitCode, 0);
      expect(result.stdout, contains('PublicExternalPublic'));
      expect(result.stdout, isNot(contains('_PrivateInternalPrivate')));
      expect(result.stdout, isNot(contains('PublicInternalPublic')));
      expect(result.stdout, isNot(contains('_PrivateInternalPrivate')));
      expect(result.stdout, isNot(contains('PublicPartInternalPartPublic')));
      expect(result.stdout, isNot(contains('_PrivatePartInternalPartPrivate')));
    });

    test('should exclude private classes', () {
      final result = runWith([
        '--exclude-private',
        'class',
        '-p',
        'test/fixtures/simple/',
      ]);
      expect(result.exitCode, 0);
      expect(result.stdout, contains('PublicExternalPublic'));
      expect(result.stdout, isNot(contains('_PrivateInternalPrivate')));
      expect(result.stdout, contains('PublicInternalPublic'));
      expect(result.stdout, isNot(contains('_PrivateInternalPrivate')));
      expect(result.stdout, contains('PublicPartInternalPartPublic'));
      expect(result.stdout, isNot(contains('_PrivatePartInternalPartPrivate')));
    });

    test('should search a subdirectory', () {
      final result = runWith([
        '-s',
        'lib/src/sub',
        '-p',
        'test/fixtures/subdir/',
      ]);
      expect(result.exitCode, 0);
      expect(result.stdout, contains('Sub'));
      expect(result.stdout, isNot(contains('NonSub')));
    });
  });
}
