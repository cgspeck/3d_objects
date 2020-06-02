use <MCAD/boxes.scad>

min_thickness=1.2;
2min_thickness=2 * min_thickness;

castor_wheel_dia=64;
castor_wheel_width=52;

holder_depth=20;

clearance_tight=0.2;
clearance_loose=0.4;

castor_wheel_rad=castor_wheel_dia/2;

screw_len=25;
mdf_sheet_thickness=18;

screw_z_offset=screw_len - mdf_sheet_thickness - 0.5;

screw_dia=4.88;
screw_cs_head_w=7.4;
screw_cs_len=2.3;

fn=72*4;
$fn=fn;

module cylinder_outer(height,radius,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

module cone_outer(height,radius1,radius2,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r1=radius1*fudge,r2=radius2*fudge,$fn=fn);
}

module CounterSunkScrew() {
    actual_screw_dia=screw_dia + (clearance_tight * 2);
    translate([
        0,
        0,
        -screw_len + screw_z_offset
    ]) {
        cylinder_outer(screw_len, actual_screw_dia / 2);
        translate([0, 0, screw_len]) cone_outer(screw_cs_len, actual_screw_dia / 2, screw_cs_head_w /2);
        translate([0, 0, screw_len + screw_cs_len]) cylinder_outer(screw_len * 2, screw_cs_head_w / 2);;
    }
}

front_x=150;
rear_x=219;
box_y=65;
box_z=20;
radius=4;

front_dim=[front_x,radius * 2,box_z];
rear_dim=[rear_x,radius * 2,box_z];

box_tran = [
    0,
    radius,
    box_z / 2
];

difference() {
    translate(box_tran) {
        hull() {
            roundedBox(front_dim, radius, true);
            translate([
                0,
                box_y - radius * 2,
                0
            ]) roundedBox(rear_dim, radius, true);
        }
    }

    translate([
        0,
        box_y / 2,
        0
    ]) {
        screw_x_trans=60;
        translate([screw_x_trans, 0, 0]) CounterSunkScrew();
        translate([0, 0, 0]) CounterSunkScrew();
        translate([-screw_x_trans, 0, 0]) CounterSunkScrew();
    }
}
