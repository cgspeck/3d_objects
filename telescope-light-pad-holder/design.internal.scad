include <BOSL2/std.scad>;
include <BOSL2/threading.scad>

fn=144*4;
$fn=fn;
clearance_tight=0.2;
clearance_loose=0.4;

min_thickness=2.4;

$slop = clearance_tight;
epsilon = 0.001;

wall_thickness = min_thickness;
scope_od = 116.57 + clearance_loose * 2;

plug_wall_thickness = 1.2 * 3;
plug_nominal_dia = scope_od + plug_wall_thickness;
plug_len = 40;
pitch = 2;

flange_dim = [200, 1.2];

module Plug() {
    diff() {
        threaded_rod(d=plug_nominal_dia, l=plug_len, pitch=pitch);
        cylinder(d=plug_nominal_dia,h=plug_len / 2, center=false);
        tag("remove") cylinder(d=scope_od,h=plug_len + epsilon * 2, center=true);
    }
}

module  Base() {
    diff() {
        // up(flange_dim.z/2) cuboid(flange_dim);
        cylinder(d=flange_dim[0], flange_dim[1]);
        cylinder(d=plug_nominal_dia + min_thickness * 2, h=plug_len / 2, center=false);
        tag("remove") up(plug_len/4) threaded_rod(d=plug_nominal_dia, l=plug_len / 2 + epsilon * 2, pitch=pitch, internal=true);
    }
}

ydistribute(flange_dim[0]) {
    xrot(180) Plug();
    Base();
}
