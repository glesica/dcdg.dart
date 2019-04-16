import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/overlay_file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:dcdg/src/class_element_collector.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('ClassElementCollector', () {
    final provider =
        new OverlayResourceProvider(PhysicalResourceProvider.INSTANCE)
          ..setOverlay(
            makePath('lib/exported.dart'),
            content: [
              'export "src/exported.dart" show Baz;',
              'export "src/unexported.dart" hide Bar;',
              'class Foo {}',
            ].join('\n'),
            modificationStamp: 0,
          )
          ..setOverlay(
            makePath('lib/src/unexported.dart'),
            content: 'class Bar {}',
            modificationStamp: 0,
          )
          ..setOverlay(
            makePath('lib/src/exported.dart'),
            content: 'class Baz {}',
            modificationStamp: 0,
          );
    final collection = new AnalysisContextCollection(
      includedPaths: [
        makePath('lib/'),
        makePath('lib/src/'),
      ],
      resourceProvider: provider,
    );

    Future<void> collectFrom(
      String name,
      ClassElementCollector collector,
    ) async {
      final filePath = makePath(name);
      final context = collection.contextFor(filePath);
      final unitResult = await context.currentSession.getResolvedUnit(filePath);
      unitResult.libraryElement.accept(collector);
    }

    test('should find classes in an exported library', () async {
      final collector = new ClassElementCollector();
      await collectFrom('lib/exported.dart', collector);

      expect(collector.classElements, hasLength(2));
      expect(collector.classElements.map((e) => e.name), contains('Foo'));
      expect(collector.classElements.map((e) => e.name), contains('Bar'));
      expect(collector.classElements.map((e) => e.name), contains('Baz'));
    });

    // TODO: This thing should probably just be able to tell if a library is exported

    test('should find classes in an unexported library', () async {
      final collector = new ClassElementCollector();
      await collectFrom('lib/src/unexported.dart', collector);

      expect(collector.classElements.map((e) => e.name), contains('Bar'));
    });

    test('should find only exported classes', () async {
      final collector = new ClassElementCollector(exportedOnly: true);
      await collectFrom('lib/exported.dart', collector);
      await collectFrom('lib/src/unexported.dart', collector);

      expect(collector.classElements, hasLength(1));
      expect(collector.classElements.map((e) => e.name), contains('Foo'));
    });
  });
}

String makePath(String inPath) => path.normalize(path.absolute(inPath));
