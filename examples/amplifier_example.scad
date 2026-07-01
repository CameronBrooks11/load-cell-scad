// Example: amplifier boards.

include <../amplifier_boards.scad>;

spacing = 25;

amplifier_board(AMP_HX711_generic);
translate([ 0, spacing, 0 ]) amplifier_board(AMP_HX711_sparkfun);
