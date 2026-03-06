include <shared.scad>;
// rotate([270,0,0]) import("vendor/Case Raspberry 5 with noctua 4020 - top(1).stl");



nut_hole_dx=57.472 + 0.5;

module FanMountCutout() {
    cylinder_outer(height = 2.1, radius = 39/2);
    rotate([0,0,-30.3]) translate([-57.972 / 2,0,0]) cylinder_outer(height = 5, radius = 3/2 + clearance_loose);
    rotate([0,0,-27.3]) translate([57.0 / 2,0,0]) cylinder_outer(height = 5, radius = 3/2 + clearance_loose);
}

// translate([-17.8,4.8,0]) FanMountCutout();

module FanMountCutoutWithExtra() {
    cylinder_outer(height = 2.1, radius = 39/2);
    rotate([0,0,-30.3]) translate([-57.972 / 2,0,0]) cylinder_outer(height = 5, radius = 3/2 + clearance_loose);
    rotate([0,0,-30.3]) translate([-57.972 / 2,0,0]) cylinder_outer(height = 12.112, radius = METRIC_NUT_AC_WIDTHS[3] /2 + 1.2 + 1.2);
    rotate([0,0,-27.3]) translate([57.0 / 2,0,0]) cylinder_outer(height = 5, radius = 3/2 + clearance_loose);
}

trn = [
    -62,
    -36, 
    0
];

module NutHolders() {
    // cylinder_outer(height = 2.1, radius = 39/2);
    rotate([0,0,-30.3]) translate([-57.972 / 2,0,0]) difference() {
        cylinder_outer(height = 12.5, radius = METRIC_NUT_AC_WIDTHS[3] /2 + 1.2 + 1.2);
        translate([2,-6.5,2 + 3.2]) rotate([0,0,30.3]) cube([10, 15, 10]);
        translate([0,0,2 + 3.2]) cylinder_outer(height = 13, radius = METRIC_NUT_AC_WIDTHS[3] /2 + 1.2);
        cylinder_outer(height = 2, radius = 3 / 2 + clearance_loose);
        translate([0,0,2]) nutHole(3);
        translate([0,0,4]) nutHole(3);
    }
    rotate([0,0,-27.3]) translate([57.0 / 2,0,0]) difference() {
        cylinder_outer(height = 5.2, radius = METRIC_NUT_AC_WIDTHS[3] /2 + 1.2);
        // cylinder_outer(height = 5.2, radius = 3/2 + clearance_loose);
        // nutHole(3);
        cylinder_outer(height = 2, radius = 3 / 2 + clearance_loose);
        translate([0,0,2]) nutHole(3);
        translate([0,0,4]) nutHole(3);
    }
}

difference() {
    rotate([180,180,0]) import("vendor/rpi2-top_netfabb.stl");
    translate(trn) FanMountCutoutWithExtra();
    translate(trn) rotate([0,0,-30.3]) translate([-57.972 / 2,0,0]) translate([0,0,2 + 3.2]) cylinder_outer(height = 13, radius = METRIC_NUT_AC_WIDTHS[3] /2 + 1.2);
}
translate(trn) NutHolders();