#!/bin/sh

set -e

# Update the version number in Dart based on the pubspec
awk '/version: / {print "const version = " "'\''" $2 "'\''" ";"}' pubspec.yaml > lib/src/version.dart

# Generate example outputs
dart pub get
dart run dcdg -o example/dcdg.puml --exclude-private=field,method
plantuml example/dcdg.puml

# Add the --help contents to a text file
dart run dcdg --help > USAGE.txt
