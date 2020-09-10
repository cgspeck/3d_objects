use <MCAD/boxes.scad>

min_thickness=3;
fn=72*4;
$fn=fn;

module cylinder_mid(height,radius,fn=fn){
   fudge = (1+1/cos(180/fn))/2;
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

set_x_spacing=[
    0,
    25,
    50
];

set_y_spacing=[
    0,
    20,
    40
];


module cylinder_set(base_dia) {
    base_r=base_dia / 2;
    2_0m_r=base_r + 2;
    2_5m_r=base_r + 2.5;

    translate([set_x_spacing[0], 0, 0]) cylinder_mid(min_thickness, base_r);
    translate([set_x_spacing[1], 0, 0]) cylinder_mid(min_thickness, 2_0m_r);
    translate([set_x_spacing[2], 0, 0]) cylinder_mid(min_thickness, 2_5m_r);
}
base_dim=[
    80,
    70,
    min_thickness
];
difference() {
    translate([
        base_dim.x / 2 - 15,
        base_dim.y / 2 - 15,
        base_dim.z / 2
    ]) roundedBox(base_dim, 3, true);
    translate([0, set_y_spacing[0], 0]) cylinder_set(6);
    translate([0, set_y_spacing[1], 0]) cylinder_set(8);
    translate([0, set_y_spacing[2], 0]) cylinder_set(9);
}
