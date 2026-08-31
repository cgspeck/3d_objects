panel_hole_diameter = 22;
head_diameter = panel_hole_diameter + 2;
head_thickness = 2;
panel_thickness = 4;
sparse_barbs = false;
barb_height = 8;
barb_len = 3;
sparse_barb_width = 5;
dense_barb_gap = 3;
wall = 1.8;
fn = 128;
slop = 0.01;

module cylinder_outer(height, radius, fn) {
  fudge = 1 / cos(180 / fn);
  cylinder(h=height, r=radius * fudge, $fn=fn);
}

module cone_outer(height, radius1, radius2, fn) {
  fudge = 1 / cos(180 / fn);
  cylinder(h=height, r1=radius1 * fudge, r2=radius2 * fudge, $fn=fn);
}

cone_outer(height=head_thickness, radius1=head_diameter / 2, radius2=head_diameter / 2 + head_thickness, fn=fn);
intersection() {
  translate([0, 0, head_thickness - slop]) {
    difference() {
      union() {
        cylinder_outer(height=panel_thickness + barb_height + slop, radius=panel_hole_diameter / 2, fn=fn);
        translate([0, 0, panel_thickness]) {
          cone_outer(height=barb_height, radius1=panel_hole_diameter / 2 + barb_len, radius2=panel_hole_diameter / 2, fn=fn);
        }
      }
      cylinder_outer(height=panel_thickness + barb_height + slop * 2, radius=panel_hole_diameter / 2 - wall, fn=fn);
    }
  }
  union() {
    if (sparse_barbs) {
      translate(
        [
          -sparse_barb_width / 2,
          -(panel_hole_diameter + barb_len) / 2,
          0,
        ]
      ) cube(size=[sparse_barb_width, panel_hole_diameter + barb_len * 2, head_thickness + panel_thickness + barb_height]);

      translate(
        [
          -(panel_hole_diameter + barb_len) / 2,
          -sparse_barb_width / 2,
          0,
        ]
      ) cube(size=[panel_hole_diameter + barb_len * 2, sparse_barb_width, head_thickness + panel_thickness + barb_height]);
    } else {
      translate(
        [
          -(panel_hole_diameter + barb_len * 2) / 2,
          -(panel_hole_diameter + barb_len * 2) / 2,
          0,
        ]
      ) difference() {
          cube(
            [
              panel_hole_diameter + barb_len * 2,
              panel_hole_diameter + barb_len * 2,
              head_thickness + panel_thickness + barb_height,
            ]
          );
          translate(
            [
              (panel_hole_diameter + barb_len * 2 - dense_barb_gap) / 2,
              0,
            ]
          ) cube(
              [
                dense_barb_gap,
                panel_hole_diameter + barb_len * 2,
                head_thickness + panel_thickness + barb_height + slop,
              ]
            );
          translate(
            [
              0,
              (panel_hole_diameter + barb_len * 2 - dense_barb_gap) / 2,
            ]
          ) cube(
              [
                panel_hole_diameter + barb_len * 2,
                dense_barb_gap,
                head_thickness + panel_thickness + barb_height + slop,
              ]
            );
        }
    }
  }
}
