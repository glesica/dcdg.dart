#!/bin/sh

dart pub get
dart run test -j 1 "$@"

