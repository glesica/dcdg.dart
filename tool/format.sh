#!/bin/sh

dart pub get
dart format --fix --set-exit-if-changed .
