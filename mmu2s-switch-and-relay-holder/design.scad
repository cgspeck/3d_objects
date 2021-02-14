include <MCAD/boxes.scad>

clearance_loose=0.4;
clearance_tight=0.2;
fn=72*3;
$fn=fn;
cutout_z=60;

module cylinder_outer(height,radius,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

module SliderSwitch(solids=true, cutouts=true, clearance=clearance_loose) {

    switch_dim=[35.72, 13.64, 7];
    paddle_dim=[7,5.6,8];
    slide_section_dim=[
        12+2*clearance,
        5.6+2*clearance,
        cutout_z
    ];
    hole_dx=28.65;
    hole_dia=3.4;

    translate([
        0,
        0,
        -switch_dim.z / 2
    ]) {
        difference() {
            if(solids) {
                cube(switch_dim, center=true);
                translate([(paddle_dim.x/2) - 1,0,(switch_dim.z + paddle_dim.z) / 2]) cube(paddle_dim, center=true);
            }
            if(cutouts) {
                cube(slide_section_dim, center=true);
                translate([0,0,-cutout_z/2]) {
                    translate([-hole_dx/2,0,0]) cylinder_outer(cutout_z, hole_dia / 2);
                    translate([hole_dx/2,0,0]) cylinder_outer(cutout_z, hole_dia / 2);
                }
            }
        }
    }
}

module S4132DC_24(solids=true, cutouts=true) {
    board_dim = [32.5, 22.5, 2];
    h1_tran = [3.5, board_dim.y - 10.5];
    h2_tran = [29, board_dim.y - 3.5];
    hole_dia=3.4;

    translate([
        -board_dim.x / 2,
        -board_dim.y / 2,
        -board_dim.z,
    ]) {
        difference() {
            if(solids) {
                cube(board_dim);
            }
            if(cutouts) {
                translate([0,0,-cutout_z/2]) {
                    translate([
                        h1_tran.x,
                        h1_tran.y,
                        0
                    ]) cylinder_outer(cutout_z, hole_dia / 2);
                    translate([
                        h2_tran.x,
                        h2_tran.y,
                        0
                    ]) cylinder_outer(cutout_z, hole_dia / 2);

                }
            }
        }
    }

}

lower_dx=40;
secure_pt_tran=[0,33];
plate_z=2.4;
difference() {
    hull() {
        translate(secure_pt_tran) cylinder_outer(plate_z, 6);
        translate([0,0,plate_z/2]) roundedCube([80,25,plate_z],3, sidesonly=true, center=true);
    }
    translate([-lower_dx/2, 0, 0]) {
        SliderSwitch(solids=false, cutouts=true);
    }

    translate([lower_dx/2, 0, 0]) {
        S4132DC_24(solids=false, cutouts=true);
    }

    translate([secure_pt_tran.x, secure_pt_tran.y,-cutout_z/2]) {
        cylinder_outer(cutout_z, 3.4/2);
    }
}


