import 'package:simple_fixture/external.dart';

abstract class Extended {}

abstract class MixedIn {}

abstract class Implemented {}

class ClassExtend extends Extended {}

class ClassMixIn with MixedIn {}

class ClassImplement implements Implemented {}

class ExternalExtends extends PublicExternalPublic {}
