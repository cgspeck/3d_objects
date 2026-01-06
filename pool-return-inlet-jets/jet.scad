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

module Jet(wall_thickness=1.4, in_diameter=40, out_diameter=30, torus_minor_diameter=undef, nozzle_dist=undef, nozzle_gap=undef) {
    _torus_minor_diameter = is_undef(torus_minor_diameter) ? in_diameter / 2 : torus_minor_diameter;
    _torus_major_diameter = (out_diameter + _torus_minor_diameter) + wall_thickness * 2;
    _nozzle_dist = is_undef(nozzle_dist) ? (in_diameter - out_diameter) * 6 : nozzle_dist;
    _nozzle_gap = is_undef(nozzle_gap) ? out_diameter : nozzle_gap;
    _inner_tube_diameter = out_diameter - wall_thickness * 2;
    echo("out_diameter", out_diameter);
    echo("_inner_tube_diameter", _inner_tube_diameter)
    echo("_nozzle_dist", _nozzle_dist);
    echo("_torus_minor_diameter", _torus_minor_diameter);
    echo("_torus_major_diameter", _torus_major_diameter);
    difference() {
        union() {
            hull() {
                down(_torus_minor_diameter / 2 + wall_thickness) cylinder(epsilon, r=_torus_major_diameter / 2 + _torus_minor_diameter / 2 + wall_thickness, $fn=6);
                cylinder(epsilon, r=_torus_major_diameter / 2 + _torus_minor_diameter, $fn=6);
                up(_nozzle_dist) cylinder(epsilon, r=out_diameter / 2 + wall_thickness);
            };

            t_specs = thread_specs("G1 1/2-ext");
            t_up_dist = t_specs[3][2][0];
            t_total_up = t_up_dist + in_diameter/2 - _torus_minor_diameter / 2 + wall_thickness / 2;
            hull() {
                up(t_total_up - t_up_dist / 2) xrot(270) cylinder(epsilon, r=out_diameter/2 + wall_thickness);
                back(_torus_major_diameter/2 + _torus_minor_diameter / 2 + 10) up(t_total_up - t_up_dist / 2) xrot(270) cylinder(epsilon, r=out_diameter/2 + wall_thickness);
            }
            back(_torus_major_diameter/2 + _torus_minor_diameter / 2 + 10) up(t_total_up) xrot(270) bolt("G1 1/2", turns=4);

        }


        difference() {
            hull() {
                torus(r_maj=_torus_major_diameter / 2, r_min=_torus_minor_diameter / 2);
                up(_nozzle_dist) cylinder(epsilon, r=out_diameter / 2);
            }
            down(_torus_minor_diameter / 2 + epsilon) cylinder((_nozzle_dist + _torus_minor_diameter / 2 + epsilon * 2), r=_inner_tube_diameter / 2 + wall_thickness);
        };
        down(_torus_minor_diameter / 2 + wall_thickness + epsilon) cylinder(200, r=_inner_tube_diameter / 2);
        back(_torus_major_diameter/2) up(_torus_minor_diameter/2 + wall_thickness) xrot(270) cylinder(100, r=out_diameter/2);
        up(_nozzle_dist - _nozzle_gap) cylinder(_nozzle_gap + epsilon * 2, r=out_diameter / 2);
    }
}

// left_half(s=200) Jet();
Jet();
