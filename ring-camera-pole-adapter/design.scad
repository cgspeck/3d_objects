include <MCAD/constants.scad>
include <shared.scad>

pole_ridges=true;

pole_xy=21;
pole_ridge_x=pole_xy + 2min_thickness + 2clearance_loose;
pole_ridge_rad=pole_ridge_x /  2;
pole_ridge_depth=2min_thickness;

adapter_height=15 + pole_ridge_depth;

ring_bracket_dia=69;
ring_bracket_rad=ring_bracket_dia/2;

ring_bracket_hole_dx_dy=1.4 * mm_per_inch ;
half_ring_bracket_hole_dx_dy=ring_bracket_hole_dx_dy/2;
// select 3 x 16mm CSC machine screws
ring_bracket_hole_dia=3;
ring_bracket_bolt_len=16;
ring_bracket_hole_rad=ring_bracket_hole_dia/2 + clearance_loose;

ring_hole_translations=[
    [-half_ring_bracket_hole_dx_dy, -half_ring_bracket_hole_dx_dy],
    [-half_ring_bracket_hole_dx_dy, half_ring_bracket_hole_dx_dy],
    [half_ring_bracket_hole_dx_dy, half_ring_bracket_hole_dx_dy],
    [half_ring_bracket_hole_dx_dy, -half_ring_bracket_hole_dx_dy]
];

difference(){
    cone_outer(
        adapter_height,
        ring_bracket_rad,
        pole_ridge_rad
    );

    translate([
        0,
        0,
        adapter_height - pole_ridge_depth / 2 + de_minimis
    ]) cube([
        pole_ridges ? pole_xy + 2clearance_loose : ring_bracket_rad * 2,
        ring_bracket_dia,
        pole_ridge_depth
        ],
        center=true
    );

    for (t=ring_hole_translations) {
        translate(t) NutHoleAssembly(
            diameter=3,
            length=ring_bracket_bolt_len,
            nut_depth=3.6,
            nut_mult=1,
            bolt_head_len=0,
            de_minimis=0.01
        );
    }

    // measured off a #8 metalfix screw
    csc_len=3.8;
    translate([
        0,
        0,
        csc_len + 6
    ]) rotate([180,0,0]) CounterSunkScrew(
        4.4,
        15,
        csc_len,
        8.1,
        screw_z_offset=de_minimis
    );
}
