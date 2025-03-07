// openscad file for example of load cells

use <../load_cell.scad>;

spacing = 25;

translate([ 0, 0, 0 ]) load_cell("TAL221");
translate([ 0, spacing, 0 ]) load_cell("TAL220B");
translate([ 0, spacing * 2, 0 ]) load_cell("TAL220");
translate([ 0, spacing * 3, 0 ]) load_cell("komputer_10kg");
translate([ 0, spacing * 4, 0 ]) load_cell("komputer_5kg");