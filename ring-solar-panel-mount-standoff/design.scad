include <MCAD/boxes.scad>
include <shared.scad>

solar_panel_mount_dim=[
    93.5,
    148,
    3
];

solar_panel_mount_hole_dx=44;
solar_panel_mount_hole_dy=86;
solar_panel_mount_hole_y_offset=9;
solar_panel_mount_hole_dia=3;

solar_panel_mount_cnr_radius=10;

module solar_panel_mount() {
    translate([0,0,solar_panel_mount_dim.z/2]) roundedCube(
        solar_panel_mount_dim, 
        solar_panel_mount_cnr_radius, 
        true,
        true
    );
}

module solar_panel_mount_bolt_hole() {
    NutHoleAssembly(
        solar_panel_mount_hole_dia,
        nut_depth=solar_panel_mount_dim.z
    );
}

wall_mount_hole_dy = 86;
wall_mount_hole_d=3;
wall_mount_hole_r=wall_mount_hole_d/2;
wall_mount_hole_pad_2_mult=2.5;
wall_mount_mount_dim=[
    wall_mount_hole_d * wall_mount_hole_pad_2_mult,
    wall_mount_hole_dy + (wall_mount_hole_d * wall_mount_hole_pad_2_mult),
    4.5
];

module wall_mount() {
    translate([0,0,wall_mount_mount_dim.z + solar_panel_mount_dim.z]) hull() {
        translate([0, wall_mount_hole_dy / 2, 0]) cylinder_outer(de_minimis, wall_mount_mount_dim.x);
        translate([0, -wall_mount_hole_dy / 2, 0]) cylinder_outer(de_minimis, wall_mount_mount_dim.x);
    };
}

module wall_mount_bolt_hole() {
    screw_len=2.2;
    csc_len=2.6;
    csc_head_dia=6.5;
    translate([0,0, 5.33]) rotate([0,180,0]) CounterSunkScrew(
        wall_mount_hole_d,
        screw_len,
        csc_len,
        csc_head_dia
    );
}

difference() {
    hull() {
        solar_panel_mount();
        wall_mount();
    };
    translate([0,0,-de_minimis]) {
        translate([0,solar_panel_mount_hole_y_offset,0]) {
            translate([-solar_panel_mount_hole_dx/2,-solar_panel_mount_hole_dy/2,0]) {
                solar_panel_mount_bolt_hole();
            };
            translate([-solar_panel_mount_hole_dx/2,solar_panel_mount_hole_dy/2,0]) {
                solar_panel_mount_bolt_hole();
            };
            translate([solar_panel_mount_hole_dx/2,-solar_panel_mount_hole_dy/2,0]) {
                solar_panel_mount_bolt_hole();
            };
            translate([solar_panel_mount_hole_dx/2,solar_panel_mount_hole_dy/2,0]) {
                solar_panel_mount_bolt_hole();
            };
        };
    };
    translate([0,wall_mount_hole_dy/2,0]) wall_mount_bolt_hole();
    translate([0,-wall_mount_hole_dy/2,0]) wall_mount_bolt_hole();
}
