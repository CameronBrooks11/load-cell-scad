/** amplifier_boards.scad
 *
 * basic geometric model of common load_cell / strain_gage sensors
 * and amplifier boards.
 *
 * (c) 2021 fnh, hendrich@informatik.uni-hamburg.de
 * (c) 2025 ckb, cbrook49@uwo.ca
 */

module generic_hx711_load_cell_amp(headers = true, header_pin_length = 8)
{
    l = 33.5;
    w = 20.5;
    h = 1.5;
    xh = 2;
    zh = 2;
    difference()
    {
        union()
        {
            // main pcb
            color("darkgreen") translate([ 0, 0, h / 2 ]) cube([ l, w, h ], center = true);
            // hx 711 chip
            color("black") translate([ 0, 0, h + 0.5 ]) cube([ 4.5, 10.0, 1.0 ], center = true);

            if (headers)
            {
                color("black") translate([ -l / 2 + 3, 0, h + zh / 2 ]) cube([ 2.54, 6 * 2.54, zh ], center = true);
                color("black") translate([ l / 2 - 4.5, 0, h + zh / 2 ]) cube([ 2.54, 5 * 2.54, zh ], center = true);
            }
        }

        // two M3 mounting bores d=3.15
        dd = 3.15;
        translate([ l / 2 - 3.0 - dd / 2, w / 2 - 1.0 - dd / 2, -0.1 ])
            cylinder(d = dd, h = h + 0.2, center = false, $fn = 20);
        translate([ l / 2 - 3.0 - dd / 2, -w / 2 + 1.0 + dd / 2, -0.1 ])
            cylinder(d = dd, h = h + 0.2, center = false, $fn = 20);

        for (i = [ -1.5, -0.5, 0.5, 1.5 ])
        {
            dy = i * 2.54;
            translate([ l / 2 - 4.5, dy, -0.2 ]) cylinder(d = 1.0, h = h + zh + 1, center = false, $fn = 20);
        }
        for (i = [ -2.5, -1.5, -0.5, 0.5, 1.5, 2.5 ])
        {
            dy = i * 2.54;
            translate([ -l / 2 + 3.0, dy, -0.2 ]) cylinder(d = 1.0, h = h + zh + 1, center = false, $fn = 20);
        }
    } // difference

    if (header_pin_length > 0)
    {
        for (i = [ -1.5, -0.5, 0.5, 1.5 ])
        {
            dy = i * 2.54;
            translate([ l / 2 - 4.5, dy, -0.2 ]) cylinder(d = 0.8, h = header_pin_length, center = false, $fn = 20);
        }
        for (i = [ -2.5, -1.5, -0.5, 0.5, 1.5, 2.5 ])
        {
            dy = i * 2.54;
            translate([ -l / 2 + 3.0, dy, -0.2 ]) cylinder(d = 0.8, h = header_pin_length, center = false, $fn = 20);
        }
    }
}

module sparkfun_hx711_load_cell_amp(headers = true, header_pin_length = 10)
{
    l = 31.2;
    w = 23.4;
    h = 1.6;
    xh = l / 2 - 2.54 / 2;
    zh = 5.05;
    difference()
    {
        union()
        {
            // main pcb
            color("darkred") translate([ 0, 0, h / 2 ]) cube([ l, w, h ], center = true);
            // hx 711 chip
            color("black") translate([ 0, 0, h + 0.5 ]) cube([ 4.5, 10.0, 1.0 ], center = true);
            if (headers)
            {
                color("black") translate([ -xh, 0, h + zh / 2 ]) cube([ 2.54, 5 * 2.54, zh ], center = true);
                color("black") translate([ +xh, 0, h + zh / 2 ]) cube([ 2.54, 5 * 2.54, zh ], center = true);
            }
        }

        for (i = [ -2, -1, 0, 1, 2 ])
        {
            dy = i * 2.54;
            translate([ -xh, dy, -0.5 ]) cylinder(d = 1.0, h = h + zh + 1, center = false, $fn = 20);
            translate([ +xh, dy, -0.5 ]) cylinder(d = 1.0, h = h + zh + 1, center = false, $fn = 20);
        }
    } // difference

    if (header_pin_length > 0)
    {
        for (i = [ -2, -1, 0, 1, 2 ])
        {
            dy = i * 2.54;
            translate([ -xh, dy, -0.2 ]) cylinder(d = 0.8, h = header_pin_length, center = false, $fn = 20);
            translate([ +xh, dy, -0.2 ]) cylinder(d = 0.8, h = header_pin_length, center = false, $fn = 20);
        }
    }
} // sparkfun_hx711_load_cell_amp
