// modules and vars specific to this project
use <MCAD/boxes.scad>
use <MCAD/nuts_and_bolts.scad>
use <MCAD/regular_shapes.scad>
include <BOSL2/std.scad>;
include <BOSL2/joiners.scad>
include <BOSL2/walls.scad>
use <BOSL2/shapes3d.scad>;
use <BOSL2/transforms.scad>;
include <MCAD/units.scad>
include <helpers.scad>

$slop = clearance_tight;

arm_slide_len = 24;
arm_slide_slope = 2;
arm_slide_width = 20;
arm_dovetail_height = 6;
