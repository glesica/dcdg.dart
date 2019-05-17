#!/bin/sh

# Generate example outputs
pub run dcdg -o example/dcdg.puml --exclude-private=field,method
plantuml example/dcdg.puml

# Add the --help contents to a text file
pub run dcdg --help > USAGE.txt

