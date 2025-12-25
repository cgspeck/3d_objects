include <shared.scad>;

thread_engagement_factor=0.8;
height=2.4 * INCH;
outer_d=1.076 * INCH;
upper_hole_min_diameter=7.10;
upper_hole_max_diameter=7.70;
upper_hole_diameter=(upper_hole_max_diameter - upper_hole_max_diameter) * thread_engagement_factor + upper_hole_min_diameter;
echo("upper_hole_diameter", upper_hole_diameter);
upper_hole_height=24.5 + 10;
lower_hole_min_diameter=7.05;
lower_hole_max_diameter=7.66;
lower_hole_diameter=(lower_hole_max_diameter - lower_hole_max_diameter) * thread_engagement_factor + lower_hole_min_diameter;
echo("lower_hole_diameter", lower_hole_diameter);
lower_hole_height=16 + 20;

// cylinder_outer(height, outer_d / 2);
difference() {
  cylinder_outer(height, outer_d / 2, fn=6);
  translate([0,0,-epsilon]) cylinder_outer(lower_hole_height + epsilon, lower_hole_diameter / 2);
  translate([0,0,height-upper_hole_height]) cylinder_outer(upper_hole_height + epsilon, upper_hole_diameter / 2);
}
