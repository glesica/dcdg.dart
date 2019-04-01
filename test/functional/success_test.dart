import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('dcdg tool (success cases)', () {
    test('should produce plantuml output by default', () {
      final result = runWith(['-p', 'test/fixtures/simple/']);
      expect(result.exitCode, 0);
      expect(result.stdout, contains('ExternalClass'));
      expect(result.stdout, contains('InternalClass'));
    });

    test('should ignore excluded classes', () {
      final result = runWith([
        '-e',
        'InternalClass',
        '-p',
        'test/fixtures/simple/',
      ]);
      expect(result.exitCode, 0);
      expect(result.stdout, contains('ExternalClass'));
      expect(result.stdout, isNot(contains('InternalClass')));
    });

    test('should limit to included classes', () {
      final result = runWith([
        '-i',
        'InternalClass',
        '-p',
        'test/fixtures/simple/',
      ]);
      expect(result.exitCode, 0);
      expect(result.stdout, isNot(contains('ExternalClass')));
      expect(result.stdout, contains('InternalClass'));
    });
  });
}
