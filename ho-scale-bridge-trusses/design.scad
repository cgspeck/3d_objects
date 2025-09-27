use <MCAD/boxes.scad>
include <MCAD/units.scad>

// 1/8, 3/8, 1/8/ 3/8, 1/8 3/8, 1/8/ 3/8, 1/8/ 
// -10        -5        0         5         10
// max X bracing = 1.5"
bracket_thickness = 1.5;
bracket_z = (3 / 16) * inch;
base_thickness = 1.5;
arm_thickness = 2; // 2 / 16 * inch;
half_arm_thickness = arm_thickness / 2;
arm_dist = 4.5; //3 / 16 * inch;
base_z = bracket_z * 2;
base_extd = 7;
outer_angle = 4.5;
outer_dist = (arm_thickness + arm_dist) * 2;

// MAKE SURE YOU ENABLE THE 'OBJECT' FEATURE OR THERE WILL BE ERRORS
armPositionOpts = [
  object(
    position=0,
    angle=0,
  ),
  object(
    position=arm_thickness + arm_dist,
    angle=2.5,
  ),
  object(
    position=outer_dist,
    angle=outer_angle,
  ),
  object(
    position=-(arm_thickness + arm_dist),
    angle=-2.5,
  ),
  object(
    position=-outer_dist,
    angle=-outer_angle,
  ),
];

module Truss(height_in_inches) {
  height = height_in_inches * inch;
  arm_height = height - bracket_thickness - base_thickness;
  assert(arm_height >= 0);

  translate([-arm_thickness / 2, 0]) cube([arm_thickness, arm_height, bracket_z]);

  for (armPosition = armPositionOpts) {
    echo(armPosition);
    x = tan(armPosition.angle) * PI * arm_height;
    echo(x);
    translate([armPosition.position - arm_thickness / 2, 0]) {
      hull() {
        translate([0, arm_height]) cube([arm_thickness, epsilon, bracket_z]);
        translate([x, 0]) cube([arm_thickness, epsilon, bracket_z]);
      }
    }
  }

  {
    angle_x = tan(outer_angle) * PI * arm_height;
    echo(angle_x);
    x1 = -outer_dist - angle_x - arm_thickness / 2 - base_extd;
    x2 = +outer_dist + angle_x + base_extd;
    translate([x1, -base_thickness]) cube([x2 - x1, base_thickness, base_z]);
  }
}

Truss(1);
