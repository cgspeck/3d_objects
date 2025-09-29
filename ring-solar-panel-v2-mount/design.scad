include <shared.scad>;

module screw_hole() {
  translate([0,0,-epsilon]) cylinder_outer(base_z + epsilon * 2, 3.96 / 2);  
  translate([0,0,1.8]) cylinder_outer(1.8 + epsilon, 7 / 2);  
}

module pillar() {
  difference() {
    union() {
      translate([-base_x / 2, -base_x / 2, 0]) cube([base_x, base_x, 98]);
      translate([-base_x / 2,0, 98]) rotate([0,90,0]) cylinder_outer(base_x, base_x / 2);
    }
    translate([-base_x / 2, 0, 98]) rotate([0, 90, 0]) linear_extrude(solar_panel_post_x  + 2 * clearance_loose) circle_outer(solar_panel_post_y / 2 + clearance_loose * 2);
    translate([-base_x / 2, 0, 98]) rotate([0, 90, 0]) linear_extrude(base_x + epsilon * 2) circle_outer(solar_panel_screw_rad);

    // cutout for hirth
    translate([
      - base_x / 2 
      + solar_panel_post_x  + 2 * clearance_loose, 0, 98]) rotate([0,90,0]) cylinder_outer(3.54, solar_panel_post_y / 2 + clearance_loose * 2);
  }
  translate([
    - base_x / 2
    + solar_panel_post_x  + 2 * clearance_loose
    + 1.775
    + 0.65,
    0,
    98
  ]) rotate([0,270,0]) hirth(
    hirth_teeth,
    solar_panel_screw_rad,
    solar_panel_post_y / 2,
    base=epsilon,
    rot=true
  );
}

module solar_panel_post() {
  hirth(
    hirth_teeth,
    solar_panel_screw_rad,
    solar_panel_post_y / 2
  ) attach(BOTTOM, CENTER) difference() {
    union() {
      linear_extrude(solar_panel_post_x  - 2 * clearance_loose) hull() {
        circle_outer(solar_panel_post_y / 2);
        translate([0, solar_panel_post_z - solar_panel_post_y]) square(size=[solar_panel_post_y, solar_panel_post_y], center=true);
      }
    }
    translate([0,0,3]) cylinder_outer(10, solar_panel_screw_rad);
  }
}

module solar_panel_base() {
  tab_x = 4 - clearance_tight * 2;
  difference() {
    union() {
      roundedCube([solar_panel_base_x, solar_panel_base_y, solar_panel_base_z], 2, true);
      translate([0, 0]) cube([solar_panel_base_x, 3, solar_panel_base_z]);
      translate([(solar_panel_base_x / 2) - tab_x / 2, 0.5, 0]) cube([tab_x, 1.5, solar_panel_base_z + 1]);
      translate([-(42 - solar_panel_base_x) / 2, -5]) {
        roundedCube([42, 5, solar_panel_base_z], 2, true);
        translate([0, 5/2]) cube([42, 5/2, solar_panel_base_z]);
      }
    }
    translate([solar_panel_base_x / 2 + tab_x / 2, -5, -epsilon]) cube([1, 8 + 5, solar_panel_base_z + epsilon * 2]);
    translate([solar_panel_base_x / 2 - tab_x / 2 - 1, -5, -epsilon]) cube([1, 8 + 5, solar_panel_base_z + epsilon * 2]);
    translate([solar_panel_base_x / 2 - tab_x / 2, -6, -1]) rotate([45,0,0]) cube([tab_x, 10, 10]);
  }
}

module solar_panel_base_countersunk() {
  add_z = 4;
  add_trans = [solar_panel_base_x / 2, solar_panel_base_y / 2, solar_panel_base_z - add_z];

  difference() {
    union() {
      solar_panel_base();
      // translate(add_trans) cylinder_outer(3, 6);
    }
    translate([0, 0, 2.2]) translate(add_trans)  CounterSunkScrew(3, 5, 1.7, 6);
  }
}

module solar_panel_post_countersunk() {
  add_base_y=3;
  add_base_tran = [
    -solar_panel_post_y / 2,
    solar_panel_post_z - solar_panel_post_y / 2,
    -8
  ];
  add_base_tran_ctr = [
    0,
    add_base_tran.y + epsilon,
    add_base_tran.z + solar_panel_post_y / 2
  ];
  difference() {
    union() {
      solar_panel_post();
      translate(add_base_tran) rotate([90, 0, 0]) roundedCube([solar_panel_post_y, solar_panel_post_y, 3], 2, true);
    }

    translate(add_base_tran_ctr) rotate([90,0,0]) NutHoleAssembly(
      3,
      length=10,
      nut_depth=add_base_y + 1.25,
    );
  }
}

// https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad#module-rect_tube
difference() {
  union() {
    linear_extrude(base_z) rect([base_x, base_y], rounding=base_x/2);
    translate([0,0,base_z - epsilon]) pillar();
  }
  translate([0,base_y / 2 - base_x / 2]) screw_hole();
  translate([0, - base_y / 2 + base_x / 2]) screw_hole();
}


translate([50, 0]) solar_panel_post();
translate([100, 0]) solar_panel_base();
translate([175, 0]) solar_panel_base_countersunk();
translate([250, 0]) solar_panel_post_countersunk();