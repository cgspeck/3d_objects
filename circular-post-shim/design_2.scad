include <shared.scad>

core_hole_dia=76;
post_dim=[50,50];
fixing_hole_dia=15;
ridge_width=3;
// calc
core_hole_rad=core_hole_dia/2 + clearance_loose;
fixing_hole_rad=fixing_hole_dia/3;
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

difference() {
    linear_extrude(shim_height) {
        difference() {
            intersection() {
                circle_outer(core_hole_rad);
                translate([0,mask_including_post_extra_y/2,0]) square(size=mask_including_post, center=true);
            }
            square(post_dim, center=true);
            translate([0,-ridge_width/2,0]) square(post_ridge_mask, center=true);
        }
    }
    translate([0,0,shim_height/2]) rotate([270,0,0]) cylinder_outer(core_hole_rad + de_minimis, fixing_hole_rad);
}
