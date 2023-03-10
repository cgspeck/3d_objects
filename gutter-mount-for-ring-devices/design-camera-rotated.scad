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


solar_bracket_x=70;
solar_bracket_y=70;
solar_bracket_z=2.4;

gutter_clip_thickness=7.8;

panel_mount_dim=[solar_bracket_x, 1.75 * mm_per_inch, solar_bracket_z];
panel_translation=[15.75,0,gutter_clip_thickness/2 - 1.5];

rotated_panel_dim=[
    1.75 * mm_per_inch,
    1.75 * mm_per_inch,
    solar_bracket_z
];
rotated_panel_translation=[
    0,
    -solar_bracket_y/2 + solar_bracket_z / 2,
    -solar_bracket_x/2 - gutter_clip_thickness - solar_bracket_z / 2
];
rotated_panel_rotation=[90,0,0];

module positioned_gutter_clip() {
    translate([0, -solar_bracket_y / 2, 5.7 + max(0, (solar_bracket_z - gutter_clip_thickness) / 2)]) rotate([270,0,0]) linear_extrude(solar_bracket_y - 3) projection() import("lib/Gutter_Clip/files/Gutter_Clip_with_knob.stl");
}

module SolarPanelClip() {
    difference() {
        union() {
            positioned_gutter_clip();
            translate(panel_translation) roundedCube(panel_mount_dim, 3, sidesonly=true, center=true);

            hull() {
                translate(panel_translation) {
                    roundedCube(rotated_panel_dim, 3, sidesonly=true, center=true);
                    translate(rotated_panel_translation) rotate(rotated_panel_rotation) roundedCube(rotated_panel_dim, 3, sidesonly=true, center=true);
                }
            }
        }

        translate(panel_translation) translate(rotated_panel_translation) rotate(rotated_panel_rotation) {
            translate([0,0, -screw_len + solar_bracket_z / 2]) {
                for (t=ring_hole_translations) {
                    translate(t) cylinder_outer(screw_len + de_minimis, screw_dia_unthread / 2);
                }
            }
        }

        // cut out the area where it curves
        x = -0.5;
        translate([
            11.1807 + 1 + (x)/2,
            0,
            -35
        ]) cube([
            7 + x,
            solar_bracket_y + 2 * de_minimis,
            solar_bracket_z + 2 * de_minimis + 80
        ], center=true);
    }
}

SolarPanelClip();