use <MCAD/regular_shapes.scad>

cap_od=24.5;
cap_z=2.2;

socket_z=4.3;

min_thickness=2.4;
fn=72 * 4;
$fn=fn;

module cylinder_outer(height,radius,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

module BraceCap(socket_od) {
    cylinder_outer(cap_z, cap_od / 2);
    socket_r=socket_od / 2;
    difference() {
        cylinder(r=socket_r, h=socket_z + cap_z);
        cylinder(r=socket_r - min_thickness, h=socket_z + cap_z);
    }
}

BraceCap(18);
