min_thickness=1.2;
clearance_loose=0.4;
clearance_tight=0.2;

fn=72*3;
$fn=fn;

module cylinder_outer(height,radius,fn=fn) {
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

hole_size=4 + (clearance_loose * 2);

handle_hole_spacing=5 * 25.4; // apparently 5"

jig_w=handle_hole_spacing * 1.5;
jig_z=5;
draw_height=177;

jig_pad_dim=[
    10,
    10,
    min_thickness
];

module HoleBush(holes=true, holes_only=false) {
    difference() {
        cylinder_outer(min_thickness, hole_size * 2);

        if (holes) {
            cylinder_outer(min_thickness, hole_size / 2);
        }
    }

    if (holes_only) {
        cylinder_outer(min_thickness, hole_size / 2);
    }
}

module Hole1(holes=true, holes_only=false) {
    translate([-handle_hole_spacing / 2,0,0]) HoleBush(holes, holes_only);
}

Hole1();

module Hole2(holes=true, holes_only=false) {
    translate([handle_hole_spacing / 2,0,0]) HoleBush(holes, holes_only);
}

Hole2();

module Pad() {
    cube(jig_pad_dim);
}

pad_z1_trans=draw_height/2-jig_pad_dim.y+clearance_loose;
pad_z2_trans=-draw_height/2-clearance_loose;

module Finger() {
    cube([
        jig_pad_dim.x,
        min_thickness,
        jig_z + min_thickness
    ]);
}

module Pad1(finger=false) {
    translate([
        -jig_w / 2,
        0,
        0
    ]) {
        translate([0, pad_z1_trans, 0]) Pad();

        if (finger) {
            translate([0, pad_z1_trans + jig_pad_dim.y, 0]) Finger();
        }
    }
}

module Pad2(finger=false) {
    translate([
        -jig_w / 2,
        0,
        0
    ]) {
        translate([0, pad_z2_trans, 0]) Pad();

        if (finger) {
            translate([0, pad_z2_trans - min_thickness, 0]) Finger();
        }
    }
}

module Pad3(finger=false) {
    translate([
        (jig_w / 2) - jig_pad_dim.x,
        0,
        0
    ]) {
        translate([0, pad_z1_trans, 0]) Pad();
        if (finger) {
            translate([0, pad_z1_trans + jig_pad_dim.y, 0]) Finger();
        }
    }
}

module Pad4(finger=false) {
    translate([
        (jig_w / 2) - jig_pad_dim.x,
        0,
        0
    ]) {
        translate([0, pad_z2_trans, 0]) Pad();

        if (finger) {
            translate([0, pad_z2_trans - min_thickness, 0]) Finger();
        }
    }
}

difference() {
    union() {
        hull() {
            Pad1();
            Pad4();
        }

        hull() {
            Pad2();
            Pad3();
        }

        hull() {
            Pad1();
            Hole1();
        }

        hull() {
            Pad2();
            Hole1();
        }

        hull() {
            Pad3();
            Hole2();
        }

        hull() {
            Pad4();
            Hole2();
        }
    }

    Hole1(holes_only=true);
    Hole2(holes_only=true);
}

Pad1(true);
Pad3(true);
Pad2(true);
Pad4(true);
