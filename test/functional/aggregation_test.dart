import 'package:test/test.dart';

import 'utils.dart';

void main() {
  pubGetFixtures();

  group('dcdg tool (aggregation cases)', () {
    test('should include user-defined types and exclude core types', () {
      final result = runWith(
        [],
        'test/fixtures/aggregation/',
      );
      expect(result.stderr, '');
      expect(result.exitCode, 0);
      expect(result.stdout,
          contains('Bar" o-- "aggregation_fixture::aggregation.dart::Foo0'));
      expect(result.stdout,
          contains('Bar" o-- "aggregation_fixture::aggregation.dart::Foo1'));
      expect(result.stdout, isNot(contains('::integer')));
      expect(result.stdout, isNot(contains('::boolean')));
    });
  });
}
