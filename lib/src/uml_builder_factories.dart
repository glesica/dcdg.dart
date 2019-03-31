import 'package:dartagram/src/plant_uml_builder.dart';
import 'package:dartagram/src/uml_builder.dart';
import 'package:meta/meta.dart';

/// A collection of available builders parameterized in different ways
/// for different use-cases.
///
/// If you add a new builder, or would like a new option on the command
/// line that parameterizes an existing builder differently, add it here.
final Map<String, UmlBuilderFactory> _factories = {
  'plantuml': UmlBuilderFactory(
    callback: () => PlantUmlBuilder(),
    description: 'A PlantUML builder that attempts to be feature-complete',
    name: 'plantuml',
  ),
};

typedef UmlBuilder UmlBuilderFactoryCallback();

class UmlBuilderFactory {
  final UmlBuilderFactoryCallback callback;

  final String description;

  final String name;

  UmlBuilderFactory({
    @required this.callback,
    @required this.description,
    @required this.name,
  });

  @override
  String toString() => '$name - $description';
}

Iterable<String> availableBuilders() => _factories.keys;

UmlBuilder getBuilder(String name) => _factories[name]?.callback();
