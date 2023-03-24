include <shared.scad>
// based on design2.1
shield_bolt_dh=70;

// applicable to this model
shield_x=1492;
shield_y=400;
mat_thickness=3;
shield_dim=[
    shield_x,
    shield_y,
    mat_thickness
];

hole_y_from_top=255.75;
hole_y_trans=shield_y-hole_y_from_top;
hole_x_from_sides=40;

hole_pts=[
    [hole_x_from_sides, hole_y_trans],
    [shield_x/3, hole_y_trans],
    [shield_x/3 * 2, hole_y_trans],
    [shield_x - hole_x_from_sides, hole_y_trans],
];

module HoleAssy(top_align=false) {
    fixing_adj_y=cos(actual_angle) * mat_thickness;
    translate([
        0,
        (top_align ? -shield_bolt_dh : -shield_bolt_dh/2),
        0
    ]) {
        translate([0,0,mat_thickness+de_minimis]) intersection() {
            union() {
                translate([0,0,-mat_thickness-2de_minimis]) cylinder_outer(100, shield_bolt_size/2 + clearance_loose);
                translate([
                    0,
                    shield_bolt_dh,
                    -mat_thickness-2de_minimis
                ]) cylinder_outer(100, shield_bolt_size/2 + clearance_loose);

                translate([
                    0,
                    shield_bolt_dh/2 + fixing_adj_y,
                    0
                ]) rotate([-actual_angle,0,0]) translate([0,0,-10-mat_thickness-2de_minimis]) cylinder_outer(100, fixing_screw_head_dia/2 + clearance_loose);

                // FUDGE for fact that rotate cylinder is an oval if you compress all slices  into 1 layer
                // TODO: automate this part?
                rot_cyl_rad=(fixing_screw_head_dia/2 + clearance_loose);
                rot_cyl_scale=[.95,1.3,1];
                hull() {
                    translate([
                        0,
                        shield_bolt_dh/2 + 3.5,
                        0
                    ]) rotate([0,0,0]) translate([0,0,-10-mat_thickness-2de_minimis]) scale(rot_cyl_scale) cylinder_outer(100, rot_cyl_rad);
                    translate([
                        0,
                        shield_bolt_dh/2 - 3.5,
                        0
                    ]) rotate([0,0,0]) translate([0,0,-10-mat_thickness-2de_minimis]) scale(rot_cyl_scale) cylinder_outer(100, rot_cyl_rad);
                }
            }
            translate([
                -fixing_screw_head_dia/2,
                -(shield_bolt_size + clearance_loose),
                -mat_thickness-2de_minimis
            ]) cube([
                fixing_screw_head_dia,
                shield_bolt_dh + 2 * (shield_bolt_size + clearance_loose),
                mat_thickness+2de_minimis
            ]);
        }
    }
}

module Shield() {
    difference() {
        cube(shield_dim);
        for (pt=hole_pts) {
            translate([pt.x, pt.y, 0]) HoleAssy(top_align=true);
        }
    }
}


module PartialShield() {
    intersection() {
        Shield();
        translate([
            35,
            120,
            0
        ]) cube([
            30,
            90,
            10
        ]);
    }
}

// PartialShield();
// HoleAssy();
projection() Shield();