include <shared.scad>;
include <BOSL2/std.scad>;
use <BOSL2/shapes3d.scad>;
use <BOSL2/transforms.scad>;
use <threadlib/threadlib.scad>;

// think this is a UNF 2"
as_measured_1_int_major_dim=50 + 0.751;
table = [
    ["UNF-2-int", [2.11667, -25.45029836, 50.8823018 , [[0, 0.9260], [0, -0.9260], [1.1457, -0.2646], [1.1457, 0.2646]]]],
    ["measured-1-int", [2.11667, -as_measured_1_int_major_dim / 2 - 0.00915, as_measured_1_int_major_dim , [[0, 0.9260], [0, -0.9260], [1.1457, -0.2646], [1.1457, 0.2646]]]]
];

bend_radius=30;
angle=65;

module Elbow() {
    back(bend_radius) yrot(270) nut("UNF-2", turns=4, Douter=62, nut_sides=6, table=table);
    tee_length=1/2 * inch + 12;
    rotate_extrude(angle=angle, start=90-angle) right(bend_radius) tube2d(ir=20,wall=6,h=30);
    x_pos = bend_radius * sin(angle);
    y_pos = bend_radius * cos(angle);
    translate([x_pos, y_pos]) zrot(90 - angle) fwd(tee_length/2) TeeTube(length=tee_length, thread_up="G1/2", thread_end="G1 1/2", up_wall=1.2);
}

module Compact() {
    yrot(270) nut("UNF-2", turns=4, Douter=62, nut_sides=6, table=table);
    tee_length=1/2 * inch + 12;
    translate([-epsilon, 0]) zrot(90) fwd(tee_length/2) TeeTube(length=tee_length, thread_up="G1/2", thread_end="G1 1/2", up_wall=1.2);
}

module AngledNozzle(degree, tube_id=40, tube_wall=6, outlet_diameter=27, outlet_wall=3.3, hex_end=true, fat_hex=false) {
    thread_y_origin=-1.1544;
    outlet_y_origin=15;
    diameter_diff=tube_id - outlet_diameter;
    tube_od=tube_id + tube_wall * 2;
    angled_nozzle_bend_radius=90-angle;
    echo("diameter_diff", diameter_diff);
    assert(diameter_diff < outlet_y_origin * 2, "diameter diff exceeds length of straight part");
    hex_segments = hex_end ? 6 : 360;
    // Re-calculate radius inside module based on input parameter
    hexagon_flat_radius = hex_end ? 
        fat_hex ? (tube_od / 2) / cos(30) : tube_od / 2
        : tube_od / 2;

    difference() {
        union() {
            xrot(90) bolt("G1 1/2", turns=4);
            fwd(12) xrot(90) cylinder(6, r=hexagon_flat_radius, $fn=hex_segments, center=true);
            xrot(90) cylinder(outlet_y_origin, r=20+epsilon);
        }
        xrot(90) cylinder(outlet_y_origin, r=outlet_diameter / 2, tube_id / 2);
        back(-thread_y_origin + epsilon) xrot(90) cylinder(-thread_y_origin + 2 * epsilon, r=tube_id / 2);
    }
    fwd(outlet_y_origin-epsilon) left(angled_nozzle_bend_radius) zrot(270) rotate_extrude(angle=degree, start=90-degree) right(angled_nozzle_bend_radius) tube2d(ir=outlet_diameter / 2,wall=outlet_wall,h=30);
}

module Snorkel(snorkel_wall_thickness=1.2, upper_tube_len=110)  {
    tube_od=18.1;
    grip_od=24;
    
    difference() {
        union() {
            hull() {
                up(39 + grip_od - tube_od) cylinder(5, r=tube_od/2, $fn=6);
                up(39) cylinder(5, r=grip_od/2, $fn=6);
            }
            up(20) bolt("G1/2", turns=10);
            up(26 + upper_tube_len / 2) tube(od=18.1, l=upper_tube_len, wall=snorkel_wall_thickness);
            up(20) difference() {
                tube(od=18.1, l=6 + 50, wall=snorkel_wall_thickness);
                down(30) xrot(45) cube([20, 20, 60], center=true);
            }
        }
        left(1.9) up(36.5) fwd(grip_od/2 - snorkel_wall_thickness * 1.8) xrot(90) text3d("*", h=snorkel_wall_thickness, size=7);
        down(50) cylinder(200, d=tube_od - snorkel_wall_thickness * 2);
    }
}

module Plug()  {
    snorkel_wall_thickness=1.2;
    tube_od=18.1;
    grip_od=24;
    union() {
            up(0) yrot(180) cylinder(5, r=grip_od/2, $fn=6);
            up(0) bolt("G1/2", turns=4);
        }
}

module Nozzle() {
    difference() {
        union() {
            xrot(90) bolt("G1 1/2", turns=4);
            fwd(12) xrot(90) cylinder(6, r=20+6, $fn=6, center=true);
            hull() {
                fwd(12) xrot(90) cylinder(6, r=20+6, $fn=6, center=true);
                fwd(25 + 10 - epsilon) xrot(270) cylinder(epsilon, r=33.6 / 2, center=true);
            }
        }
        fwd(25 - epsilon) xrot(270) cylinder(20 + epsilon * 2, r=20, 27 / 2, center=true);
        fwd(5) xrot(90) cylinder(20, r=20, center=true);
    }
}

// yrot(90) zrot(angle) Elbow();

// up(136) left(100) xrot(180) Snorkel();

// left(100) fwd(50) Plug();

// up(35) left(100) fwd(150) xrot(90) Nozzle();

right(100) Compact();

right(100) fwd(100) AngledNozzle(65);