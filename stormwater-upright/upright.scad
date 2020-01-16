use <MCAD/regular_shapes.scad>

min_thickness = 1.2;
2min_thickness = 2 * min_thickness;

socket_dia=82;
socket_z=40;
socket_id=66.5;
lip_z=15;
lip_id=142;
lip_od=152; // measured 150 allow for clearance
lip_od_od =lip_od+ 2 * 2min_thickness;

upper_tube_id=90;
upper_tube_od=90 + 2 * 2min_thickness;

echo("upper_tube_od", upper_tube_od);
echo("lip_od_od", lip_od_od);
transition_z = (lip_od_od - upper_tube_od) / 2;

upper_tube_z=max(40 - transition_z, 0);
transition_start_z = socket_z + lip_z + 2 * min_thickness;

module cylinder_outer(height,radius,fn=72){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);}

module cone_outer(height,radius1,radius2,fn=72){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r1=radius1*fudge,r2=radius2*fudge,$fn=fn);}

module OuterShell() {
    difference() {
        linear_extrude(socket_z) hexagon(socket_dia / 2);
        linear_extrude(socket_z)  hexagon((socket_dia - 2 * 2min_thickness) / 2);
    }

    lower_cylinder_z=lip_z + 2 * min_thickness;

    translate([0, 0, socket_z]) {
        linear_extrude(lip_z) hexagon(lip_id / 2);
        difference() {
            cylinder_outer(lip_z, lip_od_od / 2);
            cylinder_outer(lip_z, lip_od / 2);
        } 
    }

    translate([0, 0, socket_z + lip_z]) {
        cylinder_outer(2 * min_thickness, lip_od_od / 2);
    }
    translate([0, 0, transition_start_z]) cone_outer(transition_z, lip_od_od / 2, upper_tube_od / 2);
    echo("transition_z", transition_z);
    translate([0, 0, socket_z + lip_z + (2 * min_thickness) + transition_z]) cylinder_outer(upper_tube_z, upper_tube_od / 2);
}

module InnerHallow() {
    translate([0, 0, transition_start_z]) cylinder_outer(transition_z + upper_tube_z, upper_tube_id / 2);
    translate([0, 0, socket_z]) cone_outer(lip_z + 2 * min_thickness, socket_id / 2, upper_tube_id / 2);
}

difference() {
    OuterShell();
    InnerHallow();
}
