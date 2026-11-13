// load_cells.scad: bar load cells, one row each, for load_cell().
//
// include this file to get the LC_* rows and the load_cells list; it uses
// load_cell.scad for the accessors and the drawing. The row format is at the
// top of load_cell.scad. Sizes in mm; the bar is centred on the origin.

//                   name              size                  gauge          bores                              mounting holes                                                notches
// komputer.de 10 kg: the TAL220's bar with its own hole positions; M4 both ends.
LC_komputer_10kg = ["komputer_10kg", [75.2, 12.7, 12.7], [24, 12, 1], [12.0, [4, 0], [-4, 0]], [[4, [-31.6, 0], [-21.6, 0]], [4, [21.6, 0], [31.6, 0]]], undef];

// komputer.de 5 kg: M5 at one end, M4 at the other.
LC_komputer_5kg = ["komputer_5kg", [80.2, 12.7, 12.7], [24, 12, 1], [12.0, [4, 0], [-4, 0]], [[5, [-35, 0], [-20, 0]], [4, [20, 0], [35, 0]]], undef];

// TAL220 (10 kg straight bar): M5 at one end, M4 at the other.
LC_TAL220 = ["TAL220", [80, 12.7, 12.7], [24, 12, 1], [12.0, [4, 0], [-4, 0]], [[5, [-35, 0], [-25, 0]], [4, [25, 0], [35, 0]]], undef];

// TAL220B (5 kg straight bar): one M5 hole at each end.
LC_TAL220B = ["TAL220B", [55, 12.7, 12.7], [24, 12, 1], [12.0, [4, 0], [-4, 0]], [[5, [-20, 0], [20, 0]]], undef];

// TAL221 (100 g mini bar): bores joined by a 3 mm slot, notched sides, two
// M3 holes at each end.
LC_TAL221 = ["TAL221", [47, 12, 6], [30, 6, 1], [5.3, [10, 0], [-10, 0], 3], [[3.0, [-20, -3], [-20, 3]], [3.2, [20, -3], [20, 3]]], [33, 2]];

load_cells = [LC_komputer_10kg, LC_komputer_5kg, LC_TAL220, LC_TAL220B, LC_TAL221];

use <load_cell.scad>
