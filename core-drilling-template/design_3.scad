include <shared.scad>

core_hole_dia=76;
marker_tip_dia=2.8;
narrow_marker_tip_dia=marker_tip_dia-0.75;

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

circle_tran=[total_x / 2, y_marker_d / 2,0];
punch_through_z=b_thickness + 2 * de_minimis;
marker_tip_rad = marker_tip_dia / 2;
narrow_marker_tip_rad = narrow_marker_tip_dia / 2;

module marker(oversized=false, thickness=b_thickness) {
    x = oversized ? marker_width * 1.5 : marker_width;
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
                    y_marker_d / 2 - (marker_width * 2) / 2,
                    0
                ]) rotate([0,0,90]) marker(true);
                translate([
                    total_x,
                    y_marker_d / 2 - (marker_width * 2) / 2,
                    0
                ]) rotate([0,0,90]) marker(true);
                
                t_section(true);
            }
            translate([0, 0, -de_minimis]) {
                // tracing line
                translate(circle_tran) cylinder_outer(
                    b_thickness + 2 * de_minimis,
                    (core_hole_dia + marker_tip_dia * 2) / 2
                );
                // x markers
                translate([
                    (marker_rad * 2) * 2,
                    y_marker_d / 2 - (marker_width) / 2,
                    0
                ]) rotate([0,0,90]) marker(false, punch_through_z);

                translate([
                    total_x - (marker_rad * 2),
                    y_marker_d / 2 - (marker_width) / 2,
                    0
                ]) rotate([0,0,90]) marker(false, punch_through_z);
            }
        }

        translate([0, 0, 0]) {
            translate(circle_tran) {
                cylinder_outer(b_thickness, (core_hole_dia) / 2);
                translate([-5,-50,0]) cube([10, 100, b_thickness]);
            }
        }
    }
    // V marker
    translate([0, 0, 0]) translate([0, 0, -de_minimis]) {
        // just a dot
        // translate(circle_tran) cylinder_outer(punch_through_z, marker_tip_rad);

        // a cross
        cross_full_len=20;
        partial_cross_len=cross_full_len / 3;
        translate([-cross_full_len/2, -narrow_marker_tip_rad, 0]) translate(circle_tran) roundedCube([cross_full_len, narrow_marker_tip_dia, punch_through_z], narrow_marker_tip_rad, true);
        
        translate([-narrow_marker_tip_rad, partial_cross_len * 0.5, 0]) translate(circle_tran) roundedCube([narrow_marker_tip_dia, partial_cross_len, punch_through_z], narrow_marker_tip_rad, true);

        translate([-narrow_marker_tip_rad, -partial_cross_len * 1.5, 0]) translate(circle_tran) roundedCube([narrow_marker_tip_dia, partial_cross_len, punch_through_z], narrow_marker_tip_rad, true);

    }
}

t_section(false);

module check_lines() {
    translate([total_x/2 - 0.5,0,0]) color("red") cube([1, total_y, 5]);
    translate([0,y_marker_d / 2 - 0.5,0]) color("red") cube([total_x, 1, 5]);
}

// check_lines();
