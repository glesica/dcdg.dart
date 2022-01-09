import 'package:test/test.dart';

import 'utils.dart';

void main() {
  setUpAll(() {
    pubGetFixtures();
  });

  group('dcdg tool (parts cases)', () {
    test('should not duplicate classes in files with parts', () {
      final result = runWith(
        [],
        'test/fixtures/simple/',
      );
      expect(result.stderr, '');
      expect(result.exitCode, 0);

      final out = result.stdout as String;
      for (final className in const [
        'PublicInternalPublic',
        'PublicPartInternalPartPublic',
        '_PrivatePartInternalPartPrivate',
        '_PrivateInternalPrivate',
      ]) {
        final first = out.indexOf(className);
        final last = out.lastIndexOf(className);
        expect(first, isNot(-1));
        expect(first, equals(last), reason: '$className is duplicated');
      }
    });
  });
}
