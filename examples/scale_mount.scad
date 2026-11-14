// A single-bar scale: a base and a platform, each bolted to one end of the load cell.
// Each has a spacer under its end of the bar, so the middle of the bar, where the gauges are,
// is free to bend. The screw holes come from the cell's row, so another cell needs no new numbers.

include <../load_cells.scad>

/* [Scale] */
// Load cell, by its row name
cell = "TAL220"; // [TAL220, TAL220B, TAL221, komputer_10kg, komputer_5kg]
// Length of the base and the platform, along the bar (mm)
plate_length = 100; // [50:5:300]
// Width of the base and the platform (mm)
plate_width = 60; // [20:5:300]
// Thickness of the base and the platform (mm)
plate_thickness = 4; // [2:0.5:10]
// Height of each spacer, the gap the bar bends into (mm)
spacer_height = 5; // [2:0.5:15]
// Clearance on each screw hole's diameter (mm)
hole_clearance = 0.4; // [0:0.1:1]

/* [View] */
// The parts laid out for printing, or put together on the cell
view = "print"; // [print, assembled]

/* [Hidden] */
$fn = 48;
type = [for (t = load_cells) if (lc_name(t) == cell) t][0];
assert(!is_undef(type), str("no load cell named ", cell));

size = lc_cell_dims(type);
gauge = lc_sensor_dims(type);
holes = [for (g = lc_screw_holes(type), p = [g[1], g[2]]) [g[0], p]];

// A spacer runs from the bar's end inward to just past its holes, and stops short of the gauges.
function spacer_from(end) = min([for (h = holes) if (sign(h[1].x) == end) abs(h[1].x) - h[0] / 2]) - 2;
assert(spacer_from(-1) > gauge.x / 2 && spacer_from(1) > gauge.x / 2,
       "the spacers would reach the gauges: this cell's holes are too close to its middle");
assert(spacer_height > gauge.z + 1, str("spacer_height must leave the gauges at least 1 mm: more than ", gauge.z + 1));
assert(plate_length >= size.x, str("plate_length must be at least the bar's length, ", size.x));
assert(plate_width >= size.y, str("plate_width must be at least the bar's width, ", size.y));

// One part, drawn plate down from z = 0: the plate, and on it the spacer under the bar's `end`
// (-1 or +1 along x), with clearance holes for that end's screws.
module part(end) {
  inner = spacer_from(end);
  difference() {
    union() {
      translate([-plate_length / 2, -plate_width / 2, 0]) cube([plate_length, plate_width, plate_thickness]);
      translate([end > 0 ? inner : -size.x / 2, -size.y / 2, plate_thickness])
        cube([size.x / 2 - inner, size.y, spacer_height]);
    }
    for (h = holes) if (sign(h[1].x) == end)
      translate([h[1].x, h[1].y, -1]) cylinder(d = h[0] + hole_clearance, h = plate_thickness + spacer_height + 2);
  }
}

if (view == "print") {
  translate([0, -plate_width / 2 - 5, 0]) part(-1);
  translate([0, plate_width / 2 + 5, 0]) part(1);
} else if (view == "assembled") {
  load_cell(type);
  // The base, under the bar, holding its -x end.
  translate([0, 0, -size.z / 2 - spacer_height - plate_thickness]) part(-1);
  // The platform, over the bar, holding its +x end.
  translate([0, 0, size.z / 2 + spacer_height + plate_thickness]) mirror([0, 0, 1]) part(1);
}
