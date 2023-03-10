include <shared.scad>

core_hole_dia=76;
post_dim=[50,50];
fixing_hole_dia=15;
ridge_width=3;
// calc
core_hole_rad=core_hole_dia/2 + clearance_loose;
fixing_hole_rad=fixing_hole_dia/2;
shim_height=max(fixing_hole_dia*3, post_dim.x);
mask_including_post_extra_y=30;
mask_including_post=[
    post_dim.x + 2 * ridge_width,
    post_dim.y + mask_including_post_extra_y
];
post_ridge_mask=[
    mask_including_post.x,
    post_dim.y - ridge_width
];

module Shim(play=0) {
    difference() {
        linear_extrude(shim_height) {
            difference() {
                intersection() {
                    circle_outer(core_hole_rad);
                    translate([0,mask_including_post_extra_y/2,0]) square(size=mask_including_post, center=true);
                }
                square([
                    post_dim.x + 2 + clearance_loose,
                    post_dim.y + 2 * play,
                ], center=true);
                translate([0,-ridge_width/2,0]) square(post_ridge_mask, center=true);

                if (play > 2) {
                    square([
                        core_hole_dia,
                        post_dim.y + 2 * play,
                    ], center=true);
                }
            }
        }
        translate([0,0,shim_height/2]) rotate([270,0,0]) cylinder_outer(core_hole_rad + de_minimis, fixing_hole_rad);
    }
}

module HalfShim(play=0) {
    intersection_mask_thickness=100;
    intersection() {
        Shim(play);
        union() {
            translate([-mask_including_post.x / 4 - fixing_hole_rad / 2,intersection_mask_thickness,shim_height/2]) rotate([90,0,0]) resize([mask_including_post.x / 2 - fixing_hole_rad, shim_height, 100]) cylinder_outer(100, 100);
            translate([mask_including_post.x / 4 + fixing_hole_rad / 2,intersection_mask_thickness,shim_height/2]) rotate([90,0,0]) resize([mask_including_post.x / 2 - fixing_hole_rad, shim_height, 100]) cylinder_outer(100, 100);
            cube([mask_including_post.x, intersection_mask_thickness, shim_height], center=true);
        }
    }
}

for (play=[0:3]) {
    translate([0, play * 30, 0]) {
        Shim(play);
    }
}

translate([100,0,0]) {
    for (play=[0:3]) {
        translate([0, play * 30, 0]) {
            HalfShim(play);
        }
    }
}
