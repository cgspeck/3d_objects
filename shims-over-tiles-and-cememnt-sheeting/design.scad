include <shared.scad>
use <MCAD/boxes.scad>

shim_dim = [
    16.4,
    50,
    26
];

shim_corner_rad = 1;

hole_dia =  5.9;

hole_d_y = 34;

// CALCS BELOW LINE
hole_rad = hole_dia / 2 + clearance_loose;

difference() {
    roundedCube(shim_dim, shim_corner_rad, sidesonly=true, center=true);
    translate([0,-hole_d_y/2,-shim_dim.z/2 - de_minimis]) cylinder_outer(shim_dim.z + 2de_minimis, hole_rad);
    translate([0,hole_d_y/2,-shim_dim.z/2 - de_minimis]) cylinder_outer(shim_dim.z + 2de_minimis, hole_rad);
}