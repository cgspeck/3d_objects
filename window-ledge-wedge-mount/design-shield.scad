include <shared.scad>
// based on design2.1
shield_bolt_dh=70;

// applicable to this model
shield_x=1300;
shield_y=400;
mat_thickness=3;
shield_dim=[
    shield_x,
    shield_y,
    mat_thickness
];

hole_y_from_top=200;

hole_pts=[
    [50, hole_y_from_top],
    [shield_x/3, hole_y_from_top],
    [shield_x/3 * 2, hole_y_from_top],
    [shield_x - 50, hole_y_from_top],
];

module HoleAssy(top_align=false) {
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
                    shield_bolt_dh/2,
                    0
                ]) rotate([-actual_angle,0,0]) translate([0,0,-10-mat_thickness-2de_minimis]) cylinder_outer(100, fixing_screw_head_dia/2 + clearance_loose);
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

PartialShield();