# load-cell-scad

Library for modeling various load cells and strain gauges in OpenSCAD.

## Overview

This project offers a set of parametric models to generate different load cell configurations and HX711 amplifier boards. It defines multiple load cell variants with adjustable dimensions, sensor placements, cutouts, and screw hole patterns, allowing you to customize and extend the designs for your applications.

## Directory Structure

- examples – OpenSCAD example files demonstrating amplifier boards and load cell models.
- src – Source files containing the core OpenSCAD modules:
  - amplifier_boards.scad – Models for various amplifier boards.
  - load_cell.scad – Main module for generating load cells by name.
  - load_cell_generator.scad – Module that builds load cells based on provided parameters.
  - load_cell_variants.scad – Parameter definitions for different load cell variants.
  - archive – Older reference models for load cells.

## Usage

To use the library, include the source files in your OpenSCAD project. Call the load cell module (from load_cell.scad) with the desired variant name (e.g., "TAL220", "TAL221", "komputer_10kg") to generate a model. Use the amplifier board modules in amplifier_boards.scad to add HX711-based boards. Examples in the examples folder demonstrate practical usage.

## Customization

Modify the parameters in load_cell_variants.scad to adjust cell dimensions, sensor sizes, cutouts, and mounting features. The modular design makes it easy to extend the library with new variants or adapt existing ones to your needs.

## License

Licensed under the GNU Public License v3. See the LICENSE file for detailed licensing information.
