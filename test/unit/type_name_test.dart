import 'package:test/test.dart';

import 'package:dcdg/src/type_name.dart';

import 'fakes.dart';

void main() {
  group('typeName', () {
    test('should include nullability by default', () {
      final element = FakeElement('class?');
      final name = typeName(element);
      expect(name, 'class?');
    });

    test('should respect withNullability on ? type', () {
      final element = FakeElement('class?');
      final name = typeName(element, withNullability: false);
      expect(name, 'class');
    });

    test('should respect withNullability on * type', () {
      final element = FakeElement('class*');
      final name = typeName(element, withNullability: false);
      expect(name, 'class');
    });
  });
}
