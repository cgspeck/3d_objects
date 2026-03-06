include <shared.scad>;

wall_thickness=2.4;
inner_diameter=30;
inner_len=30;
far_inner_height=5;
width = 12.5;

outer_len=inner_len + 2 * wall_thickness;
pad_dim=[width, width, wall_thickness];
module _pad() {
  difference() {
    cube(pad_dim);
    translate([pad_dim.x / 2 + wall_thickness / 2, pad_dim.y / 2]) CounterSunkScrew(3.6, 13.5, 2.6, 6.8, screw_z_offset=epsilon);
  }
}

module _hub_section(inner = true) {
  _dia = inner ? inner_diameter : inner_diameter + wall_thickness * 2;
  _far_height = inner ? far_inner_height : far_inner_height + wall_thickness;
  _tran_y = inner ? wall_thickness : 0;
  _end_tran_len = inner ? inner_len - epsilon : inner_len + wall_thickness * 2;
  _tran_z = inner ? -epsilon : 0;
  add_z = inner ? epsilon : 0;
  translate([0, _tran_y, _tran_z]) hull() {
    translate([width, _dia / 2, 0]) rotate([0, 0, 90]) rotate([0, 270, 0]) D([_dia / 2 + add_z, width, _dia / 2]);
    translate([0, _end_tran_len, 0]) cube([width, epsilon, _far_height + add_z]);
  }
}

module _frame() {
  union() {
    translate([0, -pad_dim.y + epsilon, 0]) _pad();
    translate([0, outer_len - epsilon, 0]) _pad();
    _hub_section(inner=false);
  }
}

difference() {
  union() {
    hull() {
      resize([wall_thickness, 0, 0]) _frame();
    }
    _frame();
  }
  _hub_section(inner=true);
}
