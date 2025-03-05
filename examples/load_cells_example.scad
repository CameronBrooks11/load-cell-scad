// openscad file for example of load cells

use <../src/load_cells.scad>;

spacing = 25;

translate([ 0, -spacing * 3, 0 ]) tiny_load_cell();
translate([ 0, -spacing * 2, 0 ])
    tiny_load_cell(l = 30.0, w = 8, h = 4, h2 = 5, bore_offsets = [ -12, 12 ], bore_diameters = [ 3.0, 3.0 ]);
translate([ 0, -spacing, 0 ]) tiny_load_cell(l = 40.0, w = 8, h = 4, h2 = 5, waistbelt = [ 18, 15, 8 ]);

translate([ 0, 0, 0 ]) load_cell_TAL221();
translate([ 0, spacing, 0 ]) load_cell_TAL220B();
translate([ 0, spacing * 2, 0 ]) load_cell_TAL220();
translate([ 0, spacing * 3, 0 ]) load_cell_komputer_10kg();
translate([ 0, spacing * 4, 0 ]) load_cell_komputer_5kg();