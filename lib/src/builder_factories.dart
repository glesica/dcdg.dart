import 'package:dcdg/src/builders/dot_builder.dart';
import 'package:dcdg/src/builders/plant_uml_builder.dart';
import 'package:dcdg/src/builders/diagram_builder.dart';
import 'package:meta/meta.dart';

/// A collection of available builders parameterized in different ways
/// for different use-cases.
///
/// If you add a new builder, or would like a new option on the command
/// line to parameterize an existing builder differently, add it here.
final Map<String, BuilderFactory> _factories = {
  'plantuml': BuilderFactory(
    callback: () => PlantUmlBuilder(),
    description: 'PlantUML builder that attempts to be feature-complete',
    name: 'plantuml',
  ),
  'dot': BuilderFactory(
    callback: () => DotBuilder(),
    description: 'Graphviz builder that only handles inheritance',
    name: 'dot',
  ),
};

typedef BuilderFactoryCallback = DiagramBuilder Function();

class BuilderFactory {
  final BuilderFactoryCallback callback;

  final String description;

  final String name;

  BuilderFactory({
    @required this.callback,
    @required this.description,
    @required this.name,
  });

  @override
  String toString() => '$name - $description';
}

Iterable<BuilderFactory> availableBuilders() => _factories.values;

DiagramBuilder getBuilder(String name) => _factories[name]?.callback();
