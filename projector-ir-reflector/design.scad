include <shared.scad>;
include <BOSL2/std.scad>;
use <BOSL2/shapes3d.scad>;
use <BOSL2/transforms.scad>;
use <threadlib/threadlib.scad>;

thickness=min_thickness/2;
fall=35;
width=120;
bottom_front_offset=25;
// module CounterSunkScrew(screw_dia, screw_len, csc_len, csc_head_dia, screw_z_offset=epsilon) {
// select #6 screw
screw_dia=3.5;
screw_len=18;
csc_len=2.11;
csc_head_dia=7.2;
enclosure_thickness=9;
screw_plate_width=csc_head_dia * 2;
outer_width=screw_plate_width * 2 + width;
reflector_guide=2.4;

module FacePlate(width, thickness) {
    hull() {
        cube([width, thickness, epsilon]);
        up(fall) back(fall) cube([width, thickness, epsilon]);
    }
}

module GuideBump() {
    up(fall) cube([screw_plate_width, thickness, thickness]);
}

module UpperPlate(with_offset) {
    fwd_dist = with_offset ? screw_plate_width + bottom_front_offset : screw_plate_width;
    up(fall + enclosure_thickness + clearance_loose) fwd(fwd_dist) cube([screw_plate_width, screw_plate_width, csc_len]);
}

module ScrewPlate(with_offset) {
    fwd_dist = with_offset ? screw_plate_width + bottom_front_offset : screw_plate_width;
    up(fall - csc_len) fwd(fwd_dist) cube([screw_plate_width, screw_plate_width, csc_len]);
}

module ScrewHole(with_offset) {
    fwd_dist = with_offset ? screw_plate_width / 2 + bottom_front_offset : screw_plate_width / 2;
    right(screw_plate_width/2) fwd(fwd_dist) up(fall) xrot(180) 
        CounterSunkScrew(screw_dia, screw_len, csc_len, csc_head_dia, screw_z_offset=epsilon);
}

module MountAssembly(with_offset) {
    difference() {
        union() {
            hull() {
                ScrewPlate(with_offset);
                FacePlate(width = screw_plate_width, thickness = thickness);
            }
            hull() {
                FacePlate(width = screw_plate_width, thickness = thickness);
                UpperPlate(with_offset);
            }
        }
        ScrewHole(with_offset);
        // gap for enclosure
        enclosure_gap_fwd_dist = with_offset ? screw_plate_width + bottom_front_offset : screw_plate_width;
        up(fall) fwd(enclosure_gap_fwd_dist) left(epsilon) 
            cube([screw_plate_width + epsilon * 2, 
                screw_plate_width + epsilon, 
                enclosure_thickness + clearance_loose]);
    }
}

module EntireAssembly(with_offset) {
    difference() {
        union() {
            right(screw_plate_width - epsilon) FacePlate(width = width, thickness = thickness);
            MountAssembly(with_offset);
            right(screw_plate_width + width - epsilon * 2) MountAssembly(with_offset);
        }
        hull() {
            up(0.0125) right(screw_plate_width - reflector_guide) FacePlate(width = width + 2 * reflector_guide, thickness = epsilon);
            up(reflector_guide * 2) right(screw_plate_width)  FacePlate(width = width, thickness = epsilon);
        }
    }

}

EntireAssembly();

right(200) EntireAssembly(true);

