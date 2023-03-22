// modules and vars specific to this project
use <MCAD/boxes.scad>
use <MCAD/nuts_and_bolts.scad>
use <MCAD/regular_shapes.scad>
include <MCAD/units.scad>
include <helpers.scad>

start_angle=13;
desired_angle=60;

// SELECT Ramset AnkaScrew as06050wgm
// https://ramset.com.au/Product/Detail/312/WERCS-AnkaScrew-Screw-In-Anchors
// length is 50
// drill hole is 6
// fixing hole is 8
// max fixture thickness is 20
fixing_screw_dia=8;
// sized to fit 10mm impact driver bit
fixing_screw_head_dia=16;
fixing_screw_len_in_wedge=20;

// SELECT
// [Pinnacle M5 x 16mm Stainless Steel Hex Head Bolts And Nuts - 8 Pack](https://www.bunnings.com.au/pinnacle-m5-x-16mm-stainless-steel-hex-head-bolts-and-nuts-8-pack_p0087635)
// and
// [Pinnacle M5 Stainless Steel Nylon Lock Nut - 10 Pack](https://www.bunnings.com.au/pinnacle-m5-stainless-steel-nylon-lock-nut-10-pack_p1100808)
// and
// [Pinnacle M5 Stainless Steel Flat Washer - 12 Pack](https://www.bunnings.com.au/pinnacle-m5-stainless-steel-flat-washer-12-pack_p0130532)

shield_bolt_size=5;
mount_z_additional=0;
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
