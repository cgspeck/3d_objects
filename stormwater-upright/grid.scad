module Grid(size=[100, 100, 10], pitch_x=11.2, pitch_y=11.2, thickness_x=1.2, thickness_y=1.2) {
    xs = size.x / pitch_x;
    ys = size.y / pitch_y;

    translate([-pitch_x / 2 + thickness_x, 0, 0]) {
        for (i=[1:xs]) {
            translate([
                i * pitch_x,
                0,
                0
            ]) cube([thickness_x, size.y, size.z]);
        }
    }

    translate([0, -pitch_y / 2 + thickness_y, 0]) {
        for (i=[1:ys]) {
            translate([
                0,
                i * pitch_y,
                0
            ]) cube([size.x, thickness_y, size.z]);
        }   
    }
}

module CircularGrid(radius, d_z, pitch_x=11.2, pitch_y=11.2, thickness_x=1.2, thickness_y=1.2, fn=72) {
    module cylinder_outer(height,radius,fn){
        fudge = 1/cos(180/fn);
        cylinder(h=height,r=radius*fudge,$fn=fn);
    }

    intersection() {
        cylinder_outer(d_z, radius, fn);
        translate([-radius, -radius, 0]) Grid([radius * 2, radius * 2, d_z], pitch_x, pitch_y, thickness_x, thickness_y);
    }
}

CircularGrid(100, 10);