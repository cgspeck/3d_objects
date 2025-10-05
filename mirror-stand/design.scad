include <shared.scad>;


// cone_outer(height,radius1,radius2,fn=fn)
// cylinder_outer(height,radius,fn=fn)
// epsilon, clearance_tight, clearance_loose

mirror_diameter = 140;
mirror_gap = 10;
lip_height = 10;
lip_width = 5;
upper_diameter = mirror_diameter + mirror_gap * 2 + lip_width * 2;
upper_radius = upper_diameter / 2; 
lower_radius = upper_radius * 1.15;

sponge_access_height = 60;
transition_height = 25;

total_height = lip_height + transition_height + sponge_access_height;
difference(){
  cone_outer(total_height, lower_radius, upper_radius);
  translate([0, 0, total_height - lip_height + epsilon]) cylinder_outer(lip_height,mirror_diameter / 2 + mirror_gap);
  rotate([90, 0, 0]) cylinder_outer(lower_radius, sponge_access_height);
  rotate([0, 0, 120]) rotate([90, 0, 0]) cylinder_outer(lower_radius, sponge_access_height);
  rotate([0, 0, 240]) rotate([90, 0, 0]) cylinder_outer(lower_radius, sponge_access_height);
}
