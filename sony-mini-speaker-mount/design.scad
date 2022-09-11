include <shared.scad>

vesa_hole_dy = 100;
vesa_hole_dia = 4;
speaker_diameter=2.75 * inch;
speaker_rad=speaker_diameter/2;
speaker_outer_rad=speaker_rad+min_thickness;
speaker_outer_dia=speaker_outer_rad * 2;


speaker_mount_t_x=130+speaker_diameter;
echo(speaker_diameter);
echo(speaker_mount_t_x);
speaker_mount_t_z=speaker_outer_rad + 0;

join_dim=[10,60,min_thickness];

join_tran=[
    speaker_mount_t_x+30,
    -join_dim.y/2, 
    0
];

join_mid_dim=[5,60,min_thickness];

join_mid_tran=[
    speaker_mount_t_x-8,
    -join_dim.y/2, 
    0
];


module SpeakerCradle(bottom_ring_only=false) {
    cutout_trans_z=10;
    bottom_cylinder_z=10;
    intersection() {
    difference() {
        sphere(speaker_outer_rad);
        SpeakerCradleCutouts();
    }
        if (bottom_ring_only) {
            // slice for ring at bottom
            translate([0,0,-speaker_outer_rad]) cube([speaker_outer_dia, speaker_outer_dia, bottom_cylinder_z + cutout_trans_z], center=true);
        }
    }
}


module SpeakerCradleCutouts() {
    cutout_trans_z=10;
    bottom_cylinder_tran_z=-speaker_outer_rad- 5;
    bottom_cylinder_z=10 + (-speaker_outer_rad-bottom_cylinder_tran_z);
    //internal space for the speaker
    sphere(speaker_rad);
    //top of the speaker
    translate([min_thickness,0,speaker_outer_rad*1.2]) cube([speaker_outer_dia, speaker_outer_dia, speaker_outer_dia], center=true);
    //side to side where buttons are
    translate([0,0,cutout_trans_z]) cube([30, speaker_outer_dia, speaker_outer_dia], center=true);
    //back where cable breakout is
    translate([-23,0,cutout_trans_z-22]) cube([30, 30, 30], center=true);
    //the bottom, where the power switch is
    translate([0,0,bottom_cylinder_tran_z]) cylinder_outer(bottom_cylinder_z, 31/2);
}

difference() {
    multiHull() {
        translate(join_mid_tran) cube(join_mid_dim, center=false);
        translate([speaker_mount_t_x, 0, speaker_mount_t_z]) rotate([0,270,0]) SpeakerCradle(bottom_ring_only=true);
        // translate(join_tran) cube(join_dim, center=false);
        translate([0, -vesa_hole_dy/2, 0]) doughnut(min_thickness, vesa_hole_dia, vesa_hole_dia/2 + clearance_loose);
        translate([0, vesa_hole_dy/2, 0]) doughnut(min_thickness, vesa_hole_dia, vesa_hole_dia/2 + clearance_loose);
    }

    translate([speaker_mount_t_x, 0, speaker_mount_t_z]) rotate([0,270,0]) SpeakerCradleCutouts();
    translate([0, -vesa_hole_dy/2, 0]) cylinder_outer(min_thickness, vesa_hole_dia/2 + clearance_loose);
    translate([0, vesa_hole_dy/2, 0]) cylinder_outer(min_thickness, vesa_hole_dia/2 + clearance_loose);
}

translate([speaker_mount_t_x, 0, speaker_mount_t_z]) rotate([0,270,0]) SpeakerCradle();
