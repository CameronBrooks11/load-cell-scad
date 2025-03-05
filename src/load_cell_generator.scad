/**
 * @file load_cell_generator.scad
 * @brief Generates a load cell with strain gages and cable routing.
 */

/**
 * Generates a load cell with strain gages and cable routing.
 *
 * @param {number} cell_dims[1] - Width of the load cell.
 * @param {number} cell_dims[0] - Length of the load cell.
 * @param {number} cell_dims[2] - Height of the load cell.
 * @param {number[]} sensor_dims - Dimensions of the strain gages.
 * @param {string} [load_cell_color="silver"] - Color of the load cell.
 * @param {string} [sensor_color="white"] - Color of the strain gages.
 */
module load_cell_generator(cell_dims, sensor_dims, center_cutout, screw_holes, side_cuts = undef,
                           load_cell_color = "silver", sensor_color = "white")
{
    difference()
    {
        union()
        {
            // main body
            color(load_cell_color) cube([ cell_dims[0], cell_dims[1], cell_dims[2] ], center = true);

            // strain gages
            color(
                sensor_color) for (dz =
                                       [
                                           -cell_dims[2] / 2 - sensor_dims[2] / 2, cell_dims[2] / 2 + sensor_dims[2] / 2
                                       ]) translate([ 0, 0, dz ])
                cube([ sensor_dims[0], sensor_dims[1], sensor_dims[2] ], center = true);

            // cable routing on one side
            // color(sensor_color) translate([ 7 + 10, cell_dims[1] / 2, 0 ]) cube([ 14, 1, cell_dims[2] ], center =
            // true);
        }

        // optional side cutouts
        if (!is_undef(side_cuts[0]))
        {
            for (dy = [ -cell_dims[1] / 2, cell_dims[1] / 2 ])
                hull()
                {
                    translate([ -side_cuts[0] / 2 + 2, dy, 0 ])
                        cylinder(d = side_cuts[1] * 2, h = cell_dims[2] + 1, center = true, $fn = 15);
                    translate([ +side_cuts[0] / 2 - 2, dy, 0 ])
                        cylinder(d = side_cuts[1] * 2, h = cell_dims[2] + 1, center = true, $fn = 15);
                }
        }

        // center cylindrical cutouts
        for (dx = [ center_cutout[1][0], center_cutout[2][0] ])
            translate([ dx, 0, 0 ]) rotate([ 90, 0, 0 ])
                cylinder(d = center_cutout[0], h = cell_dims[1] + 1, center = true, $fn = 50);

        // optional rectangular center cutout
        if (!is_undef(center_cutout[3]))
            cube([ abs(center_cutout[2][0]) + abs(center_cutout[1][0]), cell_dims[0] + 1, center_cutout[3] ],
                 center = true);

        // screw holes
        for (i = [0:len(screw_holes) - 1])
        {
            hole = screw_holes[i];
            translate([ hole[1][0], hole[1][1], 0 ])
                cylinder(d = hole[0], h = 1 + cell_dims[1] + 1, center = true, $fn = 50);
            translate([ hole[2][0], hole[2][1], 0 ])
                cylinder(d = hole[0], h = 1 + cell_dims[1] + 1, center = true, $fn = 50);
        }
    }
}

// test values, follows TAL220
test_cell_length = 80;
test_cell_width = 12.7;
test_cell_height = 12.7;

test_cell_dims = [ test_cell_length, test_cell_width, test_cell_height ];

test_sensor_length = 24;
test_sensor_width = 12;
test_sensor_height = 1;
test_sensor_dims = [ test_sensor_length, test_sensor_width, test_sensor_height ];

test_hole_1_diameter = 5.0;
test_hole_1_location_A = [ -35, 0 ];
test_hole_1_location_B = [ -25, 0 ];

test_hole_2_diameter = 4.0;
test_hole_2_location_A = [ 25, 0 ];
test_hole_2_location_B = [ 35, 0 ];

test_screw_holes = [[test_hole_1_diameter, test_hole_1_location_A, test_hole_1_location_B],
                    [test_hole_2_diameter, test_hole_2_location_A, test_hole_2_location_B]];

test_center_cutout_diameter = 12.0;
test_center_cutout_location_A = [ 4, 0 ];
test_center_cutout_location_B = [ -4, 0 ];

test_center_cutout = [ test_center_cutout_diameter, test_center_cutout_location_A, test_center_cutout_location_B ];

center_cutout = [];

load_cell_generator(cell_dims = test_cell_dims, sensor_dims = test_sensor_dims, center_cutout = test_center_cutout,
                    screw_holes = test_screw_holes);