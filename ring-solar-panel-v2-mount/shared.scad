// modules and vars specific to this project
use <MCAD/boxes.scad>
use <MCAD/nuts_and_bolts.scad>
use <MCAD/regular_shapes.scad>
include <MCAD/units.scad>
include <helpers.scad>

include <../__vendor__/bosl2/std.scad>
include <../__vendor__/bosl2/joiners.scad>
$slop = clearance_tight;


base_x=20;
base_y=base_x + 38.7 * 2;
base_z=3.6;

base_dim = [base_x, base_y, base_z];

solar_panel_post_x = 6.8;
solar_panel_post_z = 56;
solar_panel_post_y = base_x;

solar_panel_base_x = 36 - 2 * clearance_loose;
solar_panel_base_y = 37.6;
solar_panel_base_z = 2 - clearance_tight;

solar_panel_screw_dia = 3 + 2 * clearance_loose;
solar_panel_screw_rad = solar_panel_screw_dia / 2;

panel_y = (6 + 5/8) * inch;

h_arm_y = solar_panel_post_y;
h_tran_1 = 65 - 5 - h_arm_y;
h_tran_2 = panel_y - 65 + 5;

echo("h_tran_1", h_tran_1);
echo("h_tran_2", h_tran_2);
h_hole_dy = h_tran_2 - h_tran_1;
echo("h_hole_dy", h_hole_dy);

hirth_teeth = 24;