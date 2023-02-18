include <shared.scad>

core_hole_dia=76;
post_dim=[50,50];
fixing_hole_dia=12;
// calc
core_hole_rad=core_hole_dia/2 + clearance_loose;
fixing_hole_rad=fixing_hole_dia/3;
shim_height=max(fixing_hole_dia*3, post_dim.x);
mask_including_post_extra_y=30;
mask_including_post=[
    post_dim.x,
    post_dim.y + mask_including_post_extra_y
];

difference() {
    linear_extrude(shim_height) {
        difference() {
            intersection() {
                circle_outer(core_hole_rad);
                translate([0,mask_including_post_extra_y/2,0]) square(size=mask_including_post, center=true);
            }
            square(post_dim, center=true);
        }
    }
    // module CounterSunkScrew(screw_dia, screw_len, csc_len, csc_head_dia, screw_z_offset=de_minimis)
    // CounterSunkScrew(4.4, 100, 3.8, 8.4);
    // translate([0,0,shim_height/2]) rotate([270,0,0]) cylinder_outer(core_hole_rad + de_minimis, fixing_hole_rad);
}
