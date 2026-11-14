// Every load cell in the library, side by side.
// It draws each row of the load_cells list, so a row added there appears here too.

include <../load_cells.scad>;

spacing = 25;

for (i = [0:len(load_cells) - 1]) translate([0, i * spacing, 0]) load_cell(load_cells[i]);
