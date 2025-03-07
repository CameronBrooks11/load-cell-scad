/**
 * @file load_cell.scad
 * @brief Generates a load cell from standard sizes.
 */

include <src/load_cell_variants.scad>;
use <src/load_cell_generator.scad>;

module load_cell(load_cell_name)
{

    echo("looking for:", load_cell_name);
    matches = [for (cell = load_cell_variations) if (cell[0] == load_cell_name) cell[1]];

    if (len(matches) == 0)
        echo("No matches found for:", load_cell_name);
    else if (len(matches) > 1)
        echo("Multiple matches found for:", load_cell_name);
    else // exactly one match
        echo("Generating load cell for:", load_cell_name);

    load_cell_generator(cell_dims = matches[0][0], sensor_dims = matches[0][1], center_cutout = matches[0][2],
                        screw_holes = matches[0][3], side_cuts = matches[0][4]);
}