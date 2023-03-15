include <shared.scad>

light_x=80;
triangle_cutout_y_z=6;
// sized to fit impact driver bit
screw_head_dia=14;
screw_hole_dia=4.3;

// 8g CSC Head Screw
base_plate_screw_csc_head_dia=8 + 2clearance_loose;
base_plate_screw_csc_head_len=3.7 + clearance_loose;
base_plate_screw_dia=4.3 + 2clearance_loose;

// calc
base_plate_screw_csc_head_rad=base_plate_screw_csc_head_dia/2;
base_plate_screw_rad=base_plate_screw_dia/2;

base_plate_thickness=base_plate_screw_csc_head_len;

// base-plate
bp_hole_dist=45;
bp_hole_half_dist = bp_hole_dist / 2;
bp_screw_holes=[
    [0,0],
    [bp_hole_half_dist,0],
    [bp_hole_dist,0],
    [bp_hole_half_dist,bp_hole_half_dist],
    [bp_hole_half_dist,-50]
];

actual_light_x=light_x+2clearance_loose;
screw_head_rad=screw_head_dia/2;
rect_dim=[
    actual_light_x+2min_thickness,
    triangle_cutout_y_z+min_thickness,
    triangle_cutout_y_z+min_thickness+base_plate_thickness
];
screw_head_tran=[
    rect_dim.x / 2,
    rect_dim.y + screw_head_rad,
    0
];

screw_hole_rad=screw_hole_dia/2 + clearance_loose;

// clip
module Clip() {
    difference() {
        hull() {
            cube(rect_dim);
            translate(screw_head_tran) cylinder_outer(min_thickness, screw_head_rad);
        }
        translate([
            screw_head_tran.x,
            screw_head_tran.y,
            min_thickness
        ]) cylinder_outer(100, screw_head_rad);
        translate([0,0,-de_minimis]) translate(screw_head_tran) cylinder_outer(100, screw_hole_rad);
        translate([min_thickness,0,triangle_cutout_y_z+base_plate_thickness]) rotate([0,90,0]) linear_extrude(actual_light_x) polygon(points=[
            [0,0],
            [triangle_cutout_y_z,0],
            [triangle_cutout_y_z,triangle_cutout_y_z],
        ]);
    }
}


module BasePlate() {
    difference() {
        hull() {
            for (co_ord=bp_screw_holes) {
                translate([co_ord.x, co_ord.y, 0]) cylinder_outer(base_plate_thickness, base_plate_screw_rad * 3);
            }
        }
        for (co_ord=bp_screw_holes) {
            translate([co_ord.x, co_ord.y, 0]) CounterSunkScrew(base_plate_screw_dia, 20, base_plate_screw_csc_head_len, base_plate_screw_csc_head_dia);
        }
    }

}

BasePlate();

translate([0,50,0]) Clip();