include <MCAD/2Dshapes.scad>;
include <shared.scad>;

fin_a_dim = [120, 90, 80];
fin_b_dim = [150, 80, 32.5];
fin_r_side = 15;
fin_r_front = 15;

bootie_a_dim = [120, 85, 90];
bootie_b_dim = [150, 105, 50];
bootie_r_side = 30;
bootie_r_front = 30;

module section(dim, r_side, thickness = de_minimis) {
    translate([0,0, dim.z / 2]) rotate([0,90,0]) linear_extrude(height = thickness) roundedSquare([dim.z, dim.y], r_side);

    echo("dim", dim);
    translate([0,0, dim.z / 4]) rotate([0,90,0]) linear_extrude(height = thickness) square([dim.z / 2, dim.y], center=true);
}

module front_curve_section(a_dim, b_dim, f_rad) {
    c_dim = [
        f_rad + 2de_minimis,
        max(a_dim.y, b_dim.y),
        f_rad
    ];

    // echo("FOO", b_dim.z - f_rad);

    y_tran = f_rad * 2 > b_dim.z ? 0 : b_dim.z - f_rad;
    echo("y_tran", y_tran);
    translate([a_dim.x + b_dim.x - f_rad, -c_dim.y / 2, y_tran]) difference() {
        cube(c_dim);
        translate([0,-de_minimis,0]) rotate([270,0,0]) cylinder_outer(c_dim.y + 2 * de_minimis, radius = f_rad);
    }
}

module webbing(a_dim, b_dim, r_side, r_front) {
    hull() {
        section(a_dim, r_side);
        translate([a_dim.x, 0, 0]) section(a_dim, r_side);
    }

    hull() {
        translate([a_dim.x, 0, 0]) section(a_dim, r_side);
        translate([a_dim.x + b_dim.x - r_front, 0, 0]) section(b_dim, r_side);
    }

    difference() {
        hull() {
            translate([a_dim.x + b_dim.x - r_front, 0, 0]) section(b_dim, r_side);
            translate([a_dim.x + b_dim.x, 0, 0]) section(b_dim, r_side);
        }
        front_curve_section(a_dim, b_dim, r_front);
    }
}

webbing(a_dim = fin_a_dim, b_dim = fin_b_dim, r_side = fin_r_side, r_front = fin_r_front);

translate([0,200,0]) webbing(a_dim = bootie_a_dim, b_dim = bootie_b_dim, r_side = bootie_r_side, r_front = bootie_r_front);
