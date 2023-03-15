include <shared.scad>

light_x=80;
triangle_cutout_y_z=6;
// sized to fit impact driver bit
screw_head_dia=14;
screw_hole_dia=4.3;
// calc

actual_light_x=light_x+2clearance_loose;
screw_head_rad=screw_head_dia/2;
rect_dim=[
    actual_light_x+2min_thickness,
    triangle_cutout_y_z+min_thickness,
    triangle_cutout_y_z+min_thickness
];
screw_head_tran=[
    rect_dim.x / 2,
    rect_dim.y + screw_head_rad,
    0
];

screw_hole_rad=screw_hole_dia/2 + clearance_loose;

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
    translate([min_thickness,0,triangle_cutout_y_z]) rotate([0,90,0]) linear_extrude(actual_light_x) polygon(points=[
        [0,0],
        [triangle_cutout_y_z,0],
        [triangle_cutout_y_z,triangle_cutout_y_z],
    ]);
}


