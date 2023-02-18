include <shared.scad>

core_hole_dia=76;
post_clearance_factor=clearance_loose;
post_dim=[
    50,
    50
];
fixing_hole_dia=4.2;
fixing_csc_dia=8.4;
bracket_base_z=post_dim.x;
bracket_thickness=min_thickness;
// calc
actual_post_dim = [
    post_dim.x + 2 * post_clearance_factor,
    post_dim.y + 2 * post_clearance_factor
];
bracket_dim=[
    actual_post_dim.x + 2 * bracket_thickness,
    actual_post_dim.y + 2 * bracket_thickness
];

fixing_tab_width=50;


// core_hole_rad=core_hole_dia/2 + clearance_loose;
fixing_hole_rad=fixing_hole_dia/2 + clearance_loose;
fixing_tab_height=fixing_csc_dia*2;

fixing_tab_dim=[
    2 * fixing_tab_width + bracket_dim.x,
    5.8,
    fixing_tab_height
];

linear_extrude(bracket_base_z) difference() {
    square(bracket_dim, center=true);
    square(actual_post_dim, center=true);
};

translate([0,-3.41,0]) difference() {
    translate([0, -bracket_dim.y / 2 + fixing_tab_dim.y / 2, fixing_tab_dim.z / 2]) cube(fixing_tab_dim, center=true);
    translate([-bracket_dim.x / 2 - fixing_tab_width / 2, -26, fixing_tab_dim.z / 2]) rotate([270,0,0]) CounterSunkScrew(4.4, 100, 3.8, fixing_csc_dia); //cylinder_outer(100, fixing_hole_rad);
    translate([bracket_dim.x / 2 + fixing_tab_width / 2, -26, fixing_tab_dim.z / 2]) rotate([270,0,0])CounterSunkScrew(4.4, 100, 3.8, fixing_csc_dia);
}