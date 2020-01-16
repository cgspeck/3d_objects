use <MCAD/regular_shapes.scad>

use <grid.scad>

fn=72*5;
$fn=fn;
min_thickness = 1.2;
2min_thickness = 2 * min_thickness;
clearance_working=0.4;

pipe_id=75;
socket_z=25.4;

permiter_id=82.7 + (clearance_working * 2);

hose_od=19.4 + (clearance_working * 2);

grid_size=20;
grid_z=25.4 / 2;


//transition
tran_min_id=pipe_id - 10;

transition_z=permiter_id - tran_min_id;
perimeter_z=20 + transition_z;


module cylinder_outer(height,radius,fn=72){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);}

module cone_outer(height,radius1,radius2,fn=72){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r1=radius1*fudge,r2=radius2*fudge,$fn=fn);}

//perimeter
difference() {
    cylinder_outer(perimeter_z, (permiter_id + 2 * 2min_thickness) / 2, fn);
    cylinder_outer(perimeter_z, permiter_id / 2, fn);
}

//hole for hose
difference() {
    cylinder_outer(grid_z, (hose_od + 2 * 2min_thickness) / 2, fn);
    cylinder_outer(grid_z, hose_od / 2, fn);
}

//grid
difference() {
    CircularGrid(permiter_id / 2, grid_z, 
        pitch_x=grid_size + 2min_thickness, pitch_y=grid_size + 2min_thickness,
        thickness_x=2min_thickness,
        thickness_y=2min_thickness,
        adj_x=-4.5,
        adj_y=-4.5,
        fn=fn
    );
    cylinder_outer(perimeter_z, hose_od / 2);
}

//transition
difference() {
    translate([0, 0, grid_z]) cone_outer(transition_z, (permiter_id + 2 * 2min_thickness) / 2, (tran_min_id + 10)/ 2, fn);
    translate([0, 0, grid_z]) cone_outer(transition_z, (permiter_id) / 2, (tran_min_id - 2 * 2min_thickness) / 2, fn);
}

//socket
translate([0, 0, grid_z + transition_z]) difference() {
    linear_extrude(socket_z) hexagon(pipe_id / 2);
    linear_extrude(socket_z) hexagon((pipe_id - 2 * 2min_thickness) / 2);
}