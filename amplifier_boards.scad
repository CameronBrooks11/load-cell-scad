// amplifier_boards.scad: load-cell amplifier boards, one row each, for
// amplifier_board().
//
// include this file to get the AMP_* rows and the amplifier_boards list; it
// uses amplifier_board.scad for the accessors and the drawing. The row format
// is at the top of amplifier_board.scad. Sizes in mm.

//                     name              pcb                  colour       chip          headers                                mounting holes
// Generic HX711 breakout: a 6-pin and a 4-pin header, two 3.15 mm holes.
AMP_HX711_generic = ["HX711 generic", [33.5, 20.5, 1.5], "darkgreen", [4.5, 10, 1], [[-13.75, 6, 2], [12.25, 4, 2]], [[12.175, 7.675, 3.15], [12.175, -7.675, 3.15]]];

// SparkFun HX711 breakout: two 5-pin headers, no mounting holes.
AMP_HX711_sparkfun = ["HX711 SparkFun", [31.2, 23.4, 1.6], "darkred", [4.5, 10, 1], [[-14.33, 5, 5.05], [14.33, 5, 5.05]], []];

amplifier_boards = [AMP_HX711_generic, AMP_HX711_sparkfun];

use <amplifier_board.scad>
