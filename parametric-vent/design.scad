include <shared.scad>

vent_hole_dim=51;
fin_z=10;
fin_y_interval=7.5;
fin_thickness=min_thickness/2;
lockring_thickness=min_thickness;
// 
plug_od=vent_hole_dim-clearance_tight;
plug_id=plug_od-min_thickness;
bezel_id=plug_id;
bezel_od=bezel_id+10;
bezel_thickness=min_thickness;
plug_thickness=fin_z - bezel_thickness + lockring_thickness;

module PlugBody() {
    doughnut(bezel_thickness, bezel_od/2, bezel_id/2);
    translate([0,0,bezel_thickness]) doughnut(plug_thickness, plug_od/2, plug_id/2);
}

module Fins() {
    intersection() {
        cylinder_outer(bezel_thickness + plug_thickness, plug_od / 2);
        for (y_pos=[-fin_y_interval:fin_y_interval:plug_id+2*fin_y_interval]) {
           translate([-plug_id/2,-plug_id/2 + y_pos,0]) rotate([45,0,0]) cube([plug_id, fin_thickness, fin_z]);
        }
    }
}

module InsectScreenLockRing() {
    ring_od=plug_id / 2;
    doughnut(min_thickness, ring_od, ring_od - min_thickness);
}

Fins();
PlugBody();

translate([bezel_od,0,0]) InsectScreenLockRing();