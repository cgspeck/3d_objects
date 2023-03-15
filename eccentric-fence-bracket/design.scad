include <shared.scad>

verticle_post_xy=65 + 2clearance_loose;
horizontal_post_xy=50 + 2clearance_loose;
// sized to fit impact driver bit
screw_head_dia=14;
screw_hole_dia=4.8;
// calc
screw_head_rad = screw_head_dia / 2;
screw_hole_rad = screw_hole_dia / 2 + clearance_loose;
verticle_post_z=horizontal_post_xy * 2;

verticle_post_outer_dim=[
    verticle_post_xy + 2 * 2min_thickness,
    verticle_post_xy + 2 * 2min_thickness,
    verticle_post_z
];

verticle_post_inner_dim=[
    verticle_post_xy,
    verticle_post_xy,
    verticle_post_z + 2 * de_minimis
];

horizontal_post_outer_dim=[
    horizontal_post_xy,
    horizontal_post_xy,
    horizontal_post_xy
];

horizontal_post_inner_dim=[
    horizontal_post_xy + de_minimis,
    horizontal_post_xy + de_minimis,
    horizontal_post_xy + 2 * de_minimis
];

horizontal_post_trans=[
    (verticle_post_outer_dim.x - horizontal_post_outer_dim.x) / 2,
    verticle_post_outer_dim.y,
    verticle_post_outer_dim.z - horizontal_post_outer_dim.z - de_minimis
];


module ScrewHead(extra_head_through=0) {
    cylinder_outer(2min_thickness + 2 * de_minimis, screw_hole_rad);
    translate([0,0,-extra_head_through]) cylinder_outer(min_thickness + 1 * de_minimis + extra_head_through, screw_head_rad);
}
difference() {
    hull() {
        cube(verticle_post_outer_dim);
        translate(horizontal_post_trans) cube(horizontal_post_outer_dim);
    }
    translate([2min_thickness,2min_thickness,-de_minimis]) cube(verticle_post_inner_dim);
    translate([
        horizontal_post_trans.x,
        horizontal_post_trans.y + 0,
        horizontal_post_trans.z
    ]) cube(horizontal_post_inner_dim);
    // holes through the verticle post
    translate([-de_minimis,verticle_post_outer_dim.y/2,verticle_post_outer_dim.y/3])rotate([270,0,270]) ScrewHead();
    translate([-de_minimis,verticle_post_outer_dim.y/2,verticle_post_outer_dim.y/3*3])rotate([270,0,270]) ScrewHead();
    translate([verticle_post_outer_dim.x+de_minimis,verticle_post_outer_dim.y/2,verticle_post_outer_dim.y/3])rotate([90,0,270]) ScrewHead();
    translate([verticle_post_outer_dim.x+de_minimis,verticle_post_outer_dim.y/2,verticle_post_outer_dim.y/3*3])rotate([90,0,270]) ScrewHead();
    // holes through the horizontal post
    translate(horizontal_post_trans) translate([
        -4.8,
        horizontal_post_outer_dim.x / 2,
        horizontal_post_outer_dim.z / 2
    ])rotate([270,0,270]) ScrewHead(10);
    translate(horizontal_post_trans) translate([
        horizontal_post_outer_dim.y+4.8,
        horizontal_post_outer_dim.x / 2,
        horizontal_post_outer_dim.z / 2
    ])rotate([90,0,270]) ScrewHead(10);
}

