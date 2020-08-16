inch = 25.4;
min_thickness = 2.4;
de_minimus = 0.1;

lower_x = (3 + 12/16) * inch;
echo("lower_x", lower_x);
upper_x = (1 + 15/16) * inch;
echo("upper_x", upper_x);
echo("lower_x - upper_x", (lower_x - upper_x));
base_y = (2 + 3/4) * inch;
base_z = (7/8) * inch;

screw_dia = 4.5;
screw_head_dia = 8.4;

mid_hole_dia = 11.5;

echo("base z", base_z);

base_upper_x_offset = (15/16) * inch;
echo("base_upper_x_offset", base_upper_x_offset);
echo("lower_x - upper_x - base_upper_x_offset", (lower_x - upper_x - base_upper_x_offset));
base_dim_1=[lower_x, base_y, de_minimus];
base_dim_2=[upper_x, base_y, de_minimus];
base_2_trans=[
    base_upper_x_offset,
    0,
    base_z - de_minimus
];

holes_y_offsets=[
    (3/4) * inch,
    (2 +  1/8) * inch
];

// calc & constants
fn=72*3;
$fn=fn;

clearance_loose=0.2;
clearance_tight=0.4;

screw_rad = screw_dia / 2 + clearance_loose;
screw_head_rad = screw_head_dia / 2 + clearance_loose;
mid_hole_rad = mid_hole_dia / 2;
mid_hole_x_trans = (1 + 11/16) * inch;

module cylinder_outer(height,radius,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

module Base() {
    hull() {
        cube(base_dim_1);
        translate(base_2_trans) cube(base_dim_2);
    }
}

module ScrewAssembly() {
    translate([0,0,de_minimus]) {
        translate([
            0,
            0,
            -13
        ]) cylinder_outer(20 - de_minimus, screw_head_rad);
        translate([
        0,
        0,
        -10
        ]) cylinder_outer(20 + de_minimus, screw_rad);
    }
}

module Holes() {
    translate([
        11.91,
        // holes_y_offsets[0],
        0,
        11.13
    ]) rotate([
        0,
        46.94 - 90,
        0
    ]) translate([
        0,
        0,
        -10
    ]) ScrewAssembly();

    translate([
        mid_hole_x_trans,
        // holes_y_offsets[0],
        0,
        11.13
    ]) rotate([
        0,
        0,
        0
    ]) translate([
        0,
        0,
        -20
    ]) cylinder_outer(40, mid_hole_rad);

    translate([
        (upper_x + base_upper_x_offset) + 11.1125,
        // holes_y_offsets[0],
        0,
        11.13
    ]) rotate([
        0,
        45 - 0,
        0
    ]) translate([
        0,
        0,
        -10
    ]) ScrewAssembly();
}

difference() {
    Base();

    for (i=holes_y_offsets) {
        translate([0, i, 0]) Holes();
    }
}

