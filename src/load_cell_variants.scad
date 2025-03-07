// load_cell_variations.scad

// Each entry is formatted as:
// [ "name",
//   [
//     cell_dims,      // [ width, length, height ]
//     sensor_dims,    // [ sensor_width, sensor_length, sensor_thickness ]
//     center_cutout,  // [ diameter, [pos1_x, pos1_y], [pos2_x, pos2_y] ]
//     screw_holes     // A list of one or more screw groups. Each group is [ diameter, [loc A], [loc B] ]
//     side_cuts       // [ length, width ] // side cuts, optional
//   ]
// ]

load_cell_variations = [
    // komputer_10kg:
    //   cell: 75.2 x 12.7 x 12.7; sensor: 24 x 12 x 1;
    //   center_cutout: cylinder d=12.0 at (4,0) & (-4,0);
    //   screw holes (both M4): left at x = -37.6+6 = -31.6 and -37.6+16 = -21.6;
    //                 right at x = 37.6-16 = 21.6 and 37.6-6 = 31.6;
    [
        "komputer_10kg",
        [
            [ 75.2, 12.7, 12.7 ],          // cell dims
            [ 24, 12, 1 ],                 // sensor dims
            [ 12.0, [ 4, 0 ], [ -4, 0 ] ], // center cutout
            [
                [ 4, [ -31.6, 0 ], [ -21.6, 0 ] ], // left side (M4; d = 4.0)
                [ 4, [ 21.6, 0 ], [ 31.6, 0 ] ]    // right side (M4; d = 4.0)
            ],                                     // screw holes
        ]
    ],
    // komputer_5kg:
    //   cell: 80.2 x 12.7 x 12.7; sensor: 24 x 12 x 1;
    //   center_cutout: same as above.
    //   Screw holes: left (M5) at: -80.2/2+5.1 = -35 and -80.2/2+15+5.1 = -20;
    //                right (M4) at: 20 and 35.
    [
        "komputer_5kg",
        [
            [ 80.2, 12.7, 12.7 ],          // cell dims
            [ 24, 12, 1 ],                 // sensor dims
            [ 12.0, [ 4, 0 ], [ -4, 0 ] ], // center cutout
            [
                [ 5, [ -35, 0 ], [ -20, 0 ] ], // left side (M5; d = 5.0)
                [ 4, [ 20, 0 ], [ 35, 0 ] ]    // right side (M4; d = 4.0)
            ],                                 // screw holes
        ]
    ],
    // TAL220 (sparkfun 10kg):
    //   cell: 80 x 12.7 x 12.7; sensor: 24 x 12 x 1;
    //   center_cutout: cylinder d=12.0 at (4,0) & (-4,0);
    //   Screw holes: left (M5) at: -80/2+5 = -35 and -80/2+15 = -25;
    //                right (M4) at: 80/2-15 = 25 and 80/2-5 = 35.
    [
        "TAL220",
        [
            [ 80, 12.7, 12.7 ],            // cell dims
            [ 24, 12, 1 ],                 // sensor dims
            [ 12.0, [ 4, 0 ], [ -4, 0 ] ], // center cutout
            [
                [ 5, [ -35, 0 ], [ -25, 0 ] ], // left side (M5; d = 5.0)
                [ 4, [ 25, 0 ], [ 35, 0 ] ]    // right side (M4; d = 4.0)
            ],                                 // screw holes
        ]
    ],
    // TAL220B:
    //   cell: 55 x 12.7 x 12.7; sensor: 24 x 12 x 1;
    //   center_cutout: cylinder d=12.0 at (4,0) & (-4,0);
    //   Screw holes: one pair (M5) at: positions -lb/2 and lb/2 with lb=40, so -20 and 20.
    [
        "TAL220B",
        [
            [ 55, 12.7, 12.7 ],             // cell dims
            [ 24, 12, 1 ],                  // sensor dims
            [ 12.0, [ 4, 0 ], [ -4, 0 ] ],  // center cutout
            [[ 5, [ -20, 0 ], [ 20, 0 ] ]], // screw holes, single pair (M5; d = 5.0)
        ]
    ],
    // TAL221:
    //   cell: 47 x 12 x 6; sensor: 30 x 6 x 1;
    //   center_cutout: subtracted as a cube of 20 x (12+1) x 3, so we mark it specially.
    //   Screw holes:
    //     Left side: for dy in [-3,3] at x = -40/2 = -20 (with d = 3.0)
    //     Right side: for dy in [-3,3] at x = 20 (with d = 3.2)
    //   We list the left pair as [ -20, -3 ] and [ -20, 3 ],
    //   and the right pair as [ 20, -3 ] and [ 20, 3 ].
    [
        "TAL221",
        [
            [ 47, 12, 6 ], // cell dims
            [ 30, 6, 1 ],  // sensor dims
            [
                5.3, [ 10, 0 ], [ -10, 0 ], 3
            ], // center cutout; THIRD SPOT IF FILLED WILL CUT OUT BETWEEN THE TWO HOLES WITH THAT AS HEIGHT
            [
                [ 3.0, [ -20, -3 ], [ -20, 3 ] ], // left side (d = 3.0)
                [ 3.2, [ 20, -3 ], [ 20, 3 ] ]    // right side (d = 3.2)
            ],                                    // screw holes
            [ 33, 2 ]                             // side cuts
        ]
    ],
];

