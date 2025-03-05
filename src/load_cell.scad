// generic load cell
module load_cell_generator(width, length, height, sensor_dims, load_cell_color = "silver", sensor_color = "white")
{

    difference()
    {
        union()
        {
            // main body
            color(load_cell_color) cube([ length, width, height ], center = true);

            // strain gages
            color(sensor_color) for (dz = [ -height / 2 - sensor_dims[2] / 2, height / 2 + sensor_dims[2] / 2 ])
                translate([ 0, 0, dz ]) cube([ sensor_dims[0], sensor_dims[1], sensor_dims[2] ], center = true);

            // cable routing on one side
            color(sensor_color) translate([ 7 + 10, width / 2, 0 ]) cube([ 14, 1, height ], center = true);
        }

        // center cylindrical cutouts
        for (dx = [ -4, 4 ])
            translate([ dx, 0, 0 ]) rotate([ 90, 0, 0 ])
                cylinder(d = 12.0, h = 20 + width + 1, center = true, $fn = 50);

        // 2 x M5 screw threads
        for (dx = [ -length / 2 + 5, -length / 2 + 15 ])
            translate([ dx, 0, 0 ]) cylinder(d = 5.0, h = height + 1, center = true, $fn = 50);

        // 2 x M4 screw threads
        for (dx = [ length / 2 - 5, length / 2 - 15 ])
            translate([ dx, 0, 0 ]) cylinder(d = 4.0, h = height + 1, center = true, $fn = 50);
    }
}

test_length = 80;
test_width = 12.7;
test_height = 12.7;
test_sensor_dims = [ 24, 12, 1 ];

load_cell_generator(width = test_width, length = test_length, height = test_height, sensor_dims = test_sensor_dims);