# load-cell-scad

Library for modeling various load cells and strain gauges in OpenSCAD.

## Overview

This project offers a set of parametric models for common load cells and HX711-style
amplifier boards. It follows the [NopSCADlib](https://github.com/nophead/NopSCADlib)
"vitamin" convention: each component is a pair of files — a plural **data** file
listing the variants, and a singular **module** file with the accessors and drawing
module. Draw a part by passing one of the named data rows to its module.

## Directory Structure

Four library files at the repository root:

- `load_cells.scad` – data table of load-cell variants (`LC_TAL220`, `LC_TAL221`, …).
- `load_cell.scad` – accessors and the `load_cell(type)` drawing module.
- `amplifier_boards.scad` – data table of amplifier boards (`AMP_HX711_generic`, `AMP_HX711_sparkfun`).
- `amplifier_board.scad` – accessors and the `amplifier_board(type)` drawing module.

Plus:

- `examples/` – example files demonstrating the load cells and amplifier boards.
- `archive/` – the original per-variant reference models.

The data files `use` their matching module file, so a consumer only needs to
`include` the plural (data) file.

## Usage

Include the data file and pass a variant constant to the module:

```openscad
include <load_cells.scad>;
load_cell(LC_TAL220);

include <amplifier_boards.scad>;
amplifier_board(AMP_HX711_generic);
```

Use `include` (not `use`) so the variant constants (`LC_*`, `AMP_*`) and the
`load_cells` / `amplifier_boards` lists come into scope. Iterate over a whole list:

```openscad
include <load_cells.scad>;
for (i = [0:len(load_cells) - 1])
    translate([0, i * 25, 0]) load_cell(load_cells[i]);
```

Available load cells: `LC_TAL220`, `LC_TAL220B`, `LC_TAL221`, `LC_komputer_10kg`,
`LC_komputer_5kg`. Available amplifier boards: `AMP_HX711_generic`,
`AMP_HX711_sparkfun`.

## Customization

Add or edit variants by editing the data rows in `load_cells.scad` or
`amplifier_boards.scad` — see the row-format comment at the top of each file. Field
values are read through the accessor functions (`lc_*`, `amp_*`) defined in the
matching module file, so the geometry picks up changes automatically.

## License

Licensed under the GNU Public License v3. See the LICENSE file for detailed licensing information.
