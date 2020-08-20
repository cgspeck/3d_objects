/*
Customizable Remote Control Holder
by Christopher Speck

Adapted from [Parametric Remote Control Holder](https://www.thingiverse.com/thing:12632) by Robert H. Morrison (rhmorrison)

Following changes have been made:

  * set size of device being held (instead of outer size of box)
  * flexible arrangment of screw holes
  * flexible arrangementof cutouts
  * removal of triangles feature

Licensed under [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/)
*/

use <MCAD/boxes.scad>;

device_thickness = 28;
device1_width = 51;
device2_width = 51;
clearance_width = 2;
clearance_thickness = 1;
// Suggest you keep this to less then 50% of device's height
tray_height = 87;

front_cutout1_width = (device1_width / 3) * 2;
front_cutout2_width = (device2_width / 3) * 2;
front_lip_height = 10;

bottom_cutout1_width = 0; // device1_width / 2;
bottom_cutout2_width = 0; // device2_width / 2;


/* [Advanced] */
min_wall_thickness = 2.5;
screw_head_thickness = 5;
screw_diameter = 5;
// How many mm from top to have first screw hole
screw_start = 15;
screw_centers = 50;
outer_radius = 5;
inner_radius = 0;

/* [Hidden] */
$fn=32;
screw_radius = screw_diameter / 2;

module BracketHoles(outer_dim) {
    screw_hole_count = ceil((tray_height - front_lip_height - screw_start) / screw_centers);
    if (screw_hole_count>0) {
        for(i=[1:1:screw_hole_count]) {
            z = (outer_dim.z / 2) -(screw_start + (i - 1) * screw_centers);
            translate([0, (device_thickness + clearance_thickness) / 2, z]) rotate([90, 0 , 0]) cylinder(h=outer_dim.y, r=screw_radius, center=true);
        }
    }
}

module RemoteControlBracket(outer_dim, device_width, front_cutout_width, bottom_cutout_width) {
    union() {
        difference() {
            roundedBox(outer_dim, outer_radius, false);  // Holder frame

            translate([0,-(screw_head_thickness  -  min_wall_thickness )/2, min_wall_thickness / 2])
                roundedBox([(device_width + clearance_width), (device_thickness + clearance_thickness), tray_height], inner_radius, true);    // Remote Control
            translate([0,screw_head_thickness  / 2, 10])
                roundedBox([outer_dim.x/3, (device_thickness + clearance_thickness) , tray_height ], 2, true);  // Screw heads

            if (front_cutout_width > 0) {
                translate([0,-(device_thickness + clearance_thickness +screw_head_thickness  +  min_wall_thickness )/2,front_lip_height])
                    rotate([90,90,0])
                        roundedBox([ tray_height , front_cutout_width ,screw_head_thickness  ] , 2, true);  // Cut-out FRONT
            }

            //bottom cutout
            if (bottom_cutout_width > 0) {
                bottom_cutout_y = device_thickness + min_wall_thickness;
                bottom_cutout_z = min_wall_thickness + front_lip_height;

                translate([
                    0,
                    -(outer_dim.y - bottom_cutout_y) / 2,
                    -(tray_height - bottom_cutout_z) / 2 - min_wall_thickness
                ]) cube([bottom_cutout_width, bottom_cutout_y, bottom_cutout_z], center=true);
            }

            BracketHoles(outer_dim);
        }
    }
}

module Main() {
    BD = (device_thickness + clearance_thickness) + screw_head_thickness  + 2 * min_wall_thickness;
    BW = (device1_width + clearance_width) + (2 * min_wall_thickness);
    BH = tray_height + min_wall_thickness;
    RemoteControlBracket([BW, BD, BH], device1_width, front_cutout1_width, bottom_cutout1_width);

    unit2_outer_x = (device2_width + clearance_width) + (2 * min_wall_thickness);
    outer_dim_2 = [
        unit2_outer_x,
        BD,
        BH
    ];
    unit2_x_trans = (BW + outer_dim_2.x) / 2 - 2 * min_wall_thickness;
    translate([
        unit2_x_trans,
        0,
        0
    ]) RemoteControlBracket(outer_dim_2, device2_width, front_cutout2_width, bottom_cutout2_width);
}

Main();
