include <shared.scad>

include <BOSL2/std.scad>
include <BOSL2/threading.scad>

hand_screw_nut_d=21.6;
hand_screw_nut_h=8;
screw_rod_l=30;
screw_rod_pitch=1.25;

screw_thread_d=8;
screw_nut_height=screw_thread_d / 2;
clamp_nut_flat_d=screw_thread_d*2;
cradle_thickness=7;

min_phone_thickness_no_case=9;
max_phone_thickness_with_case=16.5;
phone_naked_case_diff=max_phone_thickness_with_case-min_phone_thickness_no_case;
phone_naked_case_diff_per_side=phone_naked_case_diff/2;
phone_clamp_additional_per_side=2;
clamp_edge_over=1.2;
clamp_y_min=2;
clamp_x_max=max_phone_thickness_with_case 
  + phone_clamp_additional_per_side * 2
  + clamp_edge_over * 2;
clamp_y_max=clamp_y_min 
  + phone_naked_case_diff_per_side 
  + phone_clamp_additional_per_side ;
side_clamp_rail_width=16;
side_clamp_rail_height=4;

side_clamp_width=28;
bottom_clamp_width=15;

side_holder_width=28;
echo("side_holder_width", side_holder_width);
side_holder_length=min_thickness + clearance_loose * 2 + hand_screw_nut_h + clearance_loose * 2 + min_thickness;
echo("side_holder_length", side_holder_length);


echo("clamp_x_max", clamp_x_max);
echo("clamp_y_max", clamp_y_max);
clamp_base_offset=1;

clamp_slide_len = clamp_y_max * 1.5;
clamp_slide_slope = 2;
clamp_slide_width = bottom_clamp_width;
clamp_dovetail_height = 4;
clamp_entry_len = clamp_slide_len + 2;
clamp_total_dovetail_len=clamp_slide_len + clamp_entry_len;

echo("clamp_slide_len", clamp_slide_len);
echo("clamp_entry_len", clamp_entry_len);
echo("clamp_total_dovetail_len", clamp_total_dovetail_len);

base_cnr_radius=2;
// I know the var below makes no sense, naming things is hard
// these two below are needed to co-ordinate the base translation and objects
mount_arm_plate_z=6.39;
base_phone_side_arms_z=clamp_dovetail_height + $slop;

clamp_pts = [
  [0, 0],
  [clamp_x_max, 0],
  [clamp_x_max + clamp_base_offset, 0],
  [clamp_x_max + clamp_base_offset, clamp_y_max],
  [clamp_x_max - clamp_edge_over, clamp_y_max],
  [clamp_x_max
    - phone_naked_case_diff_per_side 
    - phone_clamp_additional_per_side, clamp_y_max - phone_naked_case_diff_per_side - phone_clamp_additional_per_side],
  [clamp_x_max 
    - phone_naked_case_diff_per_side 
    - phone_clamp_additional_per_side 
    - min_phone_thickness_no_case
    , clamp_y_max - phone_naked_case_diff_per_side - phone_clamp_additional_per_side],
  [0 + clamp_edge_over, clamp_y_max],
  [0, clamp_y_max],
];

module _clamp(width) {
  echo(clamp_pts);
  linear_extrude(width) polygon(clamp_pts);
}

module _sliding_clamp_H() {
  difference() {
    cuboid([side_clamp_rail_height + epsilon, clamp_y_max, side_clamp_width]);
    right(epsilon) cuboid([
      side_clamp_rail_height + epsilon,
      clamp_y_max + 2 * epsilon,
      side_clamp_rail_width + 2 * clearance_loose
    ]);
  }
}

module FixedBottomClamp() {
  m_clamp_width=bottom_clamp_width;
  union() {
    _clamp(m_clamp_width);
    back(clamp_slide_len / 2)
      right(clamp_x_max + clamp_base_offset)
      up(m_clamp_width/2)
      yrot(90)
      dovetail(
        "male",
        slide=clamp_slide_len,
        width=clamp_slide_width,
        height=clamp_dovetail_height,
        slope=clamp_slide_slope,
        entry_slot_length=clamp_slide_len + 2,
        $slop=clearance_loose
      );
  }
}

module SideClampWithScrew() {
  m_clamp_width=side_clamp_width;
  union() {
    _clamp(m_clamp_width);
    up(side_clamp_width / 2)
      right((clamp_x_max + clamp_base_offset) / 2)
      fwd(screw_rod_l / 2 - epsilon)
      xrot(90)
      trapezoidal_threaded_rod(
        d=screw_thread_d, 
        l=screw_rod_l,
        pitch=screw_rod_pitch
      );
    back(clamp_y_max / 2)
      right(clamp_x_max + clamp_base_offset)
      up(m_clamp_width/2)
      yrot(90)
      dovetail(
        "male",
        slide=clamp_y_max,
        width=clamp_slide_width - (clearance_loose * 2  - epsilon * 2),  // manually decrease by clearance_loose * 2  - epsilon * 2 so it slides (hopefully)
        height=clamp_dovetail_height,
        slope=clamp_slide_slope,
        $slop=clearance_loose
    );
  }  
}

