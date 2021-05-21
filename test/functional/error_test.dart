import 'package:test/test.dart';

import 'utils.dart';

void main() {
  setUpAll(() {
    pubGetFixtures();
  });

  group('dcdg tool (error cases)', () {
    test('should fail if no pubspec.yaml is found', () {
      final result = runWith([], 'test/fixtures/invalid');
      expect(result.exitCode, isNot(0));
    });
  });
}
