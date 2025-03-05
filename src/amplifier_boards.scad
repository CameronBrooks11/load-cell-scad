/** amplifier_boards.scad
 *
 * basic geometric model of common load_cell / strain_gage sensors
 * and amplifier boards.
 *
 * (c) 2021 fnh, hendrich@informatik.uni-hamburg.de
 * (c) 2025 ckb, cbrook49@uwo.ca
 */

/** hx711 amplifier board for load cells
 * @param {bool} headers - include headers for load cell connection
 * @param {number} header_pin_length - length of the header pins
 */
module generic_hx711_load_cell_amp(headers = true, header_pin_length = 8)
{
    length = 33.5;
    width = 20.5;
    height = 1.5;
    header_y = 2.54;
    header_x = 2;
    header_z = 2;

    difference()
    {
        union()
        {
            // main pcb
            color("darkgreen") translate([ 0, 0, height / 2 ]) cube([ length, width, height ], center = true);
            // hx 711 chip
            color("black") translate([ 0, 0, height + 0.5 ]) cube([ 4.5, 10.0, 1.0 ], center = true);

            if (headers)
            {
                color("black") translate([ -length / 2 + 3, 0, height + header_z / 2 ])
                    cube([ header_y, 6 * header_y, header_z ], center = true);
                color("black") translate([ length / 2 - 4.5, 0, height + header_z / 2 ])
                    cube([ header_y, 5 * header_y, header_z ], center = true);
            }
        }

        // two M3 mounting bores d=3.15
        dd = 3.15;
        translate([ length / 2 - 3.0 - dd / 2, width / 2 - 1.0 - dd / 2, -0.1 ])
            cylinder(d = dd, h = height + 0.2, center = false, $fn = 20);
        translate([ length / 2 - 3.0 - dd / 2, -width / 2 + 1.0 + dd / 2, -0.1 ])
            cylinder(d = dd, h = height + 0.2, center = false, $fn = 20);

        for (i = [ -1.5, -0.5, 0.5, 1.5 ])
        {
            dy = i * header_y;
            translate([ length / 2 - 4.5, dy, -0.2 ])
                cylinder(d = 1.0, h = height + header_z + 1, center = false, $fn = 20);
        }
        for (i = [ -2.5, -1.5, -0.5, 0.5, 1.5, 2.5 ])
        {
            dy = i * header_y;
            translate([ -length / 2 + 3.0, dy, -0.2 ])
                cylinder(d = 1.0, h = height + header_z + 1, center = false, $fn = 20);
        }
    } // difference

    if (header_pin_length > 0)
    {
        for (i = [ -1.5, -0.5, 0.5, 1.5 ])
        {
            dy = i * header_y;
            translate([ length / 2 - 4.5, dy, -0.2 ])
                cylinder(d = 0.8, h = header_pin_length, center = false, $fn = 20);
        }
        for (i = [ -2.5, -1.5, -0.5, 0.5, 1.5, 2.5 ])
        {
            dy = i * header_y;
            translate([ -length / 2 + 3.0, dy, -0.2 ])
                cylinder(d = 0.8, h = header_pin_length, center = false, $fn = 20);
        }
    }
}

/** hx711 amplifier board for load cells
 * @param {bool} headers - include headers for load cell connection
 * @param {number} header_pin_length - length of the header pins
 */
module sparkfun_hx711_load_cell_amp(headers = true, header_pin_length = 10)
{
    length = 31.2;
    width = 23.4;
    height = 1.6;
    header_y = 2.54;
    header_x = length / 2 - header_y / 2;
    header_z = 5.05;

    difference()
    {
        union()
        {
            // main pcb
            color("darkred") translate([ 0, 0, height / 2 ]) cube([ length, width, height ], center = true);
            // hx 711 chip
            color("black") translate([ 0, 0, height + 0.5 ]) cube([ 4.5, 10.0, 1.0 ], center = true);
            if (headers)
            {
                color("black") translate([ -header_x, 0, height + header_z / 2 ])
                    cube([ header_y, 5 * header_y, header_z ], center = true);
                color("black") translate([ +header_x, 0, height + header_z / 2 ])
                    cube([ header_y, 5 * header_y, header_z ], center = true);
            }
        }

        for (i = [ -2, -1, 0, 1, 2 ])
        {
            dy = i * header_y;
            translate([ -header_x, dy, -0.5 ]) cylinder(d = 1.0, h = height + header_z + 1, center = false, $fn = 20);
            translate([ +header_x, dy, -0.5 ]) cylinder(d = 1.0, h = height + header_z + 1, center = false, $fn = 20);
        }
    } // difference

    if (header_pin_length > 0)
    {
        for (i = [ -2, -1, 0, 1, 2 ])
        {
            dy = i * header_y;
            translate([ -header_x, dy, -0.2 ]) cylinder(d = 0.8, h = header_pin_length, center = false, $fn = 20);
            translate([ +header_x, dy, -0.2 ]) cylinder(d = 0.8, h = header_pin_length, center = false, $fn = 20);
        }
    }
} // sparkfun_hx711_load_cell_amp
