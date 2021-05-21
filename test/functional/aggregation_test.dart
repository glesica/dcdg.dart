import 'package:test/test.dart';

import 'utils.dart';

void main() {
  setUpAll(() {
    pubGetFixtures();
  });

  group('dcdg tool (aggregation cases)', () {
    test('should include user-defined types and exclude core types in plantuml',
        () {
      final result = runWith(
        [
          '-b',
          'plantuml',
        ],
        'test/fixtures/aggregation/',
      );
      expect(result.stderr, '');
      expect(result.exitCode, 0);
      expect(result.stdout,
          contains('Bar" o-- "aggregation_fixture::aggregation.dart::Foo0'));
      expect(result.stdout,
          contains('Bar" o-- "aggregation_fixture::aggregation.dart::Foo1'));
      expect(result.stdout, isNot(contains('::int')));
      expect(result.stdout, isNot(contains('::bool')));
    });

    test('should include user-defined types and exclude core types in nomnoml',
        () {
      final result = runWith(
        [
          '-b',
          'nomnoml',
        ],
        'test/fixtures/aggregation/',
      );
      expect(result.stderr, '');
      expect(result.exitCode, 0);
      expect(result.stdout, contains('[Bar]o-[Foo0]'));
      expect(result.stdout, contains('[Bar]o-[Foo1]'));
      expect(result.stdout, isNot(contains('[int]')));
      expect(result.stdout, isNot(contains('[bool]')));
    });
  });
}