module _rod_holder_upper_part() {
  // z_offset=clamp_base_offset + clamp_x_max / 2;
  z_offset=(clamp_base_offset + clamp_x_max) / 2;
  echo("_rod_holder_upper_part: z_offset", z_offset);
  difference() {
    hull() {
      up(min_thickness / 2) cuboid([side_clamp_width, min_thickness, min_thickness]);
      up(z_offset) 
        xrot(90)
        cyl(h=min_thickness, d=screw_thread_d * 2 + clearance_loose * 2);
    }
    left(epsilon) 
      up(z_offset)
      xrot(90)
      cyl(h=min_thickness + 2 * epsilon, d=screw_thread_d + 2 * clearance_loose);
  }
}

module SideRodHolder() {
  // upper_part_dist = hand_screw_nut_h + 2 * clearance_loose;
  upper_part_dist = side_holder_length;
  back(upper_part_dist/2) union() {
    fwd(min_thickness / 2) _rod_holder_upper_part();
    fwd(upper_part_dist - min_thickness / 2) _rod_holder_upper_part();
    fwd(upper_part_dist / 2)
      right(0)
      down(0)
      yrot(180)
      dovetail(
        "male",
        slide=upper_part_dist,
        width=clamp_slide_width,
        height=clamp_dovetail_height,
        slope=clamp_slide_slope,
        $slop=clearance_loose
    );
  }
}

module HandNut(tex_size) {
  difference() {
    cyl(
      h=hand_screw_nut_h,
      d=hand_screw_nut_d,
      texture="trunc_diamonds",
      tex_size=[tex_size,tex_size],
      tex_inset=true
    );

    trapezoidal_threaded_rod(
      d=screw_thread_d, 
      l=screw_rod_l,
      pitch=screw_rod_pitch,
      internal=true
    );
  }
}

module _base_arm_mount(z) {
  arm_plate_x=30;
  arm_plate_y=42;
  arm_plate_y_blocked=9;
  arm_plate_y_slide_len=9;
  arm_plate_y_entry=9;

  //inner cutout where the arm's plate will fit
  inner_cutout_x = arm_plate_x + 2 * clearance_loose;
  inner_cutout_y = clearance_loose + arm_plate_y_blocked + arm_slide_len + arm_slide_len + arm_plate_y_entry + clearance_loose;

  outer_coutout_x = inner_cutout_x + max(base_cnr_radius * 2, min_thickness);
  outer_cutout_y = inner_cutout_y + max(base_cnr_radius * 2, min_thickness);

  diff() {
    cuboid([
      outer_coutout_x,
      outer_cutout_y,
      z
    ],
      rounding=base_cnr_radius,
      except=[TOP, BOT]
    )
    tag("remove") down(min_thickness / 2) cuboid([
      inner_cutout_x,
      inner_cutout_y,
      z - min_thickness
    ]);
    echo("arm_dovetail_height", arm_dovetail_height);
    tag("keep") 
      up(min_thickness)
      down(0.6) // no idea where this comes from
      back(inner_cutout_y / 2 - arm_slide_len / 2 - arm_plate_y_entry - clearance_loose)
      xrot(0) 
      yrot(180)
      dovetail(
        "male",
        slide=arm_slide_len,
        width=arm_slide_width,
        height=arm_dovetail_height,
        slope=arm_slide_slope,
        entry_slot_length=arm_slide_len + 2,
        $slop=clearance_loose
    );
  }
}

module _base_phone_side_arms(z) {
  phone_width_with_case=83;
  width_allowance=2;
  echo("clamp_y_max - clamp_y_min", clamp_y_max - clamp_y_min);
  side_holder_inner_dist_apart=(
    // space for the parts that hold the rod
    clamp_y_max - clamp_y_min + // clamp clearance
    phone_width_with_case +  // the phone itsel
    clamp_y_max - clamp_y_min + // clamp clearance
    width_allowance
  );
  echo("side_holder_inner_dist_apart", side_holder_inner_dist_apart);
  echo("side_holder_width", side_holder_width);
  side_holder_slide_len=(
    side_holder_inner_dist_apart+side_holder_length * 2
  );
  echo("side_holder_slide_len", side_holder_slide_len);

  outer_x=side_holder_slide_len + 2 * max(base_cnr_radius * 2, min_thickness);
  outer_y=clamp_slide_width 
    + 2 * $slop
    + 2 * max(base_cnr_radius * 2, min_thickness);
  base_phone_side_arms_z=base_phone_side_arms_z;


