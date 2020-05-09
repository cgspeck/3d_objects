include <MCAD/nuts_and_bolts.scad>

min_thickness=2.4;
2min_thickness=2 * min_thickness;
motor_xy=[
    42,
    42
];

tray_z=10;

clearance_loose=0.4;
2clearance_loose=2*clearance_loose;
clearance_tight=0.2;
2clearance_tight=2*clearance_tight;

fn=72*2;
$fn=fn;

module cylinder_outer(height,radius,fn=fn) {
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

function AddVect2(vect, num) = [vect[0] + num, vect[1] + num];

function AddVect2Y(vect, num, y) = [vect[0] + num, vect[1] + num, y];

module _tray(cutout_only) {
    if (cutout_only) {
        translate([
            min_thickness,
            min_thickness,
            0
        ]) cube(AddVect2Y(motor_xy, 0, tray_z));
    } else {
        cube(AddVect2Y(motor_xy, 2min_thickness, tray_z + min_thickness));
    }
}

bolt_size=5;

module _nutHolder(cutout_only) {
    if (cutout_only) {
        //
        cylinder_outer(tray_z * 2, (bolt_size + 2clearance_loose) / 2);
        nutHole(bolt_size);
    } else {
        cylinder_outer(tray_z + min_thickness, METRIC_NUT_AC_WIDTHS[bolt_size] * .75);
    }
}

module Top() {
    mid_pt=motor_xy.x/2 + min_thickness;
    nut_holder_pts=[
        [mid_pt, -METRIC_NUT_AC_WIDTHS[bolt_size] * .4],
        [mid_pt, motor_xy.y + 2min_thickness + METRIC_NUT_AC_WIDTHS[bolt_size] * .4]
    ];

    difference() {
        hull() {
            _tray(false);
            translate([nut_holder_pts[0].x, nut_holder_pts[0].y, 0]) _nutHolder(false);
            translate([nut_holder_pts[1].x, nut_holder_pts[1].y, 0]) _nutHolder(false);
        }

        _tray(true);
        translate([nut_holder_pts[0].x, nut_holder_pts[0].y, 0]) _nutHolder(true);
        translate([nut_holder_pts[1].x, nut_holder_pts[1].y, 0]) _nutHolder(true);

        translate([
            mid_pt,
            mid_pt,
            0
        ]) cylinder_outer(tray_z * 2, 7/2);
    }
}

module Pointer() {
    difference() {
        hull() {
            cylinder_outer(min_thickness, 10/2);
            dx=75;
            translate([0, -min_thickness / 2, 0]) cube([dx / 2, min_thickness, min_thickness]);
            translate([-dx / 2, -min_thickness, 0]) cube([dx / 2, min_thickness, min_thickness]);
        }
        // a D, whereby it's width is 4.6mm
        difference() {
            cylinder_outer(min_thickness, (5 + 2clearance_tight)/2);
            translate([
                -2.5 - clearance_tight,
                -2.5 - clearance_tight,
                0
            ]) cube([
                .3,
                5 + 2clearance_tight,
                2min_thickness
            ]);
        }
    }
}

translate([50, 0, tray_z + min_thickness]) rotate([0, 180, 0]) Top();

translate([100,0,0]) Pointer();
