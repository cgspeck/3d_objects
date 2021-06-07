clearance_loose=0.4;
clearance_tight=0.2;
fn=72*3;
$fn=fn;
de_minimus=0.05;

module cylinder_outer(height,radius,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

module multiHull(){
    for (i = [1 : $children-1]) {
        hull(){
            children(0);
            children(i);
        }
    }
}

module sequentialHull(){
    for (i = [0: $children-2]) {
        hull() {
            children(i);
            children(i+1);
        }
    }
}

module doughnut(height, outer_dia, inner_dia, solid, hole) {
    difference() {
        if (solid) {
            cylinder_outer(height, outer_dia / 2);
        }
        if (hole) {
            cylinder_outer(height, inner_dia / 2);
        }
    }
}

dx=58.6;
dy=182;
height=60;

module pad(x_mlt=1.0, y_mlt=1.0, hole=true, solid=true) {
    translate([
        dx/2 * x_mlt,
        dy/2 * y_mlt,
        0
    ]) doughnut(height, 25, 9.5, solid, hole);
}

difference() {
    sequentialHull() {
        pad(hole=false, solid=true);
        pad(1, -1, hole=false, solid=true);
        pad(-1, -1, hole=false, solid=true);
        pad(-1, 1, hole=false, solid=true);
        pad(hole=false, solid=true);
    }

    pad(hole=true, solid=false);
    pad(1, -1, hole=true, solid=false);
    pad(-1, -1, hole=true, solid=false);
    pad(-1, 1, hole=true, solid=false);

    translate([
        -100/2,
        -250/2,
        -2.6
    ]) rotate([90-77,0,0]) cube([100, 250, 100]);
}



