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

filter_holder_wall_thickness = 2;
thread_area = 1.2 * 3;

tube_wall_thickness = 1.2 * 2;
// thread_area
// base_thread_outer_diameter = scope_od + tube_wall_thickness * 2 + clearance_loose * 2 + filter_holder_wall_thickness * 2;
base_thread_outer_diameter = scope_od + 
    (clearance_loose * 2)
    + thread_area
    + (filter_holder_wall_thickness * 2)
    + (clearance_loose * 2)
    * (tube_wall_thickness * 2);

tube_outer_diameter = base_thread_outer_diameter +
    (tube_wall_thickness * 2);

tube_inner_inner_diameter = scope_od + (clearance_loose * 2);

base_thread_inner_diameter = 
    tube_inner_inner_diameter
    + (clearance_loose * 2)
    + (filter_holder_wall_thickness * 2);

plug_wall_thickness = 1.2 * 1.5;
plug_nominal_dia = base_thread_outer_diameter + plug_wall_thickness * 2;
plug_len = 50;
pitch = 2;

flange_dim = [200, 1.2];

module Tube() {
    internal_thread_len=plug_len * 2/3;
    diff() {
        cylinder(d=tube_outer_diameter,h=plug_len, center=false);
        tag("remove") up(internal_thread_len / 2) threaded_rod(d=base_thread_outer_diameter, l=internal_thread_len, pitch=pitch, internal=true);
        tag("remove") up(plug_len / 2) cylinder(d=tube_inner_inner_diameter,h=plug_len + epsilon * 2, center=true);
    };
    up(plug_len / 2) tube(plug_len, id=tube_inner_inner_diameter, wall=filter_holder_wall_thickness);
}

module Base() {
    diff() {
        cylinder(d=flange_dim[0], flange_dim[1]);
        up(plug_len/4) threaded_rod(d=base_thread_outer_diameter, l=plug_len / 2 + epsilon * 2, pitch=pitch, internal=false);
        tag("remove") down(plug_len / 4) cylinder(d=base_thread_inner_diameter, plug_len);
    }
}

ydistribute(flange_dim[0]) {
    up(plug_len) xrot(180) Tube();
    Base();
}
