include <BOSL2/std.scad>

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
min_thickness=1.2;
wall_thickness=min_thickness;
epsilon=0.01;

internal_cone_height=10;
external_cone_height=internal_cone_height + wall_thickness * 2;
cone_bottom_od = pipe_od + wall_thickness * 6;
cone_bottom_id = pipe_od + (wall_thickness + clearance_tight) * 2;
base_od = cone_bottom_id - clearance_tight * 2;
internal_clearance_d = pipe_od - internal_cone_height * 2;
echo("internal_clearance_d", internal_clearance_d);

// select 4.8mm 250mm zip ties
zip_tie_width=4.8 + 1 + 1;
zip_tie_thickness=1.8 + 0.5 + 1;

module Shield(is_top=false) {
    difference() {
        union() {
            cone_outer(external_cone_height, 
                pipe_od / 2 - internal_cone_height, 
                cone_bottom_od / 2
            );
            if (!is_top) {
                intersection() {
                    cylinder_outer(internal_cone_height + min_thickness, pipe_od / 2 + wall_thickness);
                    cube_z=internal_cone_height + min_thickness;//wall_thickness + epsilon * 2;
                    rotate_count=6;
                    rotate_seg=360/rotate_count;
                    translate([0, 0, cube_z / 2]) {
                        for (i=[1:rotate_count]) {
                            rotate([0, 0, rotate_seg * i]) cube([pipe_od + wall_thickness * 2, 2.4, cube_z], center=true);
                        }
                    }
                }
            }
        }

        if (!is_top) {
            translate([0, 0, -epsilon]) cone_outer(
                internal_cone_height + wall_thickness + epsilon * 2, 
                pipe_od / 2 - internal_cone_height - wall_thickness, 
                pipe_od / 2
            );
        } else {
            translate([0, 0, wall_thickness]) cone_outer(internal_cone_height + wall_thickness + epsilon * 2, pipe_od / 2 - internal_cone_height - wall_thickness, pipe_od / 2);
        }
        translate([0, 0, external_cone_height - min_thickness])  cylinder_outer(min_thickness, cone_bottom_id / 2);
    }
}

module RoofV2() {
    Shield(is_top=true);
}

module _ziptie(id, wall_override) {
    _wall = is_undef(wall_override) ? zip_tie_thickness : wall_override;
    tube(zip_tie_width, wall=zip_tie_thickness, id=id);
}

module Base() {
    zip_tie_height = 5.2;
    base_height = pipe_od / 2 + zip_tie_height + wall_thickness;
    wire_width = 4;
    wire_thickness = 1.4;
    wire_extra_thickness = 10;
    difference() {
        union() {
            cylinder_outer(base_height, base_od/2);
        }
        left(base_od/2 + epsilon) yrot(90) cylinder_outer(base_od + epsilon * 2, pipe_od / 2 );
        cylinder_outer(base_height + epsilon + wall_thickness, internal_clearance_d / 2);
        up(wall_thickness) left(internal_clearance_d / 2 + zip_tie_thickness + wall_thickness) yrot(90) _ziptie(pipe_od + wall_thickness * 2);
        up(wall_thickness) right(internal_clearance_d / 2 + zip_tie_thickness + wall_thickness) yrot(90) _ziptie(pipe_od + wall_thickness * 2);
        yrot(90) _ziptie(pipe_od);
        up(pipe_od / 2 - wire_extra_thickness)fwd(wire_width/2) left(base_od / 2 + epsilon) cube([base_od + epsilon * 2, wire_width, wire_thickness + wire_extra_thickness]);
        left(base_od / 2) fwd(base_od / 2 + epsilon) cube([base_od, base_od + epsilon * 2, pipe_od / 4]);
    }
}

{
    Shield();
}

fwd(100) {
    Shield(true);
}

fwd(200) {
    Base();
}

!fwd(300) {
    hull() RoofV2();
}