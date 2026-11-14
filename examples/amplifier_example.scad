// Every HX711 amplifier board in the library, side by side.
// It draws each row of the amplifier_boards list, so a row added there appears here too.

include <../amplifier_boards.scad>;

spacing = 25;

for (i = [0:len(amplifier_boards) - 1]) translate([0, i * spacing, 0]) amplifier_board(amplifier_boards[i]);
