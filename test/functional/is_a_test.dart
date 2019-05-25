import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('dcdg tool (is-a cases)', () {
    test('should follow extends', () {
      final result = runWith(
        [
          '--is-a',
          'Extended',
        ],
        'test/fixtures/inheritance',
      );
      expect(result.stderr, '');
      expect(result.exitCode, 0);
      expect(result.stdout, contains('Extended'));
      expect(result.stdout, contains('ClassExtend'));
      expect(result.stdout, isNot(contains('MixedIn')));
      expect(result.stdout, isNot(contains('Implemented')));
    });

    test('should follow with', () {
      final result = runWith(
        [
          '--is-a',
          'MixedIn',
        ],
        'test/fixtures/inheritance',
      );
      expect(result.stderr, '');
      expect(result.exitCode, 0);
      expect(result.stdout, contains('MixedIn'));
      expect(result.stdout, contains('ClassMixIn'));
      expect(result.stdout, isNot(contains('Extended')));
      expect(result.stdout, isNot(contains('Implemented')));
    });

    test('should follow implements', () {
      final result = runWith(
        [
          '--is-a',
          'Implemented',
        ],
        'test/fixtures/inheritance',
      );
      expect(result.stderr, '');
      expect(result.exitCode, 0);
      expect(result.stdout, contains('Implemented'));
      expect(result.stdout, contains('ClassImplement'));
      expect(result.stdout, isNot(contains('Extended')));
      expect(result.stdout, isNot(contains('MixedIn')));
    });
  });
}
