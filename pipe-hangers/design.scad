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

pipe_od=76;
clearance_loose=0.4;
clearance_right=0.2;
min_thickness=2.4;
de_minimus=0.1;

// select #8 gauge
screw_hole_dia=4.8;
screw_countersink_height=3.5;
screw_countersink_max_dia=8.2;

holder_z=10;
holder_half_x=(pipe_od / 2) + clearance_loose + min_thickness;

// select 4.8mm 250mm zip ties
zip_tie_width=4.8;
zip_tie_thickness=1.8;

module screwMount(side, pad_only=false) {
    mount_dim=[
        (screw_hole_dia + clearance_loose) * 3,
        (screw_hole_dia + clearance_loose) * 3,
        screw_countersink_height + min_thickness * 2
    ];
    mount_tran=[
        (mount_dim.x/2 + pipe_od/2 + clearance_loose) * side,
        mount_dim.y / 2,
        mount_dim.z / 2,
    ];

    translate(mount_tran) {
        if (pad_only) {
            translate([0, -(mount_dim.y/2 - de_minimus), 0]) cube([
                mount_dim.x,
                de_minimus,
                mount_dim.z
            ], true);
        } else {
            difference() {
                cube(mount_dim, true);
                translate([0,0,-mount_dim.z / 2]) cylinder_outer(mount_dim.z, (screw_hole_dia + clearance_loose) / 2);
                translate([0,0,-mount_dim.z / 2]) cone_outer(screw_countersink_height, (screw_countersink_max_dia + clearance_loose) / 2, (screw_hole_dia + clearance_loose) / 2);
            }
        }
    }    
}

module _pipeCylinder(holder_z, pipe_od, holder_half_x) {
    difference() {
        cylinder_outer(holder_z, holder_half_x);
        cylinder_outer(holder_z, (pipe_od / 2) + clearance_loose);
    }
}

module pipeHolder(pipe_top_distance, pad_only=false, side=0) {
    holder_tran=[
        0,
        -(pipe_od / 2 + clearance_loose + pipe_top_distance),
        0,
    ];
    
    translate(holder_tran) {
        if (pad_only) {
            cube_dim=[
                min_thickness * 2,
                de_minimus,
                holder_z
            ];
            cube_tran=[
                (pipe_od / 2 + clearance_loose + cube_dim.x / 4) * side,
                0,
                cube_dim.z / 2
            ];
            intersection() {
                _pipeCylinder(holder_z, pipe_od, holder_half_x);
                translate(cube_tran) cube(cube_dim, center=true);
            }
            
        } else {
            difference() {
                _pipeCylinder(holder_z, pipe_od, holder_half_x);
                half_cube_dim=[holder_half_x * 2,holder_half_x * 2,holder_z];
                half_cube_tran=[-half_cube_dim.x / 2,0,0];
                translate(half_cube_tran) cube(half_cube_dim);
            }
        }

        
    }
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

module Hanger(pipe_top_distance) {
    difference() {
        union() {
            hull() {
                screwMount(-1, true);
                pipeHolder(pipe_top_distance, true, -1);
            }
            hull() {
                screwMount(1, true);
                pipeHolder(pipe_top_distance, true, 1);
            }
            screwMount(-1);
            screwMount(1);
            pipeHolder(pipe_top_distance);
        }
        zipTieLoop(pipe_top_distance);
    }
}

distances=[
    48,
    73,
    99,
    120,
    210,
];

for (i=[0:len(distances) - 1]) {
    translate([120 * i, 0, 0]) Hanger(distances[i]);
}
