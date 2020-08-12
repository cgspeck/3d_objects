include <MCAD/nuts_and_bolts.scad>

fn=72*3;
$fn=fn;

module cylinder_outer(height,radius,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

module cylinder_mid(height,radius,fn=fn){
   fudge = (1+1/cos(180/fn))/2;
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

module _hinge(shaft_rad, length, knuckles, mode, side,
    outer_rad, flatplate, clearance, nom_knuckle_x_dim) {
    knuckles_this_side = side == 1 ?
        ceil(knuckles / 2)
        : floor(knuckles / 2);

    intersection() {
        translate([
            0,
            outer_rad,
            outer_rad
        ]) {
            difference() {
                union() {
                    rotate([0, 90, 0]) {
                        cylinder_mid(length, outer_rad);
                    }

                    if (flatplate) {
                        translate([
                            0,
                            -outer_rad,
                            -outer_rad
                        ]) cube([
                            length,
                            outer_rad,
                            outer_rad * 2
                        ]);
                    }
                }
                // hole for shaft
                if (mode=="normal") {
                    rotate([0, 90, 0]) {
                        cylinder_mid(length, shaft_rad + clearance);
                    }
                }

            }
        }

        mask_dim=[
            nom_knuckle_x_dim,
            outer_rad * 2,
            outer_rad * 2
        ];
        for (i=[0:(knuckles - 1)]) {
            // only output the knuckles we want for this side
            if ((i % 2) == side && mode == "normal") {
                x_mid_pt = (length / (knuckles )) * i;

                x_tran = i == 0 ? 0 : x_mid_pt + clearance / 2;
                x_len = i == 0 ? nom_knuckle_x_dim + clearance / 2 :
                    i == (knuckles - 1) ? nom_knuckle_x_dim + clearance / 2  :
                    nom_knuckle_x_dim;

                mask_trans=[
                    x_tran,
                    0,
                    0
                ];

                translate(mask_trans) cube([
                    x_len,
                    mask_dim.y,
                    mask_dim.z
                ]);
            }
        }

    }

}

module Hinge(shaft_dia, length, knuckles, mode="normal", side=0,
    outer_dia=0, flatplate=false, clearance=0.4, punch_through=0,
    nut_hole=0, flip=false, nut_hole_depth_mult=1.5
    ) {
    /*
    Valid modes:
        normal: just the hinge
        negative: masks for this side hinge and other side

        cutout_with_clearance: cutout area + clearance value

    flatplate: produces a hinge part that looks like a 'D', otherwise 'O'

    outer_dir: if 0, cal automatically otherwise use set value

    side: 0 or 1

    punch_through: extend the shape on either end

    nut_hole: if > 0 embed that sized metric nut holder on one end

    flip: shifts knuckles for side 1 along the x axis, may help with integration where you have even number of knucles

    nut_hole_depth_mult: in multiples of the standard metric nut thickness, how deep to make the nuthole

    */
    shaft_rad = shaft_dia / 2;
    outer_rad = outer_dia == 0 ? shaft_rad * 2 : max(shaft_rad * 2, outer_dia / 2);
    nom_knuckle_x_dim = (length / knuckles) - clearance;
    hinge_trans = flip ?
        [-nom_knuckle_x_dim, 0, 0]:
        [0, 0, 0];
    translate(hinge_trans) difference() {
        _hinge(
            shaft_rad, length, knuckles, mode, side,
            outer_rad, flatplate, clearance, nom_knuckle_x_dim
        );
        if (nut_hole > 0) {
            scale([
                nut_hole_depth_mult,
                1,
                1,
            ]) translate([
                0,
                outer_rad,
                outer_rad
            ]) rotate([0, 90, 0]) nutHole(nut_hole);
        }
    }

    if (mode=="negative" && punch_through > 0) {
        translate([
            -punch_through,
            0,
            0
        ]) _hinge(
            shaft_rad, length, knuckles, mode, side,
            outer_rad, flatplate, clearance, nom_knuckle_x_dim
        );
        translate([
            punch_through,
            0,
            0
        ]) _hinge(
            shaft_rad, length, knuckles, mode, side,
            outer_rad, flatplate, clearance, nom_knuckle_x_dim
        );
    }
}

module HingePlug(shaft_dia) {}

Hinge(3, 50, 5, side=0);

Hinge(3, 50, 5, side=1);

translate([0, -10, 0]) Hinge(3, 50, 6, side=0);

translate([0, -20, 0]) Hinge(3, 50, 6, side=1);

translate([0, -30, 0]) Hinge(3, 50, 6, side=1, flip=true);

translate([0, 10, 0]) Hinge(3, 50, 5, outer_dia=12);

translate([0, 30, 0]) Hinge(3, 50, 5, flatplate=true);

translate([0, 40, 0]) Hinge(3, 50, 5, flatplate=true, mode="negative");

translate([0, 50, 0]) Hinge(3, 50, 5, flatplate=true, mode="negative", punch_through=10);

translate([0, 60, 0]) Hinge(3, 50, 5, flatplate=true, nut_hole=3, outer_dia=METRIC_NUT_AC_WIDTHS[5]);
