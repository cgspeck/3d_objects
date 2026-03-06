include <shared.scad>

vise_x=4 * inch;

die_z=20;
ring_dia=8;
space_dia=ring_dia + 2;
space_rad=space_dia/2;

thickness=min_thickness;

dim_outer_vise=[
    vise_x + 2clearance_loose + 2 * thickness,
    3 * thickness,
    die_z + clearance_loose + thickness
];

dim_inner_vise=[
    vise_x + 2clearance_loose,
    2 * thickness,
    die_z + clearance_loose
];

dim_area_around_vise_insert=[
    12 + 12 + space_rad,
    space_rad,
    dim_outer_vise.z
];

module PartA () {
    difference() {
        union() {
            cube(dim_outer_vise);
            translate([
                dim_outer_vise.x / 2,
                dim_outer_vise.y,
                0
            ]) cylinder_outer(dim_outer_vise.z, space_rad);
        };
        translate([thickness,0,0]) cube(dim_inner_vise);
    };
}

module PartB () {
    difference() {
        union() {
            cube(dim_outer_vise);
            translate([
                dim_outer_vise.x / 2 - dim_area_around_vise_insert.x / 2,
                dim_outer_vise.y,
                0
            ]) cube(dim_area_around_vise_insert);
        };
        translate([thickness,0,0]) cube(dim_inner_vise);
        translate([
            dim_outer_vise.x / 2,
            dim_outer_vise.y + space_rad,
            0
        ]) cylinder_outer(dim_outer_vise.z, space_rad);
    };
}


PartA();

translate([0,50,0]) PartB();