include <shared.scad>

hole_dx = 176;
hole_dy = 176;
hole_dia = 10;
hole_rad = hole_dia / 2 + clearance_tight;


difference() {
    union() {
        multiHull() {
            cylinder_outer(min_thickness, hole_dia);
            translate([-hole_dx/2,-hole_dy/2,0]) cylinder_outer(min_thickness, hole_dia);
            translate([-hole_dx/2,hole_dy/2,0]) cylinder_outer(min_thickness, hole_dia);
            translate([hole_dx/2,hole_dy/2,0]) cylinder_outer(min_thickness, hole_dia);
            translate([hole_dx/2,-hole_dy/2,0]) cylinder_outer(min_thickness, hole_dia);
        }
        sequentialHull() {
            translate([-hole_dx/2,-hole_dy/2,0]) cylinder_outer(min_thickness, hole_dia);
            translate([-hole_dx/2,hole_dy/2,0]) cylinder_outer(min_thickness, hole_dia);
            translate([hole_dx/2,hole_dy/2,0]) cylinder_outer(min_thickness, hole_dia);
            translate([hole_dx/2,-hole_dy/2,0]) cylinder_outer(min_thickness, hole_dia);
            translate([-hole_dx/2,-hole_dy/2,0]) cylinder_outer(min_thickness, hole_dia);
        }
    }


    translate([-hole_dx/2,-hole_dy/2,0]) cylinder_outer(min_thickness, hole_rad);
    translate([-hole_dx/2,hole_dy/2,0]) cylinder_outer(min_thickness, hole_rad);
    translate([hole_dx/2,hole_dy/2,0]) cylinder_outer(min_thickness, hole_rad);
    translate([hole_dx/2,-hole_dy/2,0]) cylinder_outer(min_thickness, hole_rad);
}
