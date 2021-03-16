import 'package:test/test.dart';

import 'package:dcdg/src/diagram_visitor.dart';

import 'fakes.dart';

void main() {
  group('DiagramVisitor', () {
    group('shouldInclude', () {
      group('should return true', () {
        test('when there are no excludes and no includes', () {
          final visitor = DiagramVisitor(
            onBeginClass: (_) {},
          );
          final element = FakeElement('A');
          expect(visitor.shouldInclude(element), isTrue);
        });

        test('when there are no excludes, matching includes', () {
          final visitor = DiagramVisitor(
            onBeginClass: (_) {},
            includes: [RegExp('A')],
          );
          final element = FakeElement('A');
          expect(visitor.shouldInclude(element), isTrue);
        });

        test('when there are non-matching excludes, no includes', () {
          final visitor = DiagramVisitor(
            onBeginClass: (_) {},
            excludes: [RegExp('B')],
          );
          final element = FakeElement('A');
          expect(visitor.shouldInclude(element), isTrue);
        });

        test('when there are non-matching excludes, matching includes', () {
          final visitor = DiagramVisitor(
            onBeginClass: (_) {},
            excludes: [RegExp('B')],
            includes: [RegExp('A')],
          );
          final element = FakeElement('A');
          expect(visitor.shouldInclude(element), isTrue);
        });
      });

      group('should return false', () {
        test('when there are matching excludes, no includes', () {
          final visitor = DiagramVisitor(
            onBeginClass: (_) {},
            excludes: [RegExp('A')],
          );
          final element = FakeElement('A');
          expect(visitor.shouldInclude(element), isFalse);
        });

        test('when there are matching excludes, non-matching includes', () {
          final visitor = DiagramVisitor(
            onBeginClass: (_) {},
            excludes: [RegExp('A')],
            includes: [RegExp('B')],
          );
          final element = FakeElement('A');
          expect(visitor.shouldInclude(element), isFalse);
        });

        test('when there are no excludes, non-matching includes', () {
          final visitor = DiagramVisitor(
            onBeginClass: (_) {},
            includes: [RegExp('B')],
          );
          final element = FakeElement('A');
          expect(visitor.shouldInclude(element), isFalse);
        });

        test('when there are non-matching excludes, non-matching includes', () {
          final visitor = DiagramVisitor(
            onBeginClass: (_) {},
            excludes: [RegExp('B')],
            includes: [RegExp('C')],
          );
          final element = FakeElement('A');
          expect(visitor.shouldInclude(element), isFalse);
        });
      });
    });
  });
}
