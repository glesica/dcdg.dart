class Foo0 {}

class Foo1 {}

class Bar {
  Foo0 foo = Foo0();

  // ignore: unused_field
  Foo1 _foo = Foo1();

  int integer = 0;

  // ignore: unused_field
  bool _boolean = false;
}
