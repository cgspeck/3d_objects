use <MCAD/boxes.scad>
use <MCAD/regular_shapes.scad>
use <./grid.scad>

dx=20;
dy=20;
tube_thickness=1.6;
$fn=72 * 2;
/* [ hidden ] */
min_thickness=1.2;
2min_thickness=min_thickness*2;
de_minimus=0.01;

module TypeA(dx, dy, tube_thickness, end_cap_thickness=min_thickness) {
    inner_corner_radius=max(1.5, tube_thickness);
    outer_corner_radius=0.5;
    outer_box_dim=[dx, dy, end_cap_thickness];
    roundedBox(outer_box_dim, outer_corner_radius, true);

    inner_box_z=max(dx, dy) / 4;
    inner_box_dim=[dx - 2*tube_thickness, dy - 2*tube_thickness, inner_box_z];
    inner_box_cutout=[
        inner_box_dim.x - 2*min_thickness,
        inner_box_dim.y - 2*min_thickness,
        inner_box_z
    ];
    translate([0, 0, end_cap_thickness/2 + inner_box_z / 2 - de_minimus]) {
        difference() {
            roundedBox(inner_box_dim, inner_corner_radius, true);
            roundedBox(inner_box_cutout, inner_corner_radius, true);
        }
    }
}


module TypeB(dx, dy, tube_thickness, end_cap_thickness=min_thickness) {
    inner_corner_radius=max(1.5, tube_thickness);
    outer_corner_radius=0.5;
    outer_box_dim=[dx, dy, end_cap_thickness];
    roundedBox(outer_box_dim, outer_corner_radius, true);

    inner_box_z=max(dx, dy) / 4;
    inner_box_dim=[dx - 2*tube_thickness, dy - 2*tube_thickness, inner_box_z];
    inner_box_cutout=[
        inner_box_dim.x - 2*min_thickness,
        inner_box_dim.y - 2*min_thickness,
        inner_box_z
    ];
    corner_cutout_dim=[
        inner_corner_radius * 2,
        inner_corner_radius * 2,
        inner_box_z
    ];

    translate([0, 0, end_cap_thickness/2 + inner_box_z / 2 - de_minimus]) {
        difference() {
            roundedBox(inner_box_dim, inner_corner_radius, true);
            roundedBox(inner_box_cutout, inner_corner_radius, true);

            for(i=[0:1], j=[0:1]) {
                x=-(inner_box_dim.x / 2) + corner_cutout_dim.x / 2 + (inner_box_dim.x - corner_cutout_dim.x) * i;
                y=-(inner_box_dim.y / 2) + corner_cutout_dim.y / 2 + (inner_box_dim.y - corner_cutout_dim.y) * j;
                translate([x, y, 0]) cube(corner_cutout_dim, center=true);
            }
        }
    }
}

module TypeC(dx, dy, tube_thickness, end_cap_thickness=min_thickness) {
    inner_corner_radius=max(1.5, tube_thickness);
    outer_corner_radius=0.5;
    outer_box_dim=[dx, dy, end_cap_thickness];
    roundedBox(outer_box_dim, outer_corner_radius, true);

    inner_box_z=max(dx, dy) / 4;
    inner_box_dim=[dx - 2*tube_thickness - 2*min_thickness, dy - 2*tube_thickness - 2*min_thickness, inner_box_z];
    inner_box_cutout=[
        inner_box_dim.x - 3*min_thickness,
        inner_box_dim.y - 3*min_thickness,
        inner_box_z
    ];

    corner_cutout_x=4*min_thickness;
    corner_cutout_y=4*min_thickness;
    corner_cutout_dim=[
        corner_cutout_x,
        corner_cutout_y,
        inner_box_z
    ];

    foo_d=[
        dx - 2 * tube_thickness,
        dy - 2*tube_thickness,
        inner_box_z
    ];

    pitch_x=foo_d.x - 10 * min_thickness;
    pitch_y=foo_d.y - 10 * min_thickness;

    translate([0, 0, end_cap_thickness/2 + inner_box_z / 2 - de_minimus]) {
        difference() {
            union() {
                roundedBox(inner_box_dim, inner_corner_radius, true);
                translate([-foo_d.x / 2, -foo_d.y / 2, -inner_box_z / 2]) Grid(size=foo_d, pitch_x=pitch_x, pitch_y=pitch_y, thickness_x=1.2, thickness_y=1.2, adj_x=0, adj_y=0);
            }

            cube(inner_box_cutout, true);

            for(i=[0:1], j=[0:1]) {
                x=-((dx - corner_cutout_x)/ 2) + ((dx - corner_cutout_x)) * i;
                y=-((dy - corner_cutout_x)/ 2) + ((dy - corner_cutout_x)) * j;
                translate([x, y, 0]) cube(corner_cutout_dim, center=true);
            }
        }
    }
}

TypeA(dx, dy, tube_thickness);
