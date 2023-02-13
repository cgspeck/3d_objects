include <shared.scad>

core_hole_dia=76;
marker_tip_dia=2.8;

x_marker_d=111;
y_marker_d=111;

marker_width=20;
marker_rad=1.5;

b_thickness=2.4;
t_thickness=2.4;

b_len=40;

//calc
total_x=x_marker_d + (2 * marker_rad) + (2 * marker_rad);
total_y=y_marker_d + t_thickness;

module marker(oversized=false, thickness=b_thickness) {
    x = oversized ? marker_width * 2 : marker_width;
    roundedCube([
        x, 
        marker_rad * 2, 
        thickness],
        marker_rad,
        true
    );
}

module t_section(base_only=true) {
    z = base_only ? b_thickness : b_len;
    translate([0,-b_thickness,0]) roundedCube([
            total_x, b_thickness, z
        ],
        b_thickness / 2,
        true
    );
}

difference() {
    union() {
        difference() {
            hull() {
                // furthest marker
                translate([
                    total_x/2 - marker_width / 2,
                    total_y - marker_rad * 2,
                    0
                ]) marker();
                // outside side markers
                translate([
                    marker_rad * 2,
                    total_y / 2 - (marker_width * 2) / 2,
                    0
                ]) rotate([0,0,90]) marker(true);
                translate([
                    total_x,
                    total_y / 2 - (marker_width * 2) / 2,
                    0
                ]) rotate([0,0,90]) marker(true);
                
                t_section(true);
            }
            translate([0, 0, -de_minimis]) {
                // tracing line
                translate([total_x / 2, y_marker_d / 2,0]) cylinder_outer(
                    b_thickness + 2 * de_minimis,
                    (core_hole_dia + marker_tip_dia * 2) / 2
                );
                // x markers
                translate([
                    (marker_rad * 2) * 2,
                    total_y / 2 - (marker_width) / 2,
                    0
                ]) rotate([0,0,90]) marker(false, b_thickness + de_minimis * 2);

                translate([
                    total_x - (marker_rad * 2),
                    total_y / 2 - (marker_width) / 2,
                    0
                ]) rotate([0,0,90]) marker(false, b_thickness + de_minimis * 2);
            }
        }

        translate([0, 0, 0]) {
            translate([total_x / 2, y_marker_d / 2,0]) {
                cylinder_outer(b_thickness, (core_hole_dia) / 2);
                translate([-5,0,0]) cube([10, 50, b_thickness]);
            }
        }
    }
    // V marker
    translate([0, 0, 0]) translate([0, 0, -de_minimis]) {
        translate([
            total_x / 2 + marker_tip_dia / 2,
            total_y / 2 - marker_tip_dia / 2 - 0.58,
            0
        ]) rotate([0,0,45]) roundedCube([
            10,
            marker_tip_dia,
            b_thickness + 2 * de_minimis
        ], marker_tip_dia / 2, true);
        translate([
            total_x / 2,
            total_y / 2 - marker_tip_dia / 2,
            0
        ]) roundedCube([
            10,
            marker_tip_dia,
            b_thickness + 2 * de_minimis
        ], marker_tip_dia / 2, true);
    }
}

t_section(false);

// check lines
// translate([total_x/2 - 0.5,0,0]) color("red") cube([1, total_y, 5]);
// translate([0,total_y / 2 - 0.5,0]) color("red") cube([total_x, 1, 5]);