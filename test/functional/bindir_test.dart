import 'package:test/test.dart';

import 'utils.dart';

void main() {
  setUpAll(() {
    pubGetFixtures();
  });

  group('dcdg tool (bindir cases)', () {
    test('should run successfully on a project bin/ directory', () {
      final result = runWith(
        [
          '-s',
          'bin',
        ],
        'test/fixtures/bindir/',
      );
      expect(result.stderr, '');
      expect(result.exitCode, 0);
    });
  });
}
