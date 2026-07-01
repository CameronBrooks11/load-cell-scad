// Example: all load-cell variants laid out along y.
// New NopSCADlib-style API: pass a data-row constant from load_cells.scad.

include <../load_cells.scad>;

spacing = 25;

translate([ 0, spacing * 0, 0 ]) load_cell(LC_TAL221);
translate([ 0, spacing * 1, 0 ]) load_cell(LC_TAL220B);
translate([ 0, spacing * 2, 0 ]) load_cell(LC_TAL220);
translate([ 0, spacing * 3, 0 ]) load_cell(LC_komputer_10kg);
translate([ 0, spacing * 4, 0 ]) load_cell(LC_komputer_5kg);
