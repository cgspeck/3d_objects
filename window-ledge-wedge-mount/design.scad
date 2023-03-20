include <shared.scad>

shield_bolt_dh=75;

//calc
hyp=sqrt((mount_y * mount_y) + (mount_z_actual * mount_z_actual));
echo("hypotenuse", hyp, "mm");

fixing_bolt_1_hyp=hyp / 2 - shield_bolt_dh / 2;
fixing_bolt_2_hyp=hyp / 2 + shield_bolt_dh / 2;

echo("fixing bolt hypotenuses:")
echo(fixing_bolt_1_hyp, fixing_bolt_2_hyp);

fixing_bolt_1_z=sin(actual_angle) * fixing_bolt_1_hyp;
fixing_bolt_1_y=cos(actual_angle) * fixing_bolt_1_hyp;

fixing_bolt_2_z=sin(actual_angle) * fixing_bolt_2_hyp;
fixing_bolt_2_y=cos(actual_angle) * fixing_bolt_2_hyp;

difference() {
    rotate([90,0,0]) rotate([0,90,0]) linear_extrude(mount_x) polygon(points=mount_yz_pts);

    translate([mount_x / 2, mount_y / 2,fixing_screw_len_in_wedge]) rotate([180,0,0]) BoltHole(
        diameter=fixing_screw_dia,
        length=fixing_screw_len_in_wedge,
        extra_cap_length=mount_z_actual - fixing_screw_len_in_wedge,
        user_cap_dia=fixing_screw_head_dia + 2clearance_loose
    );

    translate([mount_x / 2, fixing_bolt_1_y, fixing_bolt_1_z]) rotate([actual_angle-180,0,0]) NutHoleAssembly(
        diameter=shield_bolt_size,
        length=50,
        nut_depth=shield_nut_depth
    );

    translate([mount_x / 2, fixing_bolt_2_y, fixing_bolt_2_z]) rotate([actual_angle-180,0,0]) NutHoleAssembly(
        diameter=shield_bolt_size,
        length=50,
        nut_depth=shield_nut_depth
    );
}


