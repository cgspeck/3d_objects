include <shared.scad>

base_step_1_height = 6 - clearance_loose;
base_dim_y = 56;
base_step_2_height = 15.5;

screw_hole_dx=31;
screw_hole_dy=34;
screw_hole_d=2.5 + clearance_loose * 2;
screw_head_d=4.9 + clearance_loose * 2;
screw_hole_tran_x=20;
screw_hole_tran_y=12;
screw_hole_grab_thickness=2.0;

base_dim_x = screw_hole_tran_x + screw_hole_dx + screw_hole_tran_x;
slide_width = 30;
slide_inset = 3;
slide_entry_slot_extra_length=2;
slide_len = (base_dim_y - slide_inset * 2 - slide_entry_slot_extra_length) / 2;

slide_slope = 2;
dovetail_height=8;

pre_made_hirth_inner_dia=19.2;
pre_made_hirth_dia=42;

new_hirth_total_height = 4.57;
new_hirth_midpoint = 1 + (4.57 - 1) / 2;
new_hirth_wave_height = 4.57 - 1;
echo("new_hirth_midpoint", new_hirth_midpoint);

module _screw_holes(dia, z_offset) {
  up(z_offset - epsilon) {
    cylinder(d=dia, h=base_step_2_height + epsilon * 2);
    back(screw_hole_dy) cylinder(d=dia, h=base_step_2_height + epsilon);

    right(screw_hole_dx) {
      cylinder(d=dia, h=base_step_2_height + epsilon * 2);
      back(screw_hole_dy) cylinder(d=dia, h=base_step_2_height + epsilon);
    }
  }
}

module screw_holes() {
  _screw_holes(screw_hole_d, 0);
  _screw_holes(screw_head_d, screw_hole_grab_thickness);
}

module _arm_brace_shape(length, height=15) {
  arm_length=length - pre_made_hirth_dia / 2;
  frame=5;
  frame_right=max(arm_dovetail_height + 3, frame);
  echo("arm_length", arm_length);
  right(arm_length/2) {
  diff() {
    hex_panel([arm_length, pre_made_hirth_dia, height], 1.5, 10, frame = frame)
    up(7.5) right(arm_length/2 - frame_right / 2) cuboid([frame_right, pre_made_hirth_dia, 30]);

    hull() {
      fwd(30 - 11.5) up(7.5) right(arm_length/2 - frame_right / 2) cuboid([frame_right, frame, 30]);
      fwd(30 - 11.5) down(frame) right(arm_length/2 - 30 / 2) cuboid([30, frame, frame]);      
    }

    hull() {
      back(15 + 3.5) up(7.5) right(arm_length/2 - frame_right / 2) cuboid([frame_right, frame, 30]);
      back(15 + 3.5) down(frame) right(arm_length/2 - 30 / 2) cuboid([30, frame, frame]);      
    }
    tag("remove") left(arm_length/2) down(epsilon) cylinder(d=pre_made_hirth_dia, h=height + epsilon * 3, center=true);
    tag("remove") left(arm_length/2) up(15.54/2) down(epsilon + 0.5) cylinder(d=pre_made_hirth_dia + 3, h=new_hirth_wave_height + epsilon * 3, center=true);

    tag("remove") 
      up(15.54/2)
      right(arm_length/2)
      xrot(0) 
      yrot(90)
      dovetail(
        "female",
        slide=arm_slide_len,
        width=arm_slide_width,
        height=arm_dovetail_height,
        slope=arm_slide_slope,
        entry_slot_length=arm_slide_len + 2,
        $slop=clearance_loose
      );
    }
  }
}


module Arm(length) {
  // import mount abd remove old hirth
  union() {
    difference() {
      import("./vendor/multifunction-arm-mounting-system/Base-small-with-holow-M3.stl", convexity=10, center=true);
      up(7.77) down(new_hirth_midpoint) cylinder(d=pre_made_hirth_dia + clearance_loose, h=new_hirth_total_height);
    }
    // build new hirth
    down(new_hirth_midpoint) up(15) down(15.54/2 - new_hirth_midpoint) hirth(32,pre_made_hirth_inner_dia/2,pre_made_hirth_dia/2, rot=true);
  }
  // add the arm and attachment point
  down(0.25) _arm_brace_shape(length, height=15);
}

xdistribute(spacing=100) {
  diff() {
    cuboid([base_dim_x, base_dim_y, base_step_2_height], rounding=base_step_2_height - base_step_1_height, edges=[TOP+LEFT,TOP+RIGHT]) {
      align(BACK, BOT+LEFT) cuboid([2.2 - clearance_tight * 2, 3, base_step_1_height]);
      align(BACK, BOT+RIGHT) cuboid([2.2 - clearance_tight * 2, 3, base_step_1_height]);
      tag("remove") 
          down(base_step_2_height / 2) 
          left(base_dim_x / 2 - screw_hole_tran_x) 
          fwd(screw_hole_tran_y/2)
          fwd(screw_hole_tran_y)
          // fwd(base_dim_y / 2 - screw_hole_tran_y)
          // fwd(base_dim_y / 2 - screw_hole_tran_y)
          screw_holes();
      tag("remove") 
        rotate(180) 
        attach(TOP,BOT,align=BACK,inside=true,inset=3) 
        dovetail("female", slide=slide_len, width=slide_width, height=dovetail_height, slope=slide_slope, entry_slot_length=slide_len + 2, $slop=clearance_loose);
    }
  };

  union() {
    difference() {
      import(".\\vendor\\multifunction-arm-mounting-system\\holder-small-nuts-18-18-M4.stl", convexity=10, center=true);
      back(3.75) down(new_hirth_midpoint - 1) cylinder(d=pre_made_hirth_dia + clearance_loose, h=new_hirth_total_height);
      fwd(pre_made_hirth_dia / 2 - 5) up(7.5 - new_hirth_midpoint / 2) cuboid([pre_made_hirth_dia, 10, 15 + new_hirth_midpoint]);
    }
    move([0, -49.49/2, 0]) {
      cuboid([42, 7.31, 30], anchor=FRONT) {
        align(LEFT, FRONT) cuboid([3, 7.31 + pre_made_hirth_dia + 10, 30], rounding=6, edges=[TOP+BACK, BOTTOM+BACK]);
        align(RIGHT, FRONT) cuboid([10, 7.31, 30], rounding=0, edges=[TOP+BACK, BOTTOM+BACK]);
        left((43 - slide_len) / 2 + 2.5) attach(FWD, spin=90) dovetail("male", slide=slide_len, width=slide_width, height=dovetail_height, slope=slide_slope, entry_slot_length=slide_len + slide_entry_slot_extra_length, $slop=clearance_loose);
      }
    }

    back(3.75) down(0) hirth(32,pre_made_hirth_inner_dia/2,pre_made_hirth_dia/2);
  };

  Arm(85);

  // !union() {
  //   // up(15) import(".\\vendor\\multifunction-arm-mounting-system\\holder-small-nuts-18-18-M4.stl", convexity=10, center=true);
  //   // right(21) rotate([0, 90, 0]) ruler(length=30);
  //   up(2.7825) hirth(32,pre_made_hirth_inner_dia/2,pre_made_hirth_dia/2, rot=true);
  //   cube([50, 20, 1 + 3.5651]);
  // }

  // !hirth(32,pre_made_hirth_inner_dia/2,pre_made_hirth_dia/2, rot=true);
}