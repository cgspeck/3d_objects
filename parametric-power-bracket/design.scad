include <shared.scad>

// Gaming monitor power brick
// box_x=172;
// box_y=73;
// box_z=40;

// Creative T30 Speakers power brick
box_x=117;
box_y=49;
box_z=36.1;

lip_z=5;

min_bridge_width=15;

// designed around rough measurements of a #8 screw
screw_dia=4.2 + clearance_loose;
csc_head_dia=7.2 + clearance_loose;
csc_len=2.3;

width_factor=2;

// [Hidden]
screw_len=3;
actual_box_dim=[
    box_x + 2clearance_loose,
    box_y,
    box_z + lip_z + 2clearance_loose
];

csc_plate_dim=[
    csc_head_dia * width_factor + 2clearance_loose,
    csc_len,
    max(min_bridge_width + min_thickness, csc_head_dia * width_factor + 2clearance_loose)
];

post_dim=[
    min_thickness,
    actual_box_dim.z,
    csc_plate_dim.z
];

bridge_dim=[
    actual_box_dim.y + 2min_thickness,
    min_thickness,
    csc_plate_dim.z
];

bridge_translation=[
    csc_plate_dim.x,
    post_dim.y,
    0
];

lip_dim=[
    bridge_dim.x,
    lip_z,
    min_thickness
];
lip_translation=[
    bridge_translation.x,
    bridge_translation.y - lip_dim.y,
    bridge_translation.z
];

2nd_post_translation=[csc_plate_dim.x + bridge_dim.x - min_thickness ,0,0];
2nd_plate_translation=[
    2nd_post_translation.x + post_dim.x,
    2nd_post_translation.y,
    2nd_post_translation.z
];

csc_trans_1=[csc_plate_dim.x/2,0,csc_plate_dim.z/2];
csc_trans_2=[
    csc_trans_1.x + bridge_dim.x + csc_plate_dim.x,
    csc_trans_1.y,
    csc_trans_1.z
];

difference() {
    union() {
        cube(csc_plate_dim);
        translate([csc_plate_dim.x,0,0]) cube(post_dim);
        translate(bridge_translation) cube(bridge_dim);
        translate(2nd_post_translation) cube(post_dim);
        translate(2nd_plate_translation) cube(csc_plate_dim);
        translate(lip_translation) cube(lip_dim);
    }

    translate(csc_trans_1) rotate([270,0,0]) CounterSunkScrew(screw_dia, screw_len, csc_len, csc_head_dia);
    translate(csc_trans_2) rotate([270,0,0]) CounterSunkScrew(screw_dia, screw_len, csc_len, csc_head_dia);
}

