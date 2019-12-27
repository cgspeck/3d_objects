use <MCAD/regular_shapes.scad>

cap_od=24.5;
cap_z=2.2;

socket_z=4.3;

min_thickness=2.4;
fn=72 * 4;
$fn=fn;

module cylinder_outer(height,radius,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

module NotchedPoolCapSocket(socket_od) {
    cap_or=cap_od / 2;
    cylinder_outer(cap_z, cap_or);
    socket_r=socket_od / 2;
    total_z=socket_z + cap_z;
    difference() {
        cylinder(r=socket_r, h=total_z);
        cylinder(r=socket_r - min_thickness, h=total_z);

        large_r=cap_od;

        poly_xy_pts=[
            [0, 0],
            [large_r * sin(0), large_r * cos(0)],
            [large_r * sin(120), large_r * cos(120)],
        ];

        linear_extrude(total_z) polygon(poly_xy_pts);
    }
}

NotchedPoolCapSocket(18);
