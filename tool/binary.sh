#!/bin/sh

set -e

mkdir -p build/
PLATFORM=$(uname -s | tr '[:upper:]' '[:lower:]')
dart2native -o "build/dcdg-$PLATFORM" bin/dcdg.dart
