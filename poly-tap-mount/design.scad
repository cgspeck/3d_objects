include <MCAD/nuts_and_bolts.scad>

min_thickness=2.4;
2min_thickness=2*min_thickness;
clearance_loose=0.4;
2clearance_loose=2*clearance_loose;
8ga_screw_dia=4.2;
10ga_screw_dia=4.9;

top_screw_dia=8ga_screw_dia + 2clearance_loose;
top_screw_pad=top_screw_dia + 2min_thickness;

bottom_screw_metric_bolt_size=5;
bottom_side_screw_dia=bottom_screw_metric_bolt_size + 2clearance_loose;
bottom_side_screw_pad=METRIC_NUT_AC_WIDTHS[bottom_screw_metric_bolt_size] + 2min_thickness;

// select Metalfix Zenith Countersunk Head Screw Phillips Drive 8G x 25mm for top, and bottom middle fixings
// top is through poly fitting and 3d print
// bottom holes are through 3d print only, and covered by poly fitting
bottom_dx=25;
countersink_upper_dia=8.15;
countersink_z=4.0;
countersink_lower_dia=8ga_screw_dia;

// r1 is a metal fix
// r2 is m5 bolt/nut
tap_r2_dx=50;
tap_r1_r2_dy=25;
poly_base_thickness=5;

// select https://www.bunnings.com.au/zenith-m5-x-12mm-316-stainless-steel-round-head-bolt-and-nut-6-pack_p2310746
total_thickness=12;
printed_part_thickness=total_thickness - poly_base_thickness;
echo("printed_part_thickness", printed_part_thickness, "mm");

fn=72 * 3;
$fn=fn;

module cylinder_outer(height,radius,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);}

module cone_outer(height,radius1,radius2,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r1=radius1*fudge,r2=radius2*fudge,$fn=fn);}

module TopHole(cutouts_only=false) {
    if (cutouts_only) {
        cylinder_outer(printed_part_thickness, top_screw_dia / 2);
    } else {
        cylinder_outer(printed_part_thickness, top_screw_pad / 2);
    }
}

module SideHole(cutouts_only=false, side=-1) {
    translate([
        tap_r2_dx / 2 * side,
        -tap_r1_r2_dy,
        0
    ]) {
        if (cutouts_only) {
            cylinder_outer(printed_part_thickness, bottom_side_screw_dia / 2);
            nutHole(bottom_screw_metric_bolt_size);
        } else {
            union() {
                cylinder_outer(printed_part_thickness, bottom_side_screw_pad / 2);
            }
        }
    }
}

module BottomHole(side=-1) {
    translate([(bottom_dx / 2) * side, -tap_r1_r2_dy, 0]) {
        cylinder_outer(printed_part_thickness, top_screw_dia / 2);
        translate([
            0,
            0,
            printed_part_thickness - countersink_z
        ]) cone_outer(countersink_z, (countersink_lower_dia / 2 + clearance_loose), (countersink_upper_dia / 2 + clearance_loose));
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
    BottomHole(1);
}


