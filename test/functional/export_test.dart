import 'package:test/test.dart';

import 'utils.dart';

void main() {
  pubGetFixtures();

  group('dcdg tool (export cases)', () {
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

    test('should handle show and hide exports', () {
      final result = runWith([
        '--exported-only',
        '-p',
        'test/fixtures/exports/',
      ]);
      expect(result.exitCode, 0);
      expect(result.stdout, contains('PathExportedClass'));
      expect(result.stdout, isNot(contains('PathHiddenClass')));
      expect(result.stdout, isNot(contains('PathOtherClass')));
      expect(result.stdout, contains('UriExportedClass'));
      expect(result.stdout, isNot(contains('UriHiddenClass')));
      expect(result.stdout, isNot(contains('UriOtherClass')));
      expect(result.stdout, contains('Foo'));
      expect(result.stdout, isNot(contains('FooBar')));
    });
  });
}
