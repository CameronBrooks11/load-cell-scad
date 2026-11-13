// load_cell.scad: draws a bar load cell from a row in load_cells.scad.
//
// The bar is centred on the origin with its length along x and its mounting
// holes along z. A strain gauge sits on its top and bottom faces over the
// bending section: two bores across the bar (y), joined by a slot when the
// row gives the slot's height.
//
// A row is [name, size, gauge, bores, holes, notches]:
//   size     [length, width, height] of the bar
//   gauge    [length, width, thickness] of each strain gauge
//   bores    [diameter, [x1, y1], [x2, y2]], or with a 4th value, the height
//            of the slot between them
//   holes    groups of mounting holes, each [diameter, [xA, yA], [xB, yB]]
//   notches  [length, depth] of the notches along both sides, or undef

function lc_name(type) = type[0];          // e.g. "TAL220"
function lc_cell_dims(type) = type[1];     // [length, width, height]
function lc_sensor_dims(type) = type[2];   // [length, width, thickness]
function lc_center_cutout(type) = type[3]; // [diameter, [x1, y1], [x2, y2] (, slot height)]
function lc_screw_holes(type) = type[4];   // [[diameter, [xA, yA], [xB, yB]], ...]
function lc_side_cuts(type) = type[5];     // [length, depth], or undef

module load_cell(type, load_cell_color = "silver", sensor_color = "white") {
  size = lc_cell_dims(type);
  gauge = lc_sensor_dims(type);
  bores = lc_center_cutout(type);
  holes = lc_screw_holes(type);
  notches = lc_side_cuts(type);

  difference() {
    union() {
      color(load_cell_color) cube(size, center = true);
      color(sensor_color) for (s = [-1, 1]) translate([0, 0, s * (size.z + gauge.z) / 2]) cube(gauge, center = true);
    }
    // Notches along both sides, rounded at their ends
    if (is_list(notches))
      for (y = [-size.y / 2, size.y / 2]) hull()
        for (x = [-1, 1]) translate([x * (notches[0] / 2 - 2), y, 0])
          cylinder(r = notches[1], h = size.z + 1, center = true, $fn = 15);
    // The bending section
    for (p = [bores[1], bores[2]])
      translate([p.x, 0, 0]) rotate([90, 0, 0]) cylinder(d = bores[0], h = size.y + 1, center = true, $fn = 50);
    if (len(bores) > 3)
      translate([(bores[1].x + bores[2].x) / 2, 0, 0]) cube([abs(bores[1].x - bores[2].x), size.y + 1, bores[3]], center = true);
    // Mounting holes, through the bar
    for (g = holes, p = [g[1], g[2]])
      translate([p.x, p.y, 0]) cylinder(d = g[0], h = size.z + 2, center = true, $fn = 50);
  }
}
