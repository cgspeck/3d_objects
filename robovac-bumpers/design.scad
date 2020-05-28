use <MCAD/boxes.scad>

fn=72*3;
$fn=fn;
min_thickness=1.2;
clearance_loose=0.4;
leg_diameter=19.05;
leg_len=20;
clip_thickness=2.4;

foot_dia=29.10;
foot_len=35;
foot_clip_percentage=0.50;

leg_clip_percentage=0.70;
// leg_radius=leg_diameter/2;
i=0;

module cylinder_outer(height,radius,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

// wedged ver
module Clip(diameter, length, percentage, mode="normal") {
    inner_radius= (diameter / 2) + clearance_loose;
    outer_radius= inner_radius + clip_thickness;
    difference() {
        hull() {
            translate([-outer_radius, -outer_radius, 0]) cube([outer_radius * 2, 1.2, length]);
            if (mode=="normal") {
                difference() {
                    cylinder_outer(length, outer_radius);
                    cylinder_outer(length, inner_radius);
                    y_tran=-outer_radius + (percentage * 2 * outer_radius);
                    translate([-outer_radius, y_tran, 0]) cube([outer_radius * 2, outer_radius * 2, length]);
                }
            }

        }
        cylinder_outer(length, inner_radius);
    }
}


rotate([90, 0, 0]) Clip(leg_diameter, leg_len, leg_clip_percentage);
// translate([0, foot_len, 0]) rotate([90, 0, 0]) Clip(foot_dia, foot_len, foot_clip_percentage);

outer_shell_z=80;
box_inner_dim=[
    foot_dia + 2 * min_thickness,
    leg_len+foot_len + 2 * min_thickness,
    outer_shell_z - min_thickness
];
box_outer_dim=[
    box_inner_dim.x + 2 * min_thickness,
    box_inner_dim.y + 2 * min_thickness,
    box_inner_dim.z + min_thickness
];

box_corner_rad=5;

module OuterShell() {
    difference() {
        roundedBox(box_outer_dim, box_corner_rad, true);
        translate([
            0,
            0,
            min_thickness
        ]) roundedBox(box_inner_dim, box_corner_rad, true);
        // cutout for leg
        translate([
            0,
            -(foot_len + leg_len + 3 * min_thickness) / 2,
            (outer_shell_z / 2) - 10
        ]) rotate([90, 0, 0]) roundedBox([
            leg_diameter + clearance_loose * 2,
            leg_diameter + clearance_loose * 2 + 10,
            min_thickness * 2
        ], 3, true);
    }
}

outer_shell_tran=[
    0,
    (foot_len - leg_len) / 2,
    -(outer_shell_z / 2) + foot_dia / 2 - 0.5
];

translate(outer_shell_tran) OuterShell();

hull() {
    shell_iface_x=leg_diameter + 2 * (clip_thickness + clearance_loose);
    shell_iface_tran=[
        -shell_iface_x / 2,
        -leg_len - clip_thickness,
        -shell_iface_x * 1.5
    ];
    translate(shell_iface_tran) cube([shell_iface_x, 1.2, shell_iface_x]);
    rotate([90, 0, 0]) Clip(leg_diameter, leg_len, leg_clip_percentage, mode="interface");
}

