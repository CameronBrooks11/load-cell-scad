// openscad file for example of load cell amp boards

use <../src/amplifier_boards.scad>;

spacing = 25;

generic_hx711_load_cell_amp();
translate([ 0, spacing, 0 ]) sparkfun_hx711_load_cell_amp();