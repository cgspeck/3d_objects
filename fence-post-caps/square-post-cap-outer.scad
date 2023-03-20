use <MCAD/boxes.scad>
// CONSTS
clearance_tight=0.2;
clearance_loose=0.4;
de_minimis=0.01;
min_thickness=2.4;


// VARS
post_dim=[65, 65];
cap_clearance=clearance_loose;

// CALCS
cap_thickness=min_thickness;
inner_z=min(max(post_dim.x, post_dim.y) / 3, 15);
outer_cube_rad=cap_thickness;

echo("inner_z", inner_z, "mm");

inner_dim=[
    post_dim.x + 2 * cap_clearance,
    post_dim.y + 2 * cap_clearance,
    inner_z + de_minimis
];

outer_dim=[
    inner_dim.x + 2 * cap_thickness,
    inner_dim.y + 2 * cap_thickness,
    inner_dim.z + cap_thickness
];

inner_tran=[
    (outer_dim.x - inner_dim.x) / 2,
    (outer_dim.y - inner_dim.y) / 2,
    -de_minimis
];

difference() {
    // cube(outer_dim);
    roundedCube(outer_dim, outer_cube_rad, false, false);
    translate(inner_tran) cube(inner_dim);
}