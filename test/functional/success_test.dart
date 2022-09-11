import 'package:dcdg/src/constants.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  setUpAll(() {
    pubGetFixtures();
  });

  group('dcdg tool (success cases)', () {
    test('should produce plantuml output by default', () {
      final result = runWith(
        [
          '-b',
          'plantuml',
        ],
        'test/fixtures/simple/',
      );
      expect(result.stderr, '');
      expect(result.exitCode, 0);
      expect(result.stdout, contains('PublicExternalPublic'));
      expect(result.stdout, contains('_PrivateExternalPrivate'));
      expect(result.stdout, contains('PublicInternalPublic'));
      expect(result.stdout, contains('_PrivateInternalPrivate'));
      expect(result.stdout, contains('PublicPartInternalPartPublic'));
      expect(result.stdout, contains('_PrivatePartInternalPartPrivate'));
    });

    test('should produce mermaid output', () {
      final result = runWith(
        [
          '-b',
          'mermaid',
        ],
        'test/fixtures/simple/',
      );
      expect(result.stderr, '');
      expect(result.exitCode, 0);
      expect(result.stdout, contains('PublicExternalPublic'));
      expect(result.stdout, contains('_PrivateExternalPrivate'));
      expect(result.stdout, contains('PublicInternalPublic'));
      expect(result.stdout, contains('_PrivateInternalPrivate'));
      expect(result.stdout, contains('PublicPartInternalPartPublic'));
      expect(result.stdout, contains('_PrivatePartInternalPartPrivate'));
    });

    test('should not yield empty namespaces', () {
      final result = runWith(
        [
          '-b',
          'plantuml',
        ],
        'test/fixtures/simple/',
      );
      expect(result.stderr, '');
      expect(result.exitCode, 0);
      expect(result.stdout, contains(namespaceSeparator));
      expect(result.stdout,
          isNot(contains(namespaceSeparator + namespaceSeparator)));
    });

    test('should search a subdirectory', () {
      final result = runWith(
        [
          '-b',
          'plantuml',
          '-s',
          'lib/src/sub',
        ],
        'test/fixtures/subdir/',
      );
      expect(result.stderr, '');
      expect(result.exitCode, 0);
      expect(result.stdout, contains('Sub'));
      expect(result.stdout, isNot(contains('NonSub')));
    });

    test('should follow external packages', () {
      final result = runWith(
        [],
        'test/fixtures/inheritance',
      );
      expect(result.stderr, '');
      expect(result.exitCode, 0);
      expect(result.stdout,
          matches(r'.*PublicExternalPublic <|-- .*ExternalExtends'));
    });
  });
}
