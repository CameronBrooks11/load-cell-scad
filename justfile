# Render every load cell and board and check holes, bores and fit
test:
    python3 tests/test_parts.py

# Render the README pictures into images/
images:
    mkdir -p images
    openscad --render --imgsize 1200,800 --viewall --autocenter --colorscheme Tomorrow --camera 0,0,0,55,0,30,0 -o images/load_cells.png examples/load_cells_example.scad
    openscad --render --imgsize 1000,700 --viewall --autocenter --colorscheme Tomorrow --camera 0,0,0,45,0,30,0 -o images/amplifier_boards.png examples/amplifier_example.scad
    openscad --render --imgsize 1000,300 --colorscheme Tomorrow --projection=ortho --camera 0,0,0,90,0,0,55 -o images/tal221_side.png examples/tal221_side.scad
