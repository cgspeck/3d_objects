use <MCAD/boxes.scad>
use <./customizable_fan_cover.scad>

fn=72 * 4;
$fn=fn;

min_thickness=1.2;
2min_thickness=2.4;
de_minimus=0.1;

fan_cover_thickness=2min_thickness;
grill_pattern_h=fan_cover_thickness;

blockout_factor=20;

module cylinder_outer(height,radius,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);}

fan_box_dim=[130, 130, fan_cover_thickness];
fan_box_trans=[0,0, fan_box_dim.z / 2];

fan_box_outer_dim=[fan_box_dim.x + 2min_thickness, fan_box_dim.y+2min_thickness, de_minimus];
fan_box_outer_trans=[0,0, fan_box_outer_dim.z / 2];

fan_grill_dim=[120, 120, fan_cover_thickness];
fan_grill_trans=[0,0, fan_box_dim.z / 2];


filter_cylinder_inner_height=9;
filter_cylinder_inner_dia=182;
filter_cylinder_inner_rad=filter_cylinder_inner_dia / 2;
filter_cylinder_height_offset=2min_thickness;
filter_cylinder_outer_height=filter_cylinder_inner_height+filter_cylinder_height_offset;
filter_cylinder_outer_rad=filter_cylinder_inner_rad+2min_thickness;

filter_cylinder_inner_trans=[
    0,
    0,
    36 + fan_cover_thickness
];

filter_cylinder_outer_trans=[
    0,
    0,
    filter_cylinder_inner_trans.z - filter_cylinder_height_offset
];

clearance_loose=0.2;

socket_d=7.8+(clearance_loose*2);
socket_r=socket_d/2;

socket_trans=[
    0,
    -77,
    filter_cylinder_outer_trans.z - 18.1
];
socket_rot=[125,0,0];
socket_width=3;

module Shrowd() {
    union() {
        difference() {
            difference() {
                hull() {
                    roundedBox(fan_box_outer_dim, 7.5, true);
                    translate(filter_cylinder_outer_trans) cylinder_outer(filter_cylinder_outer_height, filter_cylinder_outer_rad);
                }

                hull() {
                    translate([
                        fan_box_trans.x,
                        fan_box_trans.y,
                        fan_box_trans.z + fan_box_dim.z
                    ]) roundedBox(fan_box_dim, 7.5, true);
                    translate(filter_cylinder_inner_trans) cylinder_outer(filter_cylinder_inner_height, filter_cylinder_inner_rad);
                }
            }

            translate(fan_box_trans) roundedBox([
                fan_box_dim.x - de_minimus,
                fan_box_dim.y - de_minimus,
                fan_box_dim.z + blockout_factor,
            ], 7.5, true);

            translate(socket_trans) rotate(socket_rot) cylinder_outer(socket_width, socket_r);
        }

        difference() {
            translate(fan_box_trans) roundedBox(fan_box_dim, 7.5, true);
            translate(fan_grill_trans) roundedBox([
                fan_grill_dim.x,
                fan_grill_dim.y,
                fan_grill_dim.z + blockout_factor
            ], 7.5, true);
        }
    }
}


Shrowd();
fan_cover(cover_size = 120, screw_hole_dia = 4.4, screw_hole_distance = 105, cover_h = fan_cover_thickness, grill_pattern_h = grill_pattern_h);
