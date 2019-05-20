import 'package:analyzer/dart/element/element.dart';
import 'package:dcdg/src/diagram_visitor.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group('DiagramVisitor', () {
    group('shouldInclude', () {
      group('should return true', () {
        test('when there are no excludes and no includes', () {
          final visitor = DiagramVisitor(
            onBeginClass: (_) {},
          );
          final element = MockElement('A');
          expect(visitor.shouldInclude(element), isTrue);
        });

        test('when there are no excludes, matching includes', () {
          final visitor = DiagramVisitor(
            onBeginClass: (_) {},
            includes: [RegExp('A')],
          );
          final element = MockElement('A');
          expect(visitor.shouldInclude(element), isTrue);
        });

        test('when there are non-matching excludes, no includes', () {
          final visitor = DiagramVisitor(
            onBeginClass: (_) {},
            excludes: [RegExp('B')],
          );
          final element = MockElement('A');
          expect(visitor.shouldInclude(element), isTrue);
        });

        test('when there are non-matching excludes, matching includes', () {
          final visitor = DiagramVisitor(
            onBeginClass: (_) {},
            excludes: [RegExp('B')],
            includes: [RegExp('A')],
          );
          final element = MockElement('A');
          expect(visitor.shouldInclude(element), isTrue);
        });
      });

      group('should return false', () {
        test('when there are matching excludes, no includes', () {
          final visitor = DiagramVisitor(
            onBeginClass: (_) {},
            excludes: [RegExp('A')],
          );
          final element = MockElement('A');
          expect(visitor.shouldInclude(element), isFalse);
        });

        test('when there are matching excludes, non-matching includes', () {
          final visitor = DiagramVisitor(
            onBeginClass: (_) {},
            excludes: [RegExp('A')],
            includes: [RegExp('B')],
          );
          final element = MockElement('A');
          expect(visitor.shouldInclude(element), isFalse);
        });

        test('when there are no excludes, non-matching includes', () {
          final visitor = DiagramVisitor(
            onBeginClass: (_) {},
            includes: [RegExp('B')],
          );
          final element = MockElement('A');
          expect(visitor.shouldInclude(element), isFalse);
        });

        test('when there are non-matching excludes, non-matching includes', () {
          final visitor = DiagramVisitor(
            onBeginClass: (_) {},
            excludes: [RegExp('B')],
            includes: [RegExp('C')],
          );
          final element = MockElement('A');
          expect(visitor.shouldInclude(element), isFalse);
        });
      });
    });
  });
}

class MockElement extends Mock implements Element {
  final String _name;

  MockElement(this._name);

  @override
  String get name => _name;
}