/*


        // tiny_load_cell:
        //   cell: 40 x 8 x 3; sensor: 20 x 8 x 1;
        //   (No center cutout subtraction is used here.)
        //   Screw bores (from bore_offsets): diam 4.1 at positions -13.5 and 13.5.
        [
            "tiny_load_cell",
            [
                [40, 8, 3],
                [20, 8, 1],
                null,  // no center cutout for tiny_load_cell
                [
                    [4.1, [-13.5, 0], [13.5, 0]]
                ]
            ]
        ]
    ];
    */

/**
 * Returns the specs for a given load cell.
 *
 * @param {string} load_cell_name - Name of the load cell.
 * @return {[cell_dims], [sensor_dims], [center_cutout], [screw_holes], [side_cuts]} - Specs for the load cell.
 */
function get_load_cell_specs(load_cell_name) =
    let(result = [for (cell = load_cell_variations) if (cell[0] == load_cell_name) cell[1]]) result[0];

/**
 * Returns the dimensions of the load cell.
 *
 * @param {string} load_cell_name - Name of the load cell.
 * @return {[ width, length, height ]} - Dimensions of the load cell.
 */
function get_load_cell_cell_dims(load_cell_name) = get_load_cell_specs(load_cell_name)[0];

/**
 * Returns the dimensions of the sensor.
 *
 * @param {string} load_cell_name - Name of the load cell.
 * @return {[ sensor_width, sensor_length, sensor_thickness ]} - Dimensions of the sensor.
 */
function get_load_cell_sensor_dims(load_cell_name) = get_load_cell_specs(load_cell_name)[1];

/**
 * Returns the dimensions of the center cutout.
 *
 * @param {string} load_cell_name - Name of the load cell.
 * @return {[ diameter, [pos1_x, pos1_y], [pos2_x, pos2_y] ]} - Dimensions of the center cutout.
 */
function get_load_cell_center_cutout(load_cell_name) = get_load_cell_specs(load_cell_name)[2];

/**
 * Returns the positions of the screw holes.
 *
 * @param {string} load_cell_name - Name of the load cell.
 * @return {[ [ diameter1, [location A1], [location B1] ], ... ]} - Positions of the screw holes.
 */
function get_load_cell_screw_holes(load_cell_name) = get_load_cell_specs(load_cell_name)[3];

/**
 * Returns the dimensions of the side cuts.
 *
 * @param {string} load_cell_name - Name of the load cell.
 * @return {[ length, width ]} - Dimensions of the optional side cuts.
 */
function get_load_cell_side_cuts(load_cell_name) = get_load_cell_specs(load_cell_name)[4];