include <MCAD/nuts_and_bolts.scad>
use <MCAD/boxes.scad>


// Choose a font
//
// tank_water_font="Liberation Sans";
// tank_water_baseline_font_size=20;
//
// OR
use <font/nasalization rg.ttf>
tank_water_font="Nasalization Rg";
tank_water_baseline_font_size=15;
// !!! download font from https://fontmeme.com/fonts/nasalization-font/ and place in ./font/ !!!

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

tank_water_str1="Tank";
tank_water_str2="Water";
tank_water_tran1=[0,43,printed_part_thickness - min_thickness];
tank_water_tran2=[0,20,printed_part_thickness - min_thickness];

text_height=min_thickness;
text_halign="center";

module TextPieces() {
    translate(tank_water_tran1) linear_extrude(text_height) text(tank_water_str1, size=tank_water_baseline_font_size, halign=text_halign, font=tank_water_font);
    translate(tank_water_tran2) linear_extrude(text_height) text(tank_water_str2, size=tank_water_baseline_font_size, halign=text_halign, font=tank_water_font);
}


text_area_base=[80, 50, 2min_thickness];
text_area_tran=[
    0,
    text_area_base.y/2 + 15,
    printed_part_thickness - text_area_base.z/2
];

module TextAreaBase() {
    translate(text_area_tran) roundedBox(text_area_base, 3, true);
}

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
        TextAreaBase();
    }

    TopHole(true);
    SideHole(true);
    SideHole(true, 1);
    BottomHole();
    BottomHole(1);
    TextPieces();
}


