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
screw_cs_head_w=7.3;
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

actual_castor_wheel_width = castor_wheel_width + (3 * 2);
actual_castor_wheel_rad = castor_wheel_dia / 2;

box_x=castor_wheel_dia + (2 * 2min_thickness);
box_y=castor_wheel_dia + (2 * 2min_thickness);
box_z=holder_depth + 2min_thickness;

box_d=[
    box_x,
    box_y,
    box_z
];
box_tran=[
    0,
    0,
    -actual_castor_wheel_rad - 2min_thickness //-(box_z/2) - actual_castor_wheel_rad + holder_depth
];

wheel_translation=[
    0,
    0,
    0
];

echo(screw_z_offset);

difference() {
    translate(box_tran) cylinder_outer(box_d.z, box_d.x / 2);
    translate(wheel_translation) sphere(actual_castor_wheel_rad);

    translate([
        0,
        0,
        -(box_z) - actual_castor_wheel_rad + holder_depth
    ]) {
        screw_x_trans=25;
        translate([screw_x_trans, 0, 0]) CounterSunkScrew();
        translate([-screw_x_trans, 0, 0]) CounterSunkScrew();
    }
}
