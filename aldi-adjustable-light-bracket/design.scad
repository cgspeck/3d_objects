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

BasePart();
