include <shared.scad>

post_clearance_factor=clearance_loose;
post_dim=[
    50,
    50
];
fixing_hole_dia=4.2;
fixing_csc_dia=8.4;
fixing_tab_height=fixing_csc_dia *2 * 2;
bracket_base_z=fixing_tab_height;
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

fixing_tab_inner_width=25;
fixing_tab_outer_width=fixing_csc_dia;

fixing_hole_rad=fixing_hole_dia/2 + clearance_loose;


fixing_tab_dim=[
    fixing_tab_inner_width + fixing_tab_outer_width + bracket_dim.x,
    5.8,
    fixing_tab_height
];

difference() {
    linear_extrude(bracket_base_z) difference() {
        square(bracket_dim, center=true);
        square(actual_post_dim, center=true);
    };
    // to allow a 10G metalfix screw to pass through
    translate([bracket_dim.x/2 - bracket_thickness - de_minimis, 0, bracket_base_z / 2]) rotate([0,90,0]) cylinder_outer(bracket_thickness + 2 * de_minimis, 5.75 / 2);
}

translate([0,-3.41,0]) difference() {
    translate([(fixing_tab_inner_width + fixing_tab_outer_width)/ 2, -bracket_dim.y / 2 + fixing_tab_dim.y / 2, fixing_tab_dim.z / 2]) cube(fixing_tab_dim, center=true);
    translate([bracket_dim.x / 2 + fixing_tab_inner_width, -26, fixing_tab_dim.z / 4]) rotate([270,0,0])CounterSunkScrew(4.4, 100, 3.8, fixing_csc_dia);
    translate([bracket_dim.x / 2 + fixing_tab_inner_width, -26, fixing_tab_dim.z / 4 * 3]) rotate([270,0,0])CounterSunkScrew(4.4, 100, 3.8, fixing_csc_dia);
}