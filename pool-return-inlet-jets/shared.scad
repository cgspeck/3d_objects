// modules and vars specific to this project
use <MCAD/boxes.scad>
use <MCAD/nuts_and_bolts.scad>
use <MCAD/regular_shapes.scad>
include <BOSL2/std.scad>;
use <BOSL2/shapes3d.scad>;
use <BOSL2/transforms.scad>;
use <threadlib/threadlib.scad>;
include <threadlib/THREAD_TABLE.scad>
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

module TeeTube(ir=20, wall=6, up_wall=3, length=100, thread_up_turns=10, thread_up, thread_end=undef) {
    up_specs = thread_specs(str(thread_up, "-int"));
    up_r = up_specs[2] / 2;
    echo("up_specs", up_specs);
    difference() {
        union() {
            xrot(90) tube(ir=ir, wall=wall, h=length);
            cylinder(r=up_r + up_wall, h=ir + wall);
        };
        xrot(90) cylinder(h=length, r=ir, center=true);
        thread_d_outer = (up_r + up_wall) * 2;
        up(ir - wall) tap(thread_up, turns=thread_up_turns);
    };

    if (!is_undef(thread_end)) {
        thread_d_outer = (ir + wall) * 2;
        fwd(length/2 - $slop) xrot(90) nut(thread_end, turns=4, Douter=thread_d_outer);
    }
};