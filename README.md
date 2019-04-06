[![Build Status](https://travis-ci.org/glesica/dcdg.dart.svg?branch=master)](https://travis-ci.org/glesica/dcdg.dart)

# Dart Class Diagram Generator

A small command line utility to generate a class (UML or similar) diagram from a Dart package.

## Examples

Below is a UML diagram created with dcdg. You can find the PlantUML source in the `example/`
directory.

![Example UML Diagram](example/dcdg.png)

## Installation

**Install from pub:**

`pub global activate dcdg`

**Install from clone:**

`pub global activate -s path .`

## Usage

From inside a Dart package repository:

`pub global run dcdg`

This will dump a PlantUML file to stdout. You can save it to a file instead with the `-o` option.

See `--help` for more options, including ways to filter what ends up in the output.

## Contributing

Pull requests are welcome! It is intended to be reasonably straightforward to add a new output
format. Take a look at the DOT format implementation in `lib/src/builders` for an example.

If you have found a bug or have a feature request please open an issue.

