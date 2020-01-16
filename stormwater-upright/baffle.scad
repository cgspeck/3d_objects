use <grid.scad>

min_thickness = 1.2;
2min_thickness = 2 * min_thickness;
upper_tube_id=90;
baffle_diameter=upper_tube_id - 0.8;
baffle_r=baffle_diameter/2;
baffle_z=35;
baffle_tube_z=40;
grid_size=14;

module cylinder_outer(height,radius,fn=72){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);}

difference() {
    cylinder_outer(baffle_tube_z, baffle_r);
    cylinder_outer(baffle_tube_z, baffle_r - 2min_thickness);
}

CircularGrid(baffle_r, baffle_z, pitch_x=grid_size + 2min_thickness, pitch_y=grid_size + 2min_thickness, thickness_x=2min_thickness, thickness_y=2min_thickness);
