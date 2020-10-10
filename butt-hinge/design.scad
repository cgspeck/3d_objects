include <MCAD/nuts_and_bolts.scad>
use <hinge.scad>
// from https://www.armstrongmetalcrafts.com/Reference/WasherSizes.aspx
METRIC_WASHER_OD = [
    -1,
    3.2,
    5,
    7,
    9,
    10,
    12,
    14,
    16,
    16,
    20,
    24,
    24,
    24,
    28,
    28,
    30,
    30,
    34,
    34,
    37
];

fn=72*3;
$fn=fn;

module cylinder_outer(height,radius,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

min_thickness=1.2;

// Metric bolt and nut used to attach the plate to your object
plate_fixing_size=3;
plate_x=20;
plate_y=30;
plate_fixings_horiz=1;
plate_fixings_vert=2;

// Metric bolt and nut used as a shaft
hinge_shaft_dia=3;
hinge_knuckles=3;
hinge_outer_dia=METRIC_WASHER_OD[hinge_shaft_dia];

// [ hidden ]
plate_z=min_thickness + METRIC_NUT_THICKNESS[plate_fixing_size];
plate_dim=[plate_x, plate_y, plate_z];

module ButtHinge(plate_dim, plate_fixing_size, hinge_shaft_dia, hinge_knuckles, hinge_outer_dia, side, clearance=0.4, countersunk_bolt=false, embedded_nyloc_nut=false) {
    hinge_trans=[plate_dim.x + hinge_shaft_dia, 0, 0];
    hinge_rot=[0, 0, 90];
    difference() {
        cube(plate_dim);
        translate(hinge_trans) rotate(hinge_rot) Hinge(hinge_shaft_dia, plate_dim.y, hinge_knuckles, mode="cutout_with_clearance", side=side, outer_dia=hinge_outer_dia);

        fixing_dx=plate_dim.x / (plate_fixings_horiz + 1);
        fixing_dy=plate_dim.y / (plate_fixings_vert + 1);

        for (h=[1:plate_fixings_horiz]) {
            for (v=[1:plate_fixings_vert]) {
                pos=[h * fixing_dx, v * fixing_dy, plate_dim.z - METRIC_NUT_THICKNESS[plate_fixing_size]];
                translate(pos) nutHole(plate_fixing_size);
                translate([pos.x, pos.y, 0]) cylinder_outer(plate_dim.z, (plate_fixing_size) / 2 + clearance);
            }
        }

    }
    translate(hinge_trans) rotate(hinge_rot) Hinge(hinge_shaft_dia, plate_y, hinge_knuckles, side=side, outer_dia=hinge_outer_dia, countersunk_bolt=countersunk_bolt, embedded_nyloc_nut=embedded_nyloc_nut);
}

countersunk_bolt=true;
embedded_nyloc_nut=true;
ButtHinge(plate_dim, plate_fixing_size, hinge_shaft_dia, hinge_knuckles, hinge_outer_dia, 0, countersunk_bolt=countersunk_bolt, embedded_nyloc_nut=embedded_nyloc_nut);

translate([plate_dim.x * 2.5, plate_dim.y, 0]) rotate([0, 0, 180]) ButtHinge(plate_dim, plate_fixing_size,  hinge_shaft_dia, hinge_knuckles, hinge_outer_dia, 1);
