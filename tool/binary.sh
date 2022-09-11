#!/bin/sh

set -e

mkdir -p build/
PLATFORM=$(uname -s | tr '[:upper:]' '[:lower:]')
dart pub get
dart compile exe -o "build/dcdg-$PLATFORM" bin/dcdg.dart
