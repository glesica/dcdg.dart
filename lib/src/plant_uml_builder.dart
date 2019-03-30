import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:dartagram/src/constants.dart';
import 'package:dartagram/src/uml_builder.dart';

class PlantUmlBuilder extends RecursiveElementVisitor<void>
    implements UmlBuilder {
  final Set<String> _classesSeen = {};

  final List<String> _lines = [];

  @override
  Iterable<String> get lines => _lines;

  void addBlank() {
    _lines.add('');
  }

  void addClass(ClassElement element) {
    final fullClassName = getFullTypeName(element);

    if (_classesSeen.contains(fullClassName)) {
      return;
    }

    final decl = element.isAbstract ? 'abstract class' : 'class';

    _lines.add('$decl $fullClassName {');
    _classesSeen.add(fullClassName);
  }

  void addField(FieldElement element) {
    final visibilityPrefix = getVisibility(element);
    final staticPrefix = element.isStatic ? '{static} ' : '';
    final name = element.name;
    final type = element.type.name;
    _lines.add('  $staticPrefix$visibilityPrefix$type $name');
  }

  void addInterfaces(ClassElement element) {
    if (element.interfaces.isEmpty) {
      return;
    }

    for (final interface in element.interfaces) {
      final interfaceElement = interface.element;

      final fullClassName = getFullTypeName(element);
      final fullInterfaceClassName = getFullTypeName(interfaceElement);

      _lines.add('$fullInterfaceClassName <|-- $fullClassName');
    }
  }

  void addMethod(MethodElement element) {
    final visibilityPrefix = getVisibility(element);
    final staticPrefix = element.isStatic ? '{static} ' : '';
    final name = element.name;
    final type = element.type.name;
    _lines.add('  $staticPrefix$visibilityPrefix$type $name()');
  }

  void addMixins(ClassElement element) {
    if (element.mixins.isEmpty) {
      return;
    }

    for (final mixin in element.mixins) {
      final mixinElement = mixin.element;

      final fullClassName = getFullTypeName(element);
      final fullInterfaceClassName = getFullTypeName(mixinElement);

      _lines.add('$fullInterfaceClassName <|-- $fullClassName');
    }
  }

  void addSuper(ClassElement element) {
    final superElement = element.supertype.element;

    if (superElement.name == 'Object') {
      return;
    }

    final fullClassName = getFullTypeName(element);
    final fullSuperClassName = getFullTypeName(superElement);

    _lines.add('$fullSuperClassName <|-- $fullClassName');
  }

  String getFullTypeName(Element element) {
    final namespace = element.library.identifier
        .replaceFirst('package:', '')
        .replaceFirst('dart:', 'dart::')
        .split('/')
        .join(namespaceSeparator);
    final className = element.name;
    return '$namespace$namespaceSeparator$className';
  }

  String getVisibility(Element element) {
    return element.isPrivate ? '-' : element.hasProtected ? '#' : '+';
  }

  void hasA(Element container, Element contained) {
    if (contained.library.identifier.startsWith('dart:core')) {
      return;
    }

    final containerFullName = getFullTypeName(container);
    final containedFullName = getFullTypeName(contained);

    _lines.add('$containerFullName *- $containedFullName');
  }

  @override
  void visitClassElement(ClassElement element) {
    addBlank();
    addClass(element);

    for (final field in element.fields) {
      addField(field);
    }

    for (final method in element.methods) {
      if (method.isPrivate || method.hasProtected) {
        continue;
      }
      addMethod(method);
    }

    _lines.add('}');
    addBlank();

    addSuper(element);
    addInterfaces(element);
    addMixins(element);

    for (final field in element.fields) {
      hasA(element, field.type.element);
    }
  }
}
