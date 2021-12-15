include <helpers.scad>
include <shared.scad>

plug_part_len=11;
plug_part_od=91;

scope_od=96;
scope_id=plug_part_od;

shield_len=60;

plug_part_or = (plug_part_od / 2);
plug_part_ir = plug_part_or - min_thickness;

scope_or = scope_od / 2;
scope_ir = scope_id / 2;

transition_len=(scope_ir - plug_part_ir) * 2;

doughnut(
    plug_part_len,
    plug_part_or,
    plug_part_ir
);

translate([
    0,
    0,
    plug_part_len
]) {
    difference() {
        cylinder_outer(transition_len,scope_or);
        translate([
            0,
            0,
            -de_minimis
        ]) cone_outer(
            transition_len + 2*de_minimis,
            plug_part_ir,
            scope_ir
        );
    }
}


translate([
    0,
    0,
    plug_part_len
]) doughnut(
    shield_len,
    scope_or,
    scope_ir
);