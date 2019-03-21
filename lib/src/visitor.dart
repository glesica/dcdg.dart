import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:dartagram/src/constants.dart';

class PlantUmlVisitor extends RecursiveElementVisitor {
  final Set<String> _classesSeen = {};

  final List<String> _lines = [];

  Iterable<String> get lines => _lines;

  void addBlank() {
    _lines.add('');
  }

  void addClass(ClassElement element) {
    final fullClassName = getFullClassName(element);

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

      final fullClassName = getFullClassName(element);
      final fullInterfaceClassName = getFullClassName(interfaceElement);

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

      final fullClassName = getFullClassName(element);
      final fullInterfaceClassName = getFullClassName(mixinElement);

      _lines.add('$fullInterfaceClassName <|-- $fullClassName');
    }
  }

  void addSuper(ClassElement element) {
    final superElement = element.supertype.element;

    if (superElement.name == 'Object') {
      return;
    }

    final fullClassName = getFullClassName(element);
    final fullSuperClassName = getFullClassName(superElement);

    _lines.add('$fullSuperClassName <|-- $fullClassName');
  }

  String getFullClassName(ClassElement element) {
    final namespace = element.library.identifier
        .replaceFirst('package:', '')
        .split('/')
        .join(namespaceSeparator);
    final className = element.name;
    return '$namespace$namespaceSeparator$className';
  }

  String getVisibility(Element element) {
    return element.isPrivate ? '-' : element.hasProtected ? '#' : '+';
  }

  void hasA(ClassElement container, ClassElement contained) {
    if (contained.library.identifier.startsWith('dart:core')) {
      return;
    }

    final containerFullName = getFullClassName(container);
    final containedFullName = getFullClassName(contained);

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
