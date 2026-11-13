// Checks on one part, chosen by CHECK, for row INDEX of its list:
//   "cell":    load cell INDEX
//   "holes":   load cell INDEX against a pin GROW over each mounting hole,
//              through the bar along z
//   "bores":   load cell INDEX against a pin GROW over each bore, through the
//              bar along y
//   "slot":    load cell INDEX against a block GROW over its bore slot
//   "notches": load cell INDEX against a pin GROW over each side notch's
//              middle, through the bar along z
//   "board":   amplifier board INDEX
//   "pins":    amplifier board INDEX, without its pins, against its pins
//   "mounts":  amplifier board INDEX against a pin GROW over each mounting hole
//   "rows":    nothing; echoes every row
include <../load_cells.scad>
include <../amplifier_boards.scad>

CHECK = "cell";
INDEX = 0;
GROW = 0;

lc = load_cells[INDEX];
amp = amplifier_boards[min(INDEX, len(amplifier_boards) - 1)];

if (CHECK == "cell") load_cell(lc);
else if (CHECK == "holes")
  intersection() {
    load_cell(lc);
    for (g = lc_screw_holes(lc), p = [g[1], g[2]])
      translate([p.x, p.y, 0]) cylinder(d = g[0] + GROW, h = 100, center = true, $fn = 50);
  }
else if (CHECK == "bores")
  intersection() {
    load_cell(lc);
    b = lc_center_cutout(lc);
    for (p = [b[1], b[2]]) translate([p.x, 0, 0]) rotate([90, 0, 0]) cylinder(d = b[0] + GROW, h = 100, center = true, $fn = 50);
  }
else if (CHECK == "slot")
  intersection() {
    load_cell(lc);
    b = lc_center_cutout(lc);
    translate([(b[1].x + b[2].x) / 2, 0, 0]) cube([abs(b[1].x - b[2].x), 100, b[3] + GROW], center = true);
  }
else if (CHECK == "notches")
  intersection() {
    load_cell(lc);
    n = lc_side_cuts(lc);
    for (y = [-1, 1]) translate([0, y * lc_cell_dims(lc).y / 2, 0]) cylinder(r = n[1] + GROW, h = 100, center = true, $fn = 50);
  }
else if (CHECK == "board") amplifier_board(amp);
else if (CHECK == "pins")
  intersection() {
    amplifier_board(amp, header_pin_length = 0);
    for (c = amp_headers(amp), y = amp_pin_ys(c[1])) translate([c[0], y, -0.2]) cylinder(d = 0.8, h = 8, $fn = 20); // pin_d, which use does not export
  }
else if (CHECK == "mounts")
  intersection() {
    amplifier_board(amp, header_pin_length = 0);
    for (m = amp_mount_holes(amp)) translate([m[0], m[1], -1]) cylinder(d = m[2] + GROW, h = 10, $fn = 20);
  }
else if (CHECK == "rows") {
  for (r = load_cells) echo(LC = r);
  for (r = amplifier_boards) echo(AMP = r);
}
