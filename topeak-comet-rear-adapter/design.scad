include <shared.scad>

comet_bolt_d = 5;
comet_x_min = 55;
comet_y = 15;
comet_intf_dx = 43.40;
comet_intf_rad = 2.5;

topeak_bolt_d = 4;
topeak_bolt_dx = 50;
topeak_bolt_z = comet_y;

topeak_x = topeak_bolt_dx * 1.25;

comet_pts = [
    [-topeak_x/2, 0],
    [topeak_x/2, 0],
    [topeak_x/2, comet_y],
    [-topeak_x/2, comet_y],
];

difference() {
    union() {
        translate([0,-comet_y / 2,0]) linear_extrude(topeak_bolt_z) polygon(points=comet_pts);
        translate([0,0,1]) {
            translate([-comet_intf_dx/2,comet_y/2,0]) rotate([90,0,0]) cylinder_outer(comet_y, comet_intf_rad);
            translate([comet_intf_dx/2,comet_y/2,0]) rotate([90,0,0]) cylinder_outer(comet_y, comet_intf_rad);
        }
    }
    NutHoleAssembly(comet_bolt_d, nut_depth=3.4);

    translate([0, -comet_y / 2, topeak_bolt_z / 2]) {
        translate([-topeak_bolt_dx/2,0,0]) rotate([270,0,0]) NutHoleAssembly(topeak_bolt_d, nut_depth=3.4);
        translate([topeak_bolt_dx/2,0,0]) rotate([270,0,0]) NutHoleAssembly(topeak_bolt_d, nut_depth=3.4);
    };
}

