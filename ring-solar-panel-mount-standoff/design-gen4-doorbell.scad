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
    // NutHoleAssembly(
    //     solar_panel_mount_hole_dia,
    //     nut_depth=solar_panel_mount_dim.z
    // );
    translate([0,0,10]) CounterSunkScrew(3, 10, 2, 5.5);
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

ring_mount_dim=[
    62.2,
    129,
    10
];

module ring_bolt_hole() {
    translate([0,0,ring_mount_dim.z + de_minimis]) rotate([0,180,0]) NutHoleAssembly(diameter=3);
}


module ring_mount() {
    translate([
        -ring_mount_dim.x/2,
        -ring_mount_dim.y / 2, 
        ring_mount_dim.z - 6
    ]) cube([
        ring_mount_dim.x,
        ring_mount_dim.y,
        6]
    );
}

module wall_mount() {
    hull() {
        translate([0, wall_mount_hole_dy / 2, 0]) cylinder_outer(de_minimis, wall_mount_mount_dim.x);
        translate([0, -wall_mount_hole_dy / 2, 0]) cylinder_outer(de_minimis, wall_mount_mount_dim.x);
    };
}

module wall_mount_bolt_hole() {
    screw_len=10;
    csc_len=2.6;
    csc_head_dia=6.5;
    translate([0, 0, 6]) rotate([0,0,0]) CounterSunkScrew(
        wall_mount_hole_d,
        screw_len,
        csc_len,
        csc_head_dia
    );
}

ring_hole_dx = 53;
ring_hole_dy = 59.8;

ring_hole_tran_x = 4;
ring_hole_tran_y = 61.3;

translate([0,0,0]) difference() {
    hull() {
        wall_mount();
        ring_mount();
    };
    translate([0,wall_mount_hole_dy/2,0]) wall_mount_bolt_hole();
    translate([0,-wall_mount_hole_dy/2,0]) wall_mount_bolt_hole();
    // holes for the ring iteself
    translate([
        -ring_mount_dim.x / 2 + ring_hole_tran_x,
        ring_mount_dim.y / 2 - ring_hole_tran_y, 0]) {
        ring_bolt_hole();
        translate([0,-ring_hole_dy,0]) ring_bolt_hole();
        translate([ring_hole_dx,0,0]) {
            ring_bolt_hole();
            translate([0,-ring_hole_dy,0]) ring_bolt_hole();
        }
    }
    // void area for for connectors
    translate([0,0, ring_mount_dim.z - 4 + de_minimis]) {
        translate([
            -ring_mount_dim.x / 2 + 16,
            ring_mount_dim.y / 2 - 25 - 32,
            0
        ]) cube([30, 32, 4]);

        translate([
            -ring_mount_dim.x / 2 + 16,
            ring_mount_dim.y / 2 - 25 - 32 - 14,
            0
        ]) cube([30, 32, 4]);

        translate([
            -ring_mount_dim.x / 2 + 42,
            ring_mount_dim.y / 2 - 130,
            0
        ]) cube([4, 60, 4]);
    }

}
