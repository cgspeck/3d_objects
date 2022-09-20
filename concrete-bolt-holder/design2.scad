include <shared.scad>

hole_dx = 176;
hole_dy = 176;
hole_dia = 10;
hole_rad = hole_dia / 2 + clearance_tight;
outer_rad = hole_rad * 2;

module HullPoint() {
    cylinder_outer(min_thickness, min_thickness/2);
}

union() {
    difference() {
        union() {
            multiHull() {
                HullPoint();
                translate([-hole_dx/2,-hole_dy/2,0]) HullPoint();
                translate([-hole_dx/2,hole_dy/2,0]) HullPoint();
                translate([hole_dx/2,hole_dy/2,0]) HullPoint();
                translate([hole_dx/2,-hole_dy/2,0]) HullPoint();
            }
            sequentialHull() {
                translate([-hole_dx/2,-hole_dy/2,0]) HullPoint();
                translate([-hole_dx/2,hole_dy/2,0]) HullPoint();
                translate([hole_dx/2,hole_dy/2,0]) HullPoint();
                translate([hole_dx/2,-hole_dy/2,0]) HullPoint();
                translate([-hole_dx/2,-hole_dy/2,0]) HullPoint();
            }
        }
        translate([-hole_dx/2,-hole_dy/2,0]) cylinder_outer(min_thickness, outer_rad);
        translate([-hole_dx/2,hole_dy/2,0]) cylinder_outer(min_thickness, outer_rad);
        translate([hole_dx/2,hole_dy/2,0]) cylinder_outer(min_thickness, outer_rad);
        translate([hole_dx/2,-hole_dy/2,0]) cylinder_outer(min_thickness, outer_rad);
    }

    translate([-hole_dx/2,-hole_dy/2,0]) doughnut(min_thickness, outer_rad, hole_rad);
    translate([-hole_dx/2,hole_dy/2,0]) doughnut(min_thickness, outer_rad, hole_rad);
    translate([hole_dx/2,hole_dy/2,0]) doughnut(min_thickness, outer_rad, hole_rad);
    translate([hole_dx/2,-hole_dy/2,0]) doughnut(min_thickness, outer_rad, hole_rad);
}
