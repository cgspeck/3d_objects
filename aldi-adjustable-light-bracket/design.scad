use <MCAD/boxes.scad>
use <universaljoint3.scad>
fn=72*4;
$fn=fn;

clearance_tight=0.2;
clearance_loose=0.4;

module cylinder_mid(height,radius,fn=fn) {
   fudge = (1+1/cos(180/fn))/2;
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

module cylinder_outer(height,radius,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

joint_hole=5 + clearance_loose;
joint_dia=15;
joint_len=20;
shaft_dia=0;
sleeve_dia=25;
sleeve_len=16;

fastener_hole=0;

// UniversalJoint3(part=0, joint_hole=joint_hole, joint_dia=joint_dia, joint_len=joint_len, sleeve_dia1=sleeve_dia, sleeve_len1=sleeve_len, shaft_dia1=shaft_dia, sleeve_dia2=sleeve_dia, sleeve_len2=sleeve_len, shaft_dia2=shaft_dia, fastener_hole=fastener_hole, ry=0, rz=0);

module CenteredJoint() {
    translate([0,0,sleeve_dia]) UniversalJoint3(part=2, joint_hole=joint_hole, joint_dia=joint_dia, joint_len=0, sleeve_dia1=sleeve_dia, sleeve_len1=sleeve_len, shaft_dia1=shaft_dia, sleeve_dia2=sleeve_dia, sleeve_len2=sleeve_len, shaft_dia2=shaft_dia, fastener_hole=fastener_hole, ry=270, rz=0);
}

module JoinerPart() {
    UniversalJoint3(part=3, joint_hole=joint_hole, joint_dia=joint_dia, joint_len=joint_len, sleeve_dia1=sleeve_dia, sleeve_len1=sleeve_len, shaft_dia1=shaft_dia, sleeve_dia2=sleeve_dia, sleeve_len2=sleeve_len, shaft_dia2=shaft_dia, fastener_hole=fastener_hole, ry=270, rz=0);
}


module BasePart() {
    hole_dia=4.2+clearance_loose;
    base_dim=[
        50,
        50,
        2
    ];
    CenteredJoint();
    difference() {
        roundedCube(base_dim, 3, sidesonly=true, center=true);
        translate([
            (base_dim.x / 2) - hole_dia * 1.5,
            0,
            - base_dim.z/2
        ]) {
            translate([
                0,
                - (base_dim.y / 2) + hole_dia * 1.5,
                0
            ]) cylinder_outer(base_dim.z, hole_dia/2);
            translate([
                0,
                (base_dim.y / 2) - hole_dia * 1.5,
                0
            ]) cylinder_outer(base_dim.z, hole_dia/2);
        };

        translate([
            -(base_dim.x / 2) + hole_dia * 1.5,
            0,
            - base_dim.z/2
        ]) {
            translate([
                0,
                - (base_dim.y / 2) + hole_dia * 1.5,
                0
            ]) cylinder_outer(base_dim.z, hole_dia/2);
            translate([
                0,
                (base_dim.y / 2) - hole_dia * 1.5,
                0
            ]) cylinder_outer(base_dim.z, hole_dia/2);
        }
    }
}

module LightPart() {
    hole_dia=4.2+clearance_loose;
    mount_dim=[
        78,
        40,
        2.4
    ];
    bracket_outer_dx=64;
    bracket_inner_dx=58.5;
    bracket_dy=30-2.5;
    cutout_dim=[
        bracket_outer_dx - bracket_inner_dx,
        bracket_dy,
        mount_dim.z
    ];
    CenteredJoint();
    difference() {
        roundedCube(mount_dim, 3, sidesonly=true, center=true);
        translate([
            (bracket_inner_dx / 2) - clearance_tight + cutout_dim.x / 2,
            (mount_dim.y - cutout_dim.y) / 2,
            0
        ]) {
            cube(cutout_dim, center=true);
        };
        translate([
            -(bracket_inner_dx / 2) + clearance_tight - cutout_dim.x / 2,
            (mount_dim.y - cutout_dim.y) / 2,
            0
        ]) {
            cube(cutout_dim, center=true);
        };
    }
}

solar_panel_y=68;

module positioned_gutter_clip() {
    translate([16, -solar_panel_y / 2, 5.7]) rotate([270,0,0]) linear_extrude(solar_panel_y) projection() import("lib/Gutter_Clip/files/Gutter_Clip_with_knob.stl");
}

module SolarPanelClip() {
    panel_mount_dim=[49, solar_panel_y, 2.4];
    hole_dia=3+clearance_loose;
    hole_dx=27;
    hole_dy=45;
    difference() {
        union() {
            positioned_gutter_clip();
            roundedCube(panel_mount_dim, 3, sidesonly=true, center=true);
        }
        translate([hole_dx / 2, 0, -panel_mount_dim.z / 2]) {
            translate([0, hole_dy / 2, 0]) {
                cylinder_outer(panel_mount_dim.z + 10, hole_dia/2);
            }
            translate([0, -hole_dy / 2, 0]) {
                cylinder_outer(panel_mount_dim.z + 10, hole_dia/2);
            }
        }
        translate([-hole_dx / 2, 0, -panel_mount_dim.z / 2]) {
            translate([0, hole_dy / 2, 0]) {
                cylinder_outer(panel_mount_dim.z, hole_dia/2);
            }
            translate([0, -hole_dy / 2, 0]) {
                cylinder_outer(panel_mount_dim.z, hole_dia/2);
            }
        }
    }
}

BasePart();

translate([80, 0, 0]) JoinerPart();

translate([0, 50, 0]) LightPart();

translate([80, 50, 0]) SolarPanelClip();
