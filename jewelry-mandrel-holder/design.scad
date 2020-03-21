use <MCAD/nuts_and_bolts.scad>
use <MCAD/metric_fastners.scad>

de_minimus=0.01;
bar_dim=[20, 300, 20];
feet_dim=[20, 20, de_minimus];
clearance_loose=0.4;

fn=72*3;
$fn=fn;

module cylinder_outer(height,radius,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);}

module circle_outer(radius,fn=fn){
     fudge = 1/cos(180/fn);
     circle(r=radius*fudge,$fn=fn);}

module hexagon_across_flats(across_flats)
{
    // too many warnings using the MCAD hexagon, issues with naming/not naming parameters
    // and it using a deprecated reg_polygon method
    r = across_flats/2/cos(30);
    regular_polygon(6,r);
}

module barHolderLowerInt() {
    translate([0, 0, bar_dim.z]) cube(size=[40, 20, de_minimus], center=true);
}

module barHolderTopInt() {
    translate([0, 0, bar_dim.z * 2]) cube(size=[40, 20, de_minimus], center=true);
}

module barHolderQtrTopInt() {
    translate([0, 7.5, bar_dim.z * 2]) cube(size=[40, 5, de_minimus], center=true);
}

module Feet() {
    hull() {
        barHolderLowerInt();
        translate([-bar_dim.x * 1.5, 0, 0]) cube(size=feet_dim, center=true);

    }

    hull() {
        barHolderLowerInt();
        translate([bar_dim.x * 1.5, 0, 0]) cube(size=feet_dim, center=true);
    }
}

module BarHolder() {
    hull() {
        barHolderLowerInt();
        barHolderTopInt();
    }
}

module BarHolderCutouts() {
    translate([0, 0, (bar_dim.z * 1.25)]) {
        cube([
            bar_dim.x + clearance_loose * 2,
            bar_dim.y + clearance_loose * 2,
            bar_dim.z + clearance_loose * 2
        ], center=true);
        translate([-50, 0, 0]) rotate([0, 90, 0]) cylinder_outer(100, 2.5 + clearance_loose);
        translate([20 - 4.0, 0, 0]) rotate([0, 90, 0]) nutHole(5);
        translate([-20.5, 0, 0]) rotate([0, 90, 0]) washer(5);
    }
}


module LowerAssembly() {
    difference() {
        union() {
            Feet();
            BarHolder();
        }
        BarHolderCutouts();
    }
}

module movableEndTopPart() {
    end_x=50;
    end_y=20;
    end_z=40;
    x = 3;
    difference() {
        hull() {
            barHolderTopInt();
            translate([0, 0, bar_dim.z * 2 + end_z - de_minimus]) cube(size=[end_x, end_y, de_minimus], center=true);
        }
        translate([0, 5, bar_dim.z * 2 + end_z]) rotate([90, 0, 0]) linear_extrude(15) polygon(points=[
                [-end_x/2,-end_z / x],
                [-end_x/2,0],
                [end_x/2,0],
                [end_x/2,-end_z / x],
                [0,-end_z],
            ]
        );
    }
}

module movableEndTopPart() {
    end_x=50;
    end_y=20;
    end_z=40;
    x = 3;
    difference() {
        hull() {
            barHolderTopInt();
            translate([0, 0, bar_dim.z * 2 + end_z - de_minimus]) cube(size=[end_x, end_y, de_minimus], center=true);
        }
        translate([0, 5, bar_dim.z * 2 + end_z]) rotate([90, 0, 0]) linear_extrude(15) polygon(points=[
                [-end_x/2,-end_z / x],
                [-end_x/2,0],
                [end_x/2,0],
                [end_x/2,-end_z / x],
                [0,-end_z],
            ]
        );
    }
}

module fixedEndTopPart() {
    end_x=50;
    end_y=20;
    end_z=40;
    dip=20;
    x = 3;
    difference() {
        hull() {
            barHolderTopInt();
            translate([0, 0, bar_dim.z * 2 + end_z - de_minimus]) cube(size=[end_x, end_y, de_minimus], center=true);
        }
        translate([0, 10, bar_dim.z * 2 + end_z]) rotate([90, 0, 0]) linear_extrude(20) polygon(points=[
                // [-end_x/2,-end_z / x],
                [-end_x/2,0],
                [end_x/2,0],
                // [end_x/2,-end_z / x],
                [0,-dip],
            ]
        );
    }
}

module MovableEnd() {
    movableEndTopPart();
    LowerAssembly();
}

module FixedEnd() {
    fixedEndTopPart();
    LowerAssembly();
}

MovableEnd();

translate([0, -80, 0]) FixedEnd();
