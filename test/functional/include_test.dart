import 'package:test/test.dart';

import 'utils.dart';

void main() {
  setUpAll(() {
    pubGetFixtures();
  });

  group('dcdg tool (include cases)', () {
    test('should limit to included classes', () {
      final result = runWith(
        [
          '-i',
          'PublicInternalPublic',
        ],
        'test/fixtures/simple/',
      );
      expect(result.stderr, '');
      expect(result.exitCode, 0);
      expect(result.stdout, isNot(contains('PublicExternalPublic')));
      expect(result.stdout, isNot(contains('_PrivateExternalPrivate')));
      expect(result.stdout, contains('PublicInternalPublic'));
      expect(result.stdout, isNot(contains('_PrivateInternalPrivate')));
      expect(result.stdout, isNot(contains('PublicPartInternalPartPublic')));
      expect(result.stdout, isNot(contains('_PrivatePartInternalPartPrivate')));
    });

    test('should limit to included classes based on a regex', () {
      final result = runWith(
        [
          '-i',
          '.*Internal.*',
        ],
        'test/fixtures/simple/',
      );
      expect(result.stderr, '');
      expect(result.exitCode, 0);
      expect(result.stdout, isNot(contains('PublicExternalPublic')));
      expect(result.stdout, isNot(contains('_PrivateExternalPrivate')));
      expect(result.stdout, contains('PublicInternalPublic'));
      expect(result.stdout, contains('_PrivateInternalPrivate'));
      expect(result.stdout, contains('PublicPartInternalPartPublic'));
      expect(result.stdout, contains('_PrivatePartInternalPartPrivate'));
    });
  });
}
