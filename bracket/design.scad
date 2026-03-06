include <shared.scad>;

wall_thickness=2.6;
inner_dim=[12.5, 20.6, 47.6];
actual_inner_dim=inner_dim + [0, 2 * clearance_tight, clearance_tight];
outer_dim=actual_inner_dim + [0, 2 * wall_thickness, wall_thickness];
pad_dim=[outer_dim.x, outer_dim.x, wall_thickness];

module _pad() {
  difference() {
    cube(pad_dim);
    translate([pad_dim.x / 2 + wall_thickness / 2, pad_dim.y / 2]) CounterSunkScrew(3.6, 13.5, 2.6, 6.8, screw_z_offset=epsilon);
  }
}

module _inner_cutout() {
  translate([0, wall_thickness, 0])cube(actual_inner_dim);
}

module _frame() {
  union() {
    translate([0, -pad_dim.y + epsilon, 0]) _pad();
    translate([0, outer_dim.y - epsilon, 0]) _pad();
    cube(outer_dim);
  }

  _inner_cutout();
}

difference() {
  union() {
    hull() {
      resize([wall_thickness, 0, 0]) _frame();
    }
    _frame();
  }
  _inner_cutout();
}
