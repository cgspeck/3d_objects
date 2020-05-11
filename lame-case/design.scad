include <MCAD/boxes.scad>

box_bottom_internal_dimensions=[
    200,
    34,
    34
];

box_top_internal_height=6;

min_thickness=1.2;
2min_thicnkess=min_thickness*2;
corner_radius=3;

lip_height=2.4;

clearance_tight=0.2;
2clearance_tight=2*clearance_tight;

// calculated
box_bottom_external_dimension=[
    box_bottom_internal_dimensions.x + 2min_thicnkess,
    box_bottom_internal_dimensions.y + 2min_thicnkess,
    box_bottom_internal_dimensions.z + min_thickness
];

box_top_internal_dimension=[
    box_bottom_internal_dimensions.x,
    box_bottom_internal_dimensions.y,
    box_top_internal_height
];

box_top_external_dimension=[
    box_top_internal_dimension.x + 2min_thicnkess,
    box_top_internal_dimension.y + 2min_thicnkess,
    box_top_internal_height + min_thickness
];

lip_internal_dimension=[
    box_top_external_dimension.x,
    box_top_external_dimension.y,
    lip_height
];

lip_external_dimension=[
    lip_internal_dimension.x + 2min_thicnkess,
    lip_internal_dimension.y + 2min_thicnkess,
    lip_internal_dimension.z + min_thickness
];

// bottom
difference() {
    roundedBox(box_bottom_external_dimension, corner_radius, true);
    translate([0,0,min_thickness]) roundedBox(box_bottom_internal_dimensions, corner_radius, true);
}

// a V to hold the lame tool
lame_end_y=25;
lame_mid_y=15.6;
lame_mid_x=105;
// a V channel 105mm long with a gap at 30 - 65

v_xy_points=[
    [0, lame_end_y/2],
    [105, lame_mid_y/2],
    [105, lame_mid_y/2 + min_thickness],
    [0, lame_end_y/2 + min_thickness],
];

module _half_V() {
    linear_extrude(box_bottom_internal_dimensions.z * .75) {
        difference() {
            polygon(points=v_xy_points);
            translate([30, 0, 0]) square(size=[35, lame_mid_y], center=false);
        };
    };
}

module V() {
    _half_V();
    mirror([0, 1, 0]) _half_V();
}

translate([
    -box_bottom_internal_dimensions.x / 2,
    0,
    -box_bottom_internal_dimensions.z / 2
]) V();

translate([0, -60, 0]) difference() {
    hull() {
        roundedBox(box_top_external_dimension, corner_radius, true);
        translate([
            0,
            0,
            (box_top_external_dimension.z / 2) + min_thickness / 2
        ]) roundedBox(lip_external_dimension, corner_radius, true);
    }
    translate([0,0,min_thickness]) roundedBox(box_top_internal_dimension, corner_radius, true);
    translate([
        0,
        0,
        (box_top_external_dimension.z / 2) + (min_thickness)
    ]) roundedBox(lip_internal_dimension, corner_radius, true);
}
