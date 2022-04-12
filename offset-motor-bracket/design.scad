include <MCAD/boxes.scad>
include <shared.scad>

bracket_inner_dim=[
    14.9,
    34,
    26
];

bracket_thickness=min_thickness;

bracket_outer_dim=[
    bracket_inner_dim.x,
    bracket_inner_dim.y + 2 * bracket_thickness,
    bracket_inner_dim.z + bracket_thickness
];

bracket_outlet_dia=11.1;
bracket_outlet_rad=bracket_outlet_dia/2;

bracket_outlet_tran=[
    bracket_outer_dim.x,
    bracket_thickness + 12,
    0
];

bolt_dia=3;
bolt_rad=bolt_dia/2;

hole_dist_x=bracket_inner_dim.x + 3.5 + bolt_rad;
hole_dist_plus_y=bracket_thickness + bracket_inner_dim.y + 4.5 + bolt_rad;
hole_dist_minus_y=bracket_thickness - 7 - bolt_rad;

module hole_pads() {
    pad_rad=bolt_dia*2;

    translate([
        hole_dist_x,
        hole_dist_plus_y,
        0
    ]) cylinder_outer(min_thickness, pad_rad);

    translate([
        hole_dist_x,
        hole_dist_minus_y,
        0
    ]) cylinder_outer(min_thickness, pad_rad);
}

module bolt_holes() {
    translate([
        hole_dist_x,
        hole_dist_plus_y,
        0
    ]) cylinder_outer(min_thickness, bolt_rad + clearance_loose);

    translate([
        hole_dist_x,
        hole_dist_minus_y,
        0
    ]) cylinder_outer(min_thickness, bolt_rad + clearance_loose);  
}

module bracket_cutouts() {
    translate([
        0,
        bracket_thickness,
        0
    ]) cube([
        bracket_inner_dim.x + 50,
        bracket_inner_dim.y,
        bracket_inner_dim.z
    ]);

    translate(bracket_outlet_tran) cylinder_outer(50, bracket_outlet_rad);
}

module bracket_model() {
    difference() {
        cube(bracket_outer_dim);
        bracket_cutouts();
    };
}

module bracket_model_slice() {
    intersection() {
        bracket_model();
        cube([100,100,min_thickness]);
    }
}

module motor_ridge_cutout() {
    dim=[
        1.6 + clearance_loose,
        1.4 + clearance_loose,
        bracket_inner_dim.z
    ];

    ttl_slice_dim=[
        dim.x,
        bracket_inner_dim.y + (dim.y * 2),
        bracket_inner_dim.z
    ];

    translate([
        bracket_inner_dim.x,
        (bracket_outer_dim.y - ttl_slice_dim.y) / 2,
        0
    ]) cube(ttl_slice_dim);
}

difference() {
    union() {
        hull() {
            bracket_model_slice();
            hole_pads();
        }
        bracket_model();
    }

    bracket_cutouts();
    bolt_holes();
    motor_ridge_cutout();
}


