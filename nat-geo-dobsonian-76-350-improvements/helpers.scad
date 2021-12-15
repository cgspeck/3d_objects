include <MCAD/nuts_and_bolts.scad>

fn=72*4;
$fn=fn;

clearence_tight=0.2;
clearence_loose=0.4;
2clearence_loose=2*clearence_loose;

de_minimis=0.01;
min_thickness=2.4;
2min_thickness=2*min_thickness;

module cylinder_outer(height,radius,fn=fn) {
    fudge = 1/cos(180/fn);
    cylinder(h=height,r=radius*fudge,$fn=fn);
}

module centered_cylinder_outer(height,radius,fn=fn) {
    fudge = 1/cos(180/fn);
    cylinder(h=height,r=radius*fudge,$fn=fn);
}

module circle_outer(radius,fn=fn){
    fudge = 1/cos(180/fn);
    circle(r=radius*fudge,$fn=fn);
}

module cone_outer(height,radius1,radius2,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r1=radius1*fudge,r2=radius2*fudge,$fn=fn);
}

module doughnut(height, outer_radius, inner_radius, fn=fn) {
    difference() {
        cylinder_outer(height, outer_radius, fn);
        translate([0,0,-de_minimis]) cylinder_outer(height + (de_minimis*2), inner_radius, fn);
    }
}

module NutHoleAssembly(
    diameter=5,
    length=20,
    nut_depth=2.4,
    nut_mult=1,
    bolt_head_len=0,
    de_minimis=0.01
) {
    cylinder_outer(length, diameter / 2 + clearence_loose);
    nut_thickness=METRIC_NUT_THICKNESS[diameter];
    nut_total_height=nut_thickness * nut_mult;
    leading_height=length - nut_depth - nut_total_height;

    translate([
        0,
        0,
        nut_depth
    ]) scale([1, 1, nut_mult]) nutHole(diameter);

    translate([
        0,
        0,
        nut_depth + nut_total_height - de_minimis
    ]) {
        cylinder_outer(leading_height, (METRIC_NUT_AC_WIDTHS[diameter] / 2) + clearence_loose);    
    }
    
    if (bolt_head_len > 0) {
        bolt_head_dia = METRIC_BOLT_CAP_DIAMETERS[diameter] + clearence_loose * 2;
        translate([0,0,-bolt_head_len]) cylinder_outer(bolt_head_len, bolt_head_dia / 2);
    }
}

