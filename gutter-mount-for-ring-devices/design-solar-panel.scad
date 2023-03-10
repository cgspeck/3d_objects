include <shared.scad>

use_included_screws = true;
ring_bracket_hole_dx=56;
// select 3 x 16mm CSC machine screws
ring_bracket_hole_dia=3;
ring_bracket_bolt_len=16;
ring_bracket_hole_rad=ring_bracket_hole_dia/2 + clearance_loose;

// use screws which came with camera because clip blocks access to insert a nut
screw_len=20;
screw_dia_unthread=3.12 - 0.5; // allowance for self-tapping

solar_bracket_x=84;
solar_bracket_y=28;
solar_bracket_z=8;

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
        translate([ring_bracket_hole_dx / 2, 0, -panel_mount_dim.z / 2 - de_minimis]) {
            if (use_included_screws) {
                cylinder_outer(screw_len + de_minimis, screw_dia_unthread / 2);
            } else {
                NutHoleAssembly(
                    diameter=3,
                    length=ring_bracket_bolt_len,
                    nut_depth=3.6,
                    nut_mult=1,
                    bolt_head_len=0,
                    de_minimis=0.01
                );
            }

        }
        translate([-ring_bracket_hole_dx / 2, 0, -panel_mount_dim.z / 2 - de_minimis]) {
            if (use_included_screws) {
                cylinder_outer(screw_len + de_minimis, screw_dia_unthread / 2);
            } else {
                NutHoleAssembly(
                    diameter=3,
                    length=ring_bracket_bolt_len,
                    nut_depth=3.6,
                    nut_mult=1,
                    bolt_head_len=0,
                    de_minimis=0.01
                );
            }
        }

    // cut out the area where it curves
    x = -0.5;
    translate([11.1807 + 1 + (x)/2,0,0]) cube([
        7 + x,
        solar_bracket_y + 2 * de_minimis,
        solar_bracket_z + 2 * de_minimis + 8
    ], center=true);
    }
}

SolarPanelClip();