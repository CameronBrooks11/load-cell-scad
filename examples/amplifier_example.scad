// Example: load-cell amplifier boards.
// New NopSCADlib-style API: pass a data-row constant from amplifier_boards.scad.

include <../amplifier_boards.scad>;

spacing = 25;

amplifier_board(AMP_HX711_generic);
translate([ 0, spacing, 0 ]) amplifier_board(AMP_HX711_sparkfun);
