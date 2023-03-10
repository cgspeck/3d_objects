include <shared.scad>

// 
// select 3 x 16mm CSC machine screws
ring_bracket_dia=69;
ring_bracket_rad=ring_bracket_dia/2;

ring_bracket_hole_dx_dy=1.4 * mm_per_inch ;
half_ring_bracket_hole_dx_dy=ring_bracket_hole_dx_dy/2;

// use screws which came with camera because clip blocks access to insert a nut
screw_len=20;
screw_dia_unthread=3.12 - 0.5; // allowance for self-tapping

echo("screw_dia_unthread", screw_dia_unthread, " mm");

ring_hole_translations=[
    [-half_ring_bracket_hole_dx_dy, -half_ring_bracket_hole_dx_dy],
    [-half_ring_bracket_hole_dx_dy, half_ring_bracket_hole_dx_dy],
    [half_ring_bracket_hole_dx_dy, half_ring_bracket_hole_dx_dy],
    [half_ring_bracket_hole_dx_dy, -half_ring_bracket_hole_dx_dy]
];

ring_bracket_hole_dx=ring_bracket_hole_dx_dy + 4 * 2;


solar_bracket_x=ring_bracket_hole_dx;
solar_bracket_y=ring_bracket_hole_dx;
solar_bracket_z=2.4;

gutter_clip_thickness=7.8;

module positioned_gutter_clip() {
    translate([0, -solar_bracket_y / 2, 5.7 + max(0, (solar_bracket_z - gutter_clip_thickness) / 2)]) rotate([270,0,0]) linear_extrude(solar_bracket_y) projection() import("lib/Gutter_Clip/files/Gutter_Clip_with_knob.stl");
}

module SolarPanelClip() {
    panel_mount_dim=[solar_bracket_x, solar_bracket_y, solar_bracket_z];
    difference() {
        union() {
            positioned_gutter_clip();
            roundedCube(panel_mount_dim, 3, sidesonly=true, center=true);
        }
        translate([0,0,-solar_bracket_z/2-de_minimis]) {
            for (t=ring_hole_translations) {
                translate(t) cylinder_outer(screw_len + de_minimis, screw_dia_unthread / 2);
            }
        }
    }
}

SolarPanelClip();