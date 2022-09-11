#!/bin/sh

docker run --rm -v "$PWD":/code -w /code google/dart:2.14 ./tool/check.sh "$@"
