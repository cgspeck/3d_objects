// modules and vars specific to this project
use <MCAD/boxes.scad>
use <MCAD/nuts_and_bolts.scad>
use <MCAD/regular_shapes.scad>
include <BOSL2/std.scad>;
use <BOSL2/shapes3d.scad>;
use <BOSL2/transforms.scad>;
use <threadlib/threadlib.scad>;
include <MCAD/units.scad>
include <helpers.scad>

$slop = clearance_tight;

module tube2d(
    h, or, ir, center,
    od, id, wall,
    or1, or2, od1, od2,
    ir1, ir2, id1, id2,
    realign=false, l, length, height,
    anchor, spin=0, orient=UP, orounding1,irounding1,orounding2,irounding2,rounding1,rounding2,rounding,
    ochamfer1,ichamfer1,ochamfer2,ichamfer2,chamfer1,chamfer2,chamfer,irounding,ichamfer,orounding,ochamfer,
    teardrop=false, clip_angle, shift=[0,0],
    ifn, rounding_fn, circum=false
) {
    projection() tube(h, or, ir, center,
    od, id, wall,
    or1, or2, od1, od2,
    ir1, ir2, id1, id2,
    realign=false, l, length, height,
    anchor, spin=0, orient=UP, orounding1,irounding1,orounding2,irounding2,rounding1,rounding2,rounding,
    ochamfer1,ichamfer1,ochamfer2,ichamfer2,chamfer1,chamfer2,chamfer,irounding,ichamfer,orounding,ochamfer,
    teardrop=false, clip_angle, shift=[0,0],
    ifn, rounding_fn, circum=false);
};

module TeeTube(ir=20,wall=6, length=100, thread_up_turns=4, thread_up=undef, thread_end=undef) {
    difference() {
        union() {
            xrot(90) tube(ir=ir, wall=wall, h=length);
            up(length/8) tube(ir=ir, wall=wall, h=length/4);
        };
        xrot(90) cylinder(h=length, r=ir, center=true);
        up(length / 4) cylinder(r=ir, h=length/2, center=true);
    };

    if (!is_undef(thread_up)) {
        thread_d_outer = (ir + wall) * 2;
        up(thread_d_outer/2) yrot(180) nut(thread_up, turns=thread_up_turns, Douter=thread_d_outer);
    }

    if (!is_undef(thread_end)) {
        thread_d_outer = (ir + wall) * 2;
        fwd(length/2 - $slop) xrot(90) nut(thread_end, turns=4, Douter=thread_d_outer);
    }
};