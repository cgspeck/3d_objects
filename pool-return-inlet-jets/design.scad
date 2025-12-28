include <shared.scad>;
include <BOSL2/std.scad>;
use <BOSL2/shapes3d.scad>;
use <BOSL2/transforms.scad>;
use <threadlib/threadlib.scad>;

// think this is possibly/probably a UNF 2"
measured_1_int_major_dim=50 + 0.751;
table = [["measured-1-int", [2.11667, -measured_1_int_major_dim / 2 - 0.00915, measured_1_int_major_dim , [[0, 0.9260], [0, -0.9260], [1.1457, -0.2646], [1.1457, 0.2646]]]]];

back(30) yrot(270) nut("measured-1", turns=4, Douter=60, nut_sides=6, table=table);
// tube(ir=20,wall=5,h=30);
angle=70;

module Arm() {
    rotate_extrude(angle=angle, start=90-angle) right(30) tube2d(ir=20,wall=6,h=30);
    zrot(90-angle) fwd(50) right(30) TeeTube(thread_up="G1/2", thread_up_turns=2.75, thread_end="G1 1/2");
}


module Snorkle()  {
    snorkle_wall_thickness=1.2;
    tube_od=18.1;
    grip_od=24;
    
    difference() {
        union() {
            hull() {
                up(39 + grip_od - tube_od) cylinder(5, r=tube_od/2, $fn=6);
                up(39) cylinder(5, r=grip_od/2, $fn=6);
            }
            up(20) bolt("G1/2", turns=10);
            up(40 + 6 + 10) tube(od=18.1, l=60, wall=snorkle_wall_thickness);
            up(20) difference() {
                tube(od=18.1, l=6 + 50, wall=snorkle_wall_thickness);
                down(30) xrot(45) cube([20, 20, 60], center=true);
            }
        }
        down(50) cylinder(200, d=tube_od - snorkle_wall_thickness * 2);
    }
}

module Plug()  {
    snorkle_wall_thickness=1.2;
    tube_od=18.1;
    grip_od=24;
    union() {
            up(0) yrot(180) cylinder(5, r=grip_od/2, $fn=6);
            up(0) bolt("G1/2", turns=4);
        }
}

module Constrictor() {
    difference() {
        union() {
            xrot(90) bolt("G1 1/2", turns=4);
            fwd(12) xrot(90) cylinder(6, r=20+6, $fn=6, center=true);
            fwd(25 - epsilon) xrot(270) cylinder(20, r=20+6, 33.6 / 2, center=true);
        }
        fwd(25 - epsilon) xrot(270) cylinder(20 + epsilon * 2, r=20, 27 / 2, center=true);
        fwd(5) xrot(90) cylinder(20, r=20, center=true);
    }
}

Arm();

left(100) Snorkle();

left(100) fwd(50) Plug();

left(100) fwd(150) Constrictor();