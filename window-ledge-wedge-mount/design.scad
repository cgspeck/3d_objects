include <shared.scad>

start_angle=13;
desired_angle=65;

fixing_screw_dia=8;
// sized to fit impact driver bit
fixing_screw_head_dia=14;
fixing_screw_len_in_wedge=20;

// SELECT
// [Pinnacle M5 x 16mm Stainless Steel Hex Head Bolts And Nuts - 8 Pack](https://www.bunnings.com.au/pinnacle-m5-x-16mm-stainless-steel-hex-head-bolts-and-nuts-8-pack_p0087635)
// and
// [Pinnacle M5 Stainless Steel Nylon Lock Nut - 10 Pack](https://www.bunnings.com.au/pinnacle-m5-stainless-steel-nylon-lock-nut-10-pack_p1100808)
// and
// [Pinnacle M5 Stainless Steel Flat Washer - 12 Pack](https://www.bunnings.com.au/pinnacle-m5-stainless-steel-flat-washer-12-pack_p0130532)

shield_bolt_size=5;
mount_z_additional=0;
shield_bolt_dh=80;
shield_nut_depth=5;

// calc
actual_angle=desired_angle-start_angle;
echo("actual_angle", actual_angle);
fixing_screw_rad=fixing_screw_dia+clearance_loose;
shield_bolt_rad=shield_bolt_size+clearance_loose;
shied_bolt_width = METRIC_NUT_AC_WIDTHS[shield_bolt_size];

mount_x=max(fixing_screw_dia * 4, shied_bolt_width * 2);
mount_y=(shied_bolt_width * 3) * 2 + (fixing_screw_dia * 2);

echo("mount_y", mount_y, "mm");

mount_z_min=tan(actual_angle) * mount_y;

echo("mount_z_min", mount_z_min, "mm");

mount_z_actual=mount_z_min + mount_z_additional;

mount_yz_pts=[
    [0,0],
    [0, mount_z_additional],
    [mount_y, mount_z_actual],
    [mount_y, 0],
];

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


