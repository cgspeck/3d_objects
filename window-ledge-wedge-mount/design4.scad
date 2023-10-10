include <shared.scad>

shield_bolt_dh=70;
back_edge_dist=100;
front_edge_dist=(back_edge_dist - mount_y);
back_edge_height=tan(actual_angle) * back_edge_dist;
front_edge_height=tan(actual_angle) * front_edge_dist;
// override:
echo("back_edge_height", back_edge_height, "mm");
mount_z_actual_22=back_edge_height + mount_z_additional;
mount_z_22_start=front_edge_height + mount_z_additional;

mount_yz_pts_22=[
    [0, 0],
    [0, mount_z_22_start],
    [mount_y, mount_z_actual_22],
    [mount_y, 0],
];


//calc
hyp=sqrt((mount_y * mount_y) + (mount_z_actual * mount_z_actual));
echo("hypotenuse", hyp, "mm");

shield_bolt_1_hyp=hyp / 2 - shield_bolt_dh / 2;
shield_bolt_2_hyp=hyp / 2 + shield_bolt_dh / 2;

echo("fixing bolt hypotenuses:")
echo(shield_bolt_1_hyp, shield_bolt_2_hyp);

shield_bolt_1_z=sin(actual_angle) * shield_bolt_1_hyp + front_edge_height;
shield_bolt_1_y=cos(actual_angle) * shield_bolt_1_hyp;

shield_bolt_2_z=sin(actual_angle) * shield_bolt_2_hyp + front_edge_height;
shield_bolt_2_y=cos(actual_angle) * shield_bolt_2_hyp;
shield_nut_height=4.85;

nut_slot_clearance=clearance_tight * -0.5;
clearance_slot_height=clearance_tight * 1.0;
shield_nut_depth=3.25;
nut_mult=3;

difference() {
    rotate([90,0,0]) rotate([0,90,0]) linear_extrude(mount_x) polygon(points=mount_yz_pts_22);

    translate([mount_x / 2, mount_y / 2,fixing_screw_len_in_wedge]) rotate([180,0,0]) BoltHole(
        diameter=fixing_screw_dia,
        length=fixing_screw_len_in_wedge,
        extra_cap_length=mount_z_actual_22 - fixing_screw_len_in_wedge,
        user_cap_dia=fixing_screw_head_dia + 2clearance_loose,
        tolerance=0.40
    );

    // module NutHoleAssembly(
//     diameter=5,
//     length=20,
//     nut_depth=2.4,
//     nut_mult=1,
//     bolt_head_len=0,
//     de_minimis=0.01
// ) {

    translate([mount_x / 2, shield_bolt_1_y, shield_bolt_1_z]) rotate([actual_angle-180,0,0]) NutHoleAssembly(
        diameter=shield_bolt_size,
        length=70,
        nut_mult=nut_mult,
        nut_depth=shield_nut_depth
    );

    translate([mount_x / 2, shield_bolt_2_y, shield_bolt_2_z]) rotate([actual_angle-180,0,0]) NutHoleAssembly(
        diameter=shield_bolt_size,
        length=70,
        nut_mult=nut_mult,
        nut_depth=shield_nut_depth
    );
}