  diff() {
    cuboid([
      outer_x,
      outer_y,
      z
    ],
      rounding=base_cnr_radius,
      except=[TOP, BOT]
    );

    up(min_thickness) { 
      tag("remove") 
        up((clamp_dovetail_height + $slop)/ 2)
        rot(90)
        dovetail(
          "female",
          slide=side_holder_slide_len,
          width=clamp_slide_width,
          height=clamp_dovetail_height,
          slope=clamp_slide_slope,
          entry_slot_length=0,
      );
      tag("remove") cuboid([
        20,
        clamp_slide_width + $slop * 2,
        base_phone_side_arms_z
      ]);
    }
  }
}


module _base_phone_bottom_slot(z) {
  inner_x=clamp_slide_width;
  inner_y=clamp_slide_len + clamp_slide_len + 2 + 2 * $slop;

  outer_x=inner_x + max(base_cnr_radius * 2, min_thickness);
  outer_y=inner_y 
    + max(base_cnr_radius * 2, min_thickness);

  rot(180) diff() {
    cuboid([
      outer_x,
      outer_y,
      z
    ],
      rounding=base_cnr_radius,
      except=[TOP, BOT]
    );

    tag("remove") 
      back(clamp_slide_len / 2 + 1)
      up((clamp_dovetail_height + $slop) / 2 + min_thickness)
      rot(0)
      dovetail(
        "female",
        slide=clamp_slide_len,
        width=clamp_slide_width,
        height=clamp_dovetail_height,
        slope=clamp_slide_slope,
        entry_slot_length=clamp_slide_len + 2,
    );
  }
}

_base_arm_mount_z_actual=arm_dovetail_height + min_thickness;
_phone_cradle_arms_z_actual=base_phone_side_arms_z + min_thickness;
base_arm_mount_z=max([_base_arm_mount_z_actual, _phone_cradle_arms_z_actual]);
phone_cradle_arms_z=base_arm_mount_z;

// !union() {
//   _base_arm_mount(base_arm_mount_z);
//   _base_phone_side_arms(phone_cradle_arms_z);
// }

// !_base_phone_bottom_slot();

module CradleBase() {
  base_phone_side_arms_z=clamp_dovetail_height + $slop;

  base_tran=[0, 0, -(
    (base_arm_mount_z) / 2 - (phone_cradle_arms_z) / 2
  )];
  echo("base_tran", base_tran);
  top_z_offset=(abs(base_arm_mount_z - phone_cradle_arms_z)) / 2;
  arm_trans=[
    0,
    58,
    0
  ];

  bot_tran=[
    0,
    clamp_slide_len + 1  // 0 out so end of slide is on midpoint of cradle
      - clamp_y_min // less clamp thickness
      - 84, // the actual translation from cradle midpoint, where we want wall of clamp to sit
    0
  ];

  l_r_x_dist = 65;
  l_bot_tran=bot_tran + [-l_r_x_dist / 2, 0, 0];
  r_bot_tran=bot_tran + [l_r_x_dist / 2, 0, 0];

  central_cuboid_dim = [10,10, base_arm_mount_z];
  central_cuboid_trn = [0, 0, 0];
  arm_cuboid_trn = [0, 35, 0];
  echo("central_cuboid_dim", central_cuboid_dim);
  echo("central_cuboid_trn", central_cuboid_trn);
  union() {
    difference() {
      union() {
        hull() {
          translate(base_tran) _base_arm_mount(base_arm_mount_z);
        }
        hull() {
          translate(arm_cuboid_trn) cuboid(central_cuboid_dim);
          translate(arm_trans)  _base_phone_side_arms(phone_cradle_arms_z);
        }
        hull() {
          translate(central_cuboid_trn) cuboid(central_cuboid_dim)
          translate(l_bot_tran) _base_phone_bottom_slot(phone_cradle_arms_z);
        }
        hull() {
          translate(central_cuboid_trn) cuboid(central_cuboid_dim)
          translate(r_bot_tran) _base_phone_bottom_slot(phone_cradle_arms_z);
        }
      }
      union() {
        // all base pieces
        hull() translate(base_tran) _base_arm_mount(base_arm_mount_z);
        hull() translate(arm_trans)  _base_phone_side_arms(phone_cradle_arms_z);
        hull() translate(l_bot_tran) _base_phone_bottom_slot(phone_cradle_arms_z);
        hull() translate(r_bot_tran) _base_phone_bottom_slot(phone_cradle_arms_z);
      }
    }
    // all base pieces
    translate(base_tran) _base_arm_mount(base_arm_mount_z);
    translate(arm_trans) _base_phone_side_arms(phone_cradle_arms_z);
    translate(l_bot_tran) _base_phone_bottom_slot(phone_cradle_arms_z);
    translate(r_bot_tran) _base_phone_bottom_slot(phone_cradle_arms_z);
  }
}

xdistribute(spacing=100) {
  FixedBottomClamp();
  SideClampWithScrew();
  SideRodHolder();
  HandNut(1);
  CradleBase();
}