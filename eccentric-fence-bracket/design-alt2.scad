include <shared.scad>

verticle_post_xy=65 + 2clearance_loose;
horizontal_post_xy=50 + 2clearance_loose;
// sized to fit impact driver bit
screw_head_dia=14;
// increased from 4.8, visually looks like there is an extra 2mm,
// this is so that screws don't touch the sides of the holes
screw_hole_dia=6.5;  

ref_thickness=min_thickness;
// calc
screw_head_rad = screw_head_dia / 2;
screw_hole_rad = screw_hole_dia / 2 + clearance_loose;
verticle_post_z=horizontal_post_xy * 2;

verticle_post_outer_dim=[
    verticle_post_xy + 2 * ref_thickness,
    verticle_post_xy + 2 * ref_thickness,
    verticle_post_z
];

verticle_post_inner_dim=[
    verticle_post_xy,
    verticle_post_xy,
    verticle_post_z + 2 * de_minimis
];

// horizontal_post_outer_dim=[
//     horizontal_post_xy + 2 * ref_thickness,
//     horizontal_post_xy,
//     horizontal_post_xy
// ];
horizontal_post_outer_dim=[
    verticle_post_outer_dim.x,
    horizontal_post_xy,
    horizontal_post_xy
];

horizontal_post_inner_dim=[
    horizontal_post_xy + de_minimis,
    horizontal_post_xy + de_minimis,
    horizontal_post_xy + 2 * de_minimis
];

horizontal_post_outer_trans=[
    0,
    verticle_post_outer_dim.y,
    verticle_post_outer_dim.z - horizontal_post_outer_dim.z - de_minimis
];

horizontal_post_inner_tran_x=(verticle_post_outer_dim.x - horizontal_post_inner_dim.x) / 2;

total_x=verticle_post_outer_dim.x;
// horiz_post_x_less_vert_post_x = horizontal_post_xy - verticle_post_xy;
horiz_holder_x_thickness=(total_x - horizontal_post_xy) / 2;
echo("total_x", total_x);
echo("horiz_holder_x_thickness", horiz_holder_x_thickness);


module ScrewHead(extra_through=0, rebate_screw_head=0) {
    cylinder_outer(ref_thickness + 2 * de_minimis + extra_through, screw_hole_rad);

    if (rebate_screw_head > 0) {
        head_len = rebate_screw_head;
        translate([0,0,-head_len]) cylinder_outer(head_len, screw_head_rad);
    }
}

module EccentricBracketV2() {
    difference() {
        hull() {
            cube(verticle_post_outer_dim);
            translate(horizontal_post_outer_trans) cube(horizontal_post_outer_dim);
        }
        translate([ref_thickness,ref_thickness,-de_minimis]) cube(verticle_post_inner_dim);
        translate([
            horizontal_post_inner_tran_x,
            horizontal_post_outer_trans.y,
            horizontal_post_outer_trans.z
        ]) cube(horizontal_post_inner_dim);
        // holes through the verticle post
        translate([-de_minimis,verticle_post_outer_dim.y/2,verticle_post_outer_dim.y/3])rotate([270,0,270]) ScrewHead();
        translate([-de_minimis,verticle_post_outer_dim.y/2,verticle_post_outer_dim.y/3*3])rotate([270,0,270]) ScrewHead();
        translate([verticle_post_outer_dim.x+de_minimis,verticle_post_outer_dim.y/2,verticle_post_outer_dim.y/3])rotate([90,0,270]) ScrewHead();
        translate([verticle_post_outer_dim.x+de_minimis,verticle_post_outer_dim.y/2,verticle_post_outer_dim.y/3*3])rotate([90,0,270]) ScrewHead();
        // holes through the horizontal post
        et=0;
        rebate_screw_head=10;
        translate([
            horizontal_post_outer_trans.x - ref_thickness,
            horizontal_post_outer_trans.y,
            horizontal_post_outer_trans.z
        ]) translate([
            horizontal_post_inner_tran_x,
            horizontal_post_outer_dim.x / 2,
            horizontal_post_outer_dim.z / 2
        ])rotate([270,0,270]) ScrewHead(et, rebate_screw_head);
        translate([
            horizontal_post_outer_trans.x + 7.52,
            horizontal_post_outer_trans.y,
            horizontal_post_outer_trans.z
        ]) translate([
            horizontal_post_outer_dim.y+min_thickness*2,
            horizontal_post_outer_dim.x / 2,
            horizontal_post_outer_dim.z / 2
        ])rotate([90,0,270]) ScrewHead(et, rebate_screw_head);

        cutout_x=(total_x - 40);
        translate([
            (total_x - cutout_x) / 2,
            0,
            0
        ]) cube([
            cutout_x,
            125, 
            120
        ]);
        
    }
}

EccentricBracketV2();

translate([0, 300, 0]) mirror([0,1,0]) EccentricBracketV2();