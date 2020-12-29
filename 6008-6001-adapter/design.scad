fn=72*4;
$fn=fn;

clearance_tight=0.2;
clearance_loose=0.4;

module cylinder_mid(height,radius,fn=fn) {
   fudge = (1+1/cos(180/fn))/2;
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

module Bearing(od, id, z, outer_clearance=0, inner_clearance=0) {
    difference() {
        cylinder_mid(z, (od / 2) + outer_clearance);
        cylinder_mid(z, (id / 2) + inner_clearance);
    }
}

// 6801: 12x21x5
// 6001: 12x28x8

translate([0, 0, 8]) rotate([0, 180, 0]) difference() {
    Bearing(28, 12, 8, 0, clearance_loose);
    Bearing(21, 12, 5, 0, clearance_loose);
}
