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

difference() {
    roundedSquare(base_dim, corner_rad);

    for (pt=hole_ctrs) {
        translate(pt) circle_outer(base_hole_rad);
    }
}

