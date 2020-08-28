include <MCAD/nuts_and_bolts.scad>

min_thickness=2.4;
2min_thickness=2*min_thickness;
clearance_loose=0.4;
2clearance_loose=2*clearance_loose;
8ga_screw_dia=4.2;
10ga_screw_dia=4.9;

tap_r2_dx=50;
tap_r1_r2_dy=25;

// r1 is a metal fix
// r2 is m5 bolt/nut

fn=72 * 3;
$fn=fn;

module cylinder_outer(height,radius,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);}

thickness=10;

top_screw_dia=8ga_screw_dia + 2clearance_loose;
top_screw_pad=top_screw_dia + 2min_thickness;

bottom_screw_metric_bolt_size=5;
bottom_side_screw_dia=bottom_screw_metric_bolt_size + 2clearance_loose;
bottom_side_screw_pad=METRIC_NUT_AC_WIDTHS[bottom_screw_metric_bolt_size] + 2min_thickness;

module TopHole(cutouts_only=false) {
    if (cutouts_only) {
        cylinder_outer(thickness, top_screw_dia / 2);
    } else {
        cylinder_outer(thickness, top_screw_pad / 2);
    }
}

module SideHole(cutouts_only=false, side=-1) {
    translate([
        tap_r2_dx / 2 * side,
        -tap_r1_r2_dy,
        0
    ]) {
        if (cutouts_only) {
            cylinder_outer(thickness, bottom_side_screw_dia / 2);
            nutHole(bottom_screw_metric_bolt_size);
        } else {
            union() {
                cylinder_outer(thickness, bottom_side_screw_pad / 2);
            }
        }
    }
}

module BottomHole() {
    translate([0, -tap_r1_r2_dy, 0]) {
        cylinder_outer(thickness, top_screw_dia / 2);
    }
}

difference() {
    hull() {
        TopHole();
        SideHole();
        SideHole(side=1);
    }

    TopHole(true);
    SideHole(true);
    SideHole(true, 1);
    BottomHole();
}


