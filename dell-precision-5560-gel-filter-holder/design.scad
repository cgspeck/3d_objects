include <BOSL2/std.scad>;
include <BOSL2/joiners.scad>
include <BOSL2/walls.scad>
use <BOSL2/shapes3d.scad>;
use <BOSL2/transforms.scad>;


fn=72*4;
$fn=fn;
clearance_tight=0.2;
clearance_loose=0.4;

min_thickness=2.4;

$slop = clearance_tight;
epsilon = 0.001;
frame_thickness = 4;
hole_dia = 3 + clearance_loose;
chasis_dim_xy=[344.40 + clearance_loose * 4, 221.5];
hole_rad = hole_dia / 2;
hole_dist_from_top = 7.5;
frame_over_dim=[4.8, 2.4, 20];
screen_dim=[336.38, 210.24, 2.4 + epsilon * 2];

bottom_margin=3.5;
rounding=2;

frame_dim=[chasis_dim_xy.x, chasis_dim_xy.y, 0] + frame_over_dim;
chasis_dim=[chasis_dim_xy.x, chasis_dim_xy.y, frame_dim.z - screen_dim.z + epsilon];
echo("chasis_dim", chasis_dim);
echo("frame_dim", frame_dim);

top_margin=(chasis_dim.y - screen_dim.y) - bottom_margin;
side_margin=(chasis_dim.x - screen_dim.x) / 2;
echo("top_margin", top_margin);
echo("bottom_margin", bottom_margin);
echo(frame_dim.x);
echo(screen_dim.x);
echo("X", (frame_dim.x - screen_dim.x) / 2);

module Frame() {
diff() {
    cuboid(frame_dim, rounding=rounding, except=[TOP, BOT], anchor=BOTTOM+FRONT+LEFT);
    tag("remove")
        back(bottom_margin)
        down(epsilon)
        right((frame_dim.x - screen_dim.x) / 2)
        cuboid(screen_dim, anchor=BOTTOM+FRONT+LEFT);
    tag("remove")
        back(0)
        right((frame_dim.x - chasis_dim.x) / 2)
        up(screen_dim.z - epsilon)
        cuboid(chasis_dim, anchor=BOTTOM+FRONT+LEFT);
    tag("remove")
        back(frame_dim.y)
        up(frame_dim.z)
        down(hole_dist_from_top)
        right(frame_dim.x / 4)
        teardrop(r=hole_rad, h=20);
    tag("remove")
        back(frame_dim.y)
        up(frame_dim.z)
        down(hole_dist_from_top)
        right(frame_dim.x / 4 * 3)
        teardrop(r=hole_rad, h=20);
    tag("remove")
        back(frame_dim.y / 4)
        up(frame_dim.z)
        down(hole_dist_from_top)
        right(frame_dim.x/2)
        zrot(90)
        teardrop(r=hole_rad, h=frame_dim.x * 2);
    tag("remove")
        back(frame_dim.y / 4 * 3)
        up(frame_dim.z)
        down(hole_dist_from_top)
        right(frame_dim.x/2)
        zrot(90)
        teardrop(r=hole_rad, h=frame_dim.x * 2);
    }
}

module BottomChannel() {
    chan_len=300;
    up(screen_dim.z + 1.2 + epsilon) xrot(180) diff() {
        cuboid([chan_len, bottom_margin + 2.4 + clearance_tight * 2, screen_dim.z + 1.2], anchor=BOTTOM+FRONT+LEFT);
        tag("remove") back(1.2) cuboid([chan_len, bottom_margin + clearance_tight * 2, screen_dim.z], anchor=BOTTOM+FRONT+LEFT);
    }
}

module TopChannel() {
    chan_len=80;
    zrot(180) up(screen_dim.z + 1.2 + epsilon) xrot(180) diff() {
        cuboid([chan_len, top_margin + 2.4 + clearance_tight * 2, frame_dim.z + 1.2], anchor=BOTTOM+FRONT+LEFT);
        tag("remove") back(1.2) cuboid([chan_len, top_margin + clearance_tight * 2, frame_dim.z], anchor=BOTTOM+FRONT+LEFT);
        tag("remove") back(0) cuboid([chan_len, 1.2, frame_dim.z - screen_dim.z], anchor=BOTTOM+FRONT+LEFT);
    }
}



ydistribute(150) {
    right(frame_dim.x / 2 - 150) BottomChannel();

    xdistribute(50) {
        fwd(frame_dim.y/2) intersection() {
            cube([frame_dim.x / 2, frame_dim.y, frame_dim.z]);
            Frame();
        }
        fwd(frame_dim.y/2) intersection() {
            right(frame_dim.x / 2) cube([frame_dim.x / 2, frame_dim.y, frame_dim.z]); 
            Frame();
        }
    }

    right(frame_dim.x / 2 + 40) TopChannel();
}
