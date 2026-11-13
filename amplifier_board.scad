// amplifier_board.scad: draws a load-cell amplifier board (HX711 breakout)
// from a row in amplifier_boards.scad.
//
// The board lies on z = 0, centred on the origin, with its chip in the middle
// and its 0.1 in pin headers in columns along y.
//
// A row is [name, pcb, colour, chip, headers, mount_holes]:
//   pcb          [length, width, thickness]
//   colour       solder mask colour
//   chip         [length, width, height] of the chip
//   headers      header columns, each [x, pins, block height]
//   mount_holes  mounting holes, each [x, y, diameter]

function amp_name(type) = type[0];
function amp_pcb(type) = type[1];         // [length, width, thickness]
function amp_colour(type) = type[2];
function amp_chip(type) = type[3];        // [length, width, height]
function amp_headers(type) = type[4];     // [[x, pins, block height], ...]
function amp_mount_holes(type) = type[5]; // [[x, y, diameter], ...]

pin_pitch = 2.54;
pin_hole_d = 1.0;
pin_d = 0.8;

// y of each pin in a column of n
function amp_pin_ys(n) = [for (i = [0:n - 1]) (i - (n - 1) / 2) * pin_pitch];

module amplifier_board(type, headers = true, header_pin_length = 8) {
  pcb = amp_pcb(type);
  chip = amp_chip(type);
  columns = amp_headers(type);
  t = pcb.z;

  difference() {
    union() {
      color(amp_colour(type)) translate([0, 0, t / 2]) cube(pcb, center = true);
      color("black") translate([0, 0, t + chip.z / 2]) cube(chip, center = true);
      if (headers)
        for (c = columns) color("black") translate([c[0], 0, t + c[2] / 2]) cube([pin_pitch, c[1] * pin_pitch, c[2]], center = true);
    }
    for (c = columns, y = amp_pin_ys(c[1]))
      translate([c[0], y, -0.5]) cylinder(d = pin_hole_d, h = t + c[2] + 1, $fn = 20);
    for (m = amp_mount_holes(type))
      translate([m[0], m[1], -0.1]) cylinder(d = m[2], h = t + 0.2, $fn = 20);
  }

  if (header_pin_length > 0)
    for (c = columns, y = amp_pin_ys(c[1]))
      translate([c[0], y, -0.2]) cylinder(d = pin_d, h = header_pin_length, $fn = 20);
}
