// these shims are for posts lower down the pad where the angles 
// change slightly
include <shared.scad>
use <MCAD/2Dshapes.scad>

// pole base plate
base_xy=100;
base_hole_dx=70;
base_hole_d7=70;
base_hole_dia=11;
base_height=50;
corner_dia=15;

corner_rad=corner_dia/2;
base_dim=[base_xy,base_xy];
base_hole_rad=base_hole_dia/2;
half_base_hole_dx = base_hole_dx / 2;
hole_ctrs=[
    [-half_base_hole_dx, -half_base_hole_dx, 0],
    [-half_base_hole_dx, half_base_hole_dx, 0],
    [half_base_hole_dx, half_base_hole_dx, 0],
    [half_base_hole_dx, -half_base_hole_dx, 0],
];

// slope of the land
measured_slope=-3.6;
recrip_slope_angle=90 - abs(measured_slope);
c_angle=90 - recrip_slope_angle;
land_ob_len=200;
land_ob_height=tan(c_angle) * land_ob_len;

lang_ob_poly_pts=[
    [0,0],
    [land_ob_len,land_ob_height],
    [land_ob_len,0],
];


intersection() {
    linear_extrude(base_height) {
        difference() {
            roundedSquare(base_dim, corner_rad);

            for (pt=hole_ctrs) {
                translate(pt) circle_outer(base_hole_rad);
            }
        }
    }
    rotate([0,0,15.64]) translate([
        -land_ob_len / 2,
        land_ob_len / 2,
        0
    ]) rotate([90,0,0]) linear_extrude(land_ob_len) polygon(points=lang_ob_poly_pts);
}