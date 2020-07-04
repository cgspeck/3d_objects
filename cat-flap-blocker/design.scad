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

plate_dim = [
    (plate_fixing_head_diameter * 2) + (guide_thickness * 2) + post_width,
    cat_flap_frame_protrusion + 2 * post_fixing_nut_width,
    plate_thickness
];

post_fixing_dim = [
    (guide_thickness * 2) + (clearance_loose * 2) + post_width,
    2 * post_fixing_nut_width,
    guide_thickness,
];


module _mountPlate(post_fixing_side="left", solid=false) {
    if (solid) {
        cube(plate_dim);

        post_fixing_x_trans = (post_fixing_side == "left") ? 0 : (plate_dim.x - post_fixing_dim.x);

        hull() {
            translate([post_fixing_x_trans, 0, cat_flap_frame_protrusion - post_fixing_dim.z]) cube(size=post_fixing_dim, center=false);
            translate([post_fixing_x_trans, 0, 0]) cube(size=[
                post_fixing_dim.x,
                plate_dim.y,
                plate_dim.z
            ], center=false);
        }

        // guides
        guide_base_x_tran = (post_fixing_side=="left") ? 0 : plate_dim.x - post_fixing_dim.x;
        guide_dim=[guide_thickness, post_fixing_dim.y, guide_depth];
        // first
        translate([guide_base_x_tran, 0, cat_flap_frame_protrusion]) cube(guide_dim);
        // second
        translate([guide_base_x_tran + post_fixing_dim.x - guide_dim.x, 0, cat_flap_frame_protrusion]) cube(guide_dim);

    } else {
        plate_fixing_x_trans = (post_fixing_side == "left") ? (post_fixing_dim.x) + plate_fixing_head_diameter : plate_fixing_head_diameter;
        translate([plate_fixing_x_trans, plate_dim.y / 2, 0]) cylinder_outer(plate_thickness, (plate_fixing_diameter / 2) + clearance_loose * 2);

        post_fixing_x_trans = (post_fixing_side == "left") ? post_fixing_dim.x / 2 : (plate_dim.x - post_fixing_dim.x / 2);
        translate([post_fixing_x_trans, post_fixing_dim.y / 2, 0]) cylinder_outer(cat_flap_frame_protrusion, (post_fixing_diameter / 2) + clearance_loose * 2);

        #translate([post_fixing_x_trans, post_fixing_dim.y / 2, 0]) scale([1, 1, 27.5]) nutHole(post_fixing_diameter);
    }
}


module MountPlate(post_fixing_side="left") {
    difference() {
        _mountPlate(post_fixing_side, true);
        _mountPlate(post_fixing_side, false);
    }
}


MountPlate();

translate([40, 0, 0]) MountPlate("right");
