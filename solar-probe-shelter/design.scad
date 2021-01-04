fn=72*4;
$fn=fn;

module cylinder_outer(height,radius,fn=fn) {
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

module cone_outer(height,radius1,radius2,fn=fn) {
   fudge = 1/cos(180/fn);
   cylinder(h=height,r1=radius1*fudge,r2=radius2*fudge,$fn=fn);
}

pipe_od=58.45;
clearance_loose=0.4;
clearance_tight=0.2;
min_thickness=2.4;
de_minimus=0.1;

holder_half_x=(pipe_od / 2) + clearance_tight + min_thickness;

roof_width=max(100, holder_half_x * 2);
roof_rise=40;
roof_len=100;

// select 4.8mm 250mm zip ties
zip_tie_width=4.8 + 1;
zip_tie_thickness=1.8 + 0.5;

holder_z=zip_tie_width * 2;

module _pipeCylinder(holder_z, pipe_od, holder_half_x) {
    difference() {
        cylinder_outer(holder_z, holder_half_x);
        cylinder_outer(holder_z, (pipe_od / 2) + clearance_loose);
    }
}

module pipeHolder(pipe_top_distance) {
    holder_tran=[
        0,
        -(pipe_od / 2 + clearance_loose + pipe_top_distance),
        0,
    ];

    translate(holder_tran) {
        difference() {
            _pipeCylinder(holder_z, pipe_od, holder_half_x);
            half_cube_dim=[holder_half_x * 2,holder_half_x, holder_z];
            half_cube_tran=[-half_cube_dim.x / 2,-holder_half_x,0];
            translate(half_cube_tran) cube(half_cube_dim);
        }
    }
}

module posts(pipe_lower_apex_distance) {
    c_tran_1=[
        -(pipe_od / 2 + min_thickness + clearance_tight),
        -pipe_lower_apex_distance - pipe_od / 2,
        0
    ];
    translate(c_tran_1) cube([min_thickness, (pipe_lower_apex_distance + pipe_od), holder_z]);
    c_tran_2=[
        (pipe_od / 2 + clearance_tight),
        -pipe_lower_apex_distance - pipe_od / 2,
        0
    ];
    translate(c_tran_2) cube([min_thickness, (pipe_lower_apex_distance + pipe_od), holder_z]);
}

module Roof(mask=false, length=0) {
    d_y = mask ? 200 : min_thickness;
    under_pts_xy = [
        [0,-min_thickness],
        [roof_width/2, -roof_rise],
        [roof_width/2, -roof_rise + d_y],
        [0, 0],
        [-roof_width/2, -roof_rise + d_y],
        [-roof_width/2, -roof_rise],
    ];
    linear_extrude(length) polygon(points=under_pts_xy);
}

module zipTieLoop(pipe_top_distance) {
    zip_tie_tran=[
        0,
        -(pipe_od / 2 + clearance_loose + pipe_top_distance),
        (holder_z - (zip_tie_width - clearance_loose /2)) / 2
    ];
    translate(zip_tie_tran) difference() {
        cylinder_outer(zip_tie_width, holder_half_x + zip_tie_thickness);
        cylinder_outer(zip_tie_width, holder_half_x);
    }
}

module Frame(pipe_lower_apex_distance) {
    difference() {
        union() {
            pipeHolder(pipe_lower_apex_distance);

            difference() {
                posts(pipe_lower_apex_distance);
                Roof(mask=true, length=holder_z);
            }
            Roof(mask=false, length=holder_z);
        }
        zipTieLoop(pipe_lower_apex_distance);
    }
}

Frame(50);

translate([0, 20, 0]) Roof(mask=false, length=roof_len);

