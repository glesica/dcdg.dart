import 'package:test/test.dart';

import 'utils.dart';

void main() {
  setUpAll(() {
    pubGetFixtures();
  });

  group('dcdg tool (nullable cases)', () {
    test('should not treat a nullable type as a separate class', () {
      final result = runWith(
        [],
        'test/fixtures/nullable/',
      );
      expect(result.stderr, '');
      expect(result.exitCode, 0);

      final goodPattern =
          RegExp(r'PublicExternalA" o-- .+PublicExternalB"$', multiLine: true);
      final badPattern = RegExp(r'PublicExternalA" o-- .+PublicExternalB\?"$',
          multiLine: true);

      expect(result.stdout, matches(goodPattern));
      expect(result.stdout, isNot(matches(badPattern)));
    });
  });
}
