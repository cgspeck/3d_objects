include <MCAD/nuts_and_bolts.scad>

min_thickness=2.4;
2min_thickness=2 * min_thickness;
motor_xy=[
    42.3,
    42.3
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
            min_thickness + clearance_tight,
            min_thickness + clearance_tight,
            0
        ]) cube(AddVect2Y(motor_xy, 2clearance_tight, tray_z));
    } else {
        cube(AddVect2Y(motor_xy, 2min_thickness + 2clearance_tight, tray_z + min_thickness));
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
    mid_pt=motor_xy.x/2 + min_thickness + clearance_tight;
    nut_holder_pts=[
        [mid_pt, -METRIC_NUT_AC_WIDTHS[bolt_size] * .5],
        [mid_pt, motor_xy.y + 2min_thickness + METRIC_NUT_AC_WIDTHS[bolt_size] * .5]
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

Top();