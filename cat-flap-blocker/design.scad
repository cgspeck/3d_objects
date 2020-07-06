include <MCAD/nuts_and_bolts.scad>

cat_flap_frame_protrusion=70;
post_width=16.16;

plate_fixing_diameter=3.9;
plate_fixing_head_diameter=9;

plate_thickness=2.4;
guide_thickness=1.2;
guide_depth=1.5;


post_fixing_diameter=3;
post_fixing_nut_width=METRIC_NUT_AC_WIDTHS[post_fixing_diameter];


// fixed

clearance_loose=0.4;
clearance_tight=0.2;
fn=72*2;
$fn=fn;

module cylinder_outer(height,radius,fn=fn) {
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}
// calc
post_fixing_dim = [
    (guide_thickness * 2) + (clearance_loose * 2) + post_width,
    3 * post_fixing_nut_width,
    guide_thickness,
];

plate_dim = [
    post_fixing_dim.x,
    cat_flap_frame_protrusion + 2 * post_fixing_nut_width,
    plate_thickness
];




strut_pad_dim=[post_fixing_dim.x, 2.4, 1.2];

post_fixing_dim_2= [
    post_fixing_dim.x,
    post_fixing_dim.y,
    5
];

module _jig(solid=false) {
    if (solid) {
        cube(plate_dim);
    } else {
        plate_fixing_x_trans = post_fixing_dim.x / 2;
        // attachment to wall fixing
        translate([plate_fixing_x_trans, plate_dim.y / 2, 0]) cylinder_outer(plate_thickness, (plate_fixing_diameter / 2) + clearance_loose);
        // m3 nut holder
        translate([post_fixing_dim.x / 2, post_fixing_dim.y / 2, 0]) nutHole(post_fixing_diameter);
    }
}


module _mountPlate(post_fixing_side="left", solid=false) {
    if (solid) {
        cube(plate_dim);

        post_fixing_x_trans = (post_fixing_side == "left") ? 0 : (plate_dim.x - post_fixing_dim.x);
        post_fixing_z_trans = max(0, plate_dim.z - post_fixing_dim.z);
        post_fixing_lower_y_trans = plate_dim.y - post_fixing_dim.y;
        strut_fixing_lower_y_trans = plate_dim.y - strut_pad_dim.y;

        hull() {
            offset=1.3;
            translate([post_fixing_x_trans, post_fixing_dim.y - strut_pad_dim.y, cat_flap_frame_protrusion - strut_pad_dim.z - offset]) cube(size=[strut_pad_dim.x, strut_pad_dim.y, strut_pad_dim.z + offset], center=false);
            translate([post_fixing_x_trans, strut_fixing_lower_y_trans, post_fixing_z_trans]) cube(size=strut_pad_dim, center=false);
        }

        hull() {
            translate([post_fixing_x_trans, 0, cat_flap_frame_protrusion - strut_pad_dim.z]) cube(size=strut_pad_dim, center=false);
            translate([post_fixing_x_trans, 0, post_fixing_z_trans]) cube(size=strut_pad_dim, center=false);
        }

        hull() {
            translate([post_fixing_x_trans, post_fixing_dim.y - strut_pad_dim.y, cat_flap_frame_protrusion - post_fixing_dim_2.z]) cube(size=[strut_pad_dim.x, strut_pad_dim.y, post_fixing_dim_2.z], center=false);
            translate([post_fixing_x_trans, 0, cat_flap_frame_protrusion - post_fixing_dim_2.z]) cube(size=[strut_pad_dim.x, strut_pad_dim.y, post_fixing_dim_2.z], center=false);
        }

        // guides
        guide_base_x_tran = (post_fixing_side=="left") ? 0 : plate_dim.x - post_fixing_dim.x;
        guide_dim=[guide_thickness, post_fixing_dim.y, guide_depth];
        // first
        if (post_fixing_side=="left") {
            translate([guide_base_x_tran, 0, cat_flap_frame_protrusion]) cube(guide_dim);
        } else {
            // second
            translate([guide_base_x_tran + post_fixing_dim.x - guide_dim.x, 0, cat_flap_frame_protrusion]) cube(guide_dim);
        }



    } else {
        plate_fixing_x_trans = post_fixing_dim.x / 2;
        // attachment to wall fixing
        translate([plate_fixing_x_trans, plate_dim.y / 2, 0]) cylinder_outer(plate_thickness, (plate_fixing_diameter / 2) + clearance_loose);
        // access for screw driver
        translate([plate_fixing_x_trans, plate_dim.y / 2, 20]) cylinder_outer(40, (6.7 / 2) + clearance_loose);

        post_fixing_x_trans = (post_fixing_side == "left") ? post_fixing_dim.x / 2 : (plate_dim.x - post_fixing_dim.x / 2);
        // m3 bolt hole
        translate([post_fixing_x_trans, post_fixing_dim.y / 2, plate_dim.z]) cylinder_outer(cat_flap_frame_protrusion, (post_fixing_diameter / 2) + clearance_loose);
        // m3 nut holder
        translate([post_fixing_x_trans, post_fixing_dim.y / 2, cat_flap_frame_protrusion - 5]) nutHole(post_fixing_diameter);
    }
}


module MountPlate(post_fixing_side="left") {
    difference() {
        _mountPlate(post_fixing_side, true);
        _mountPlate(post_fixing_side, false);
    }
}


module Jig() {
    difference() {
        _jig(true);
        _jig(false);
    }
}


MountPlate();

translate([40, 0, 0]) MountPlate("right");

translate([80, 0, 0]) Jig();
