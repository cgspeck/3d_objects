include <shared.scad>

screw_hole_dia=6.4;
shim_dim=[20,160];
screw_hole_rad=screw_hole_dia/2 + clearance_loose;
slit_tran_y=shim_dim.y - 60;
slit_cutout_y=slit_tran_y;


module Shim(size=0, ridges) {
    difference() {
        linear_extrude(size) {
            difference() {
                square(shim_dim);
                translate([shim_dim.x/2,slit_tran_y,0]) {
                    circle_outer(screw_hole_rad);
                    translate([0,-slit_cutout_y/2,0]) square([screw_hole_dia + 2 * clearance_loose,slit_cutout_y], center=true);
                }
                
            }
        }
    }
}

for (size=[1:2:10]) {
    echo(size);
    translate([(size -1) * 30, 0, 0]) {
        Shim(size, false);
    }
}
