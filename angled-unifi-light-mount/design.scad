include <shared.scad>;
// SELECT 8G x 18MM 304 CSK screws
// select nail in anchor

screw_hole_dr=1.2 * inch;
screw_hole_pad_size=15;
half_screw_hole_pad_size=screw_hole_pad_size/2;
angle=56;
mount_rot=[0,angle,0];
_mnt_x_tran=sin(angle) * (screw_hole_dr + half_screw_hole_pad_size);
mount_tran=[
    min(_mnt_x_tran, screw_hole_dr/2),
    0,
    sin(angle) * (screw_hole_dr + half_screw_hole_pad_size)
];

echo(screw_hole_dr);
echo(screw_hole_dr*2);
echo(mount_tran);

module CameraRing() {
    difference() {
        render() union() {
            translate([0,0,3]) linear_extrude(3) projection(true) translate([0,0,-3]) import("base_plate.stl", convexity=3);
            import("base_plate_fixed.stl", convexity=3);

            cylinder_outer(6, half_screw_hole_pad_size);
            w=80;
            rotate([0,0,45]) translate([-w/2,-3,0]) cube([w,6,6]);
            rotate([0,0,-45]) translate([-w/2,-3,0]) cube([w,6,6]);

            translate([0, 0, 3]) {
                translate([-screw_hole_dr, 0, 0]) translate([0,0,3.2]) rotate([180,0,0]) cylinder_outer(6, 12/2);
                translate([screw_hole_dr, 0, 0]) translate([0,0,3.2]) rotate([180,0,0]) cylinder_outer(6, 12/2);
                translate([0, -screw_hole_dr, 0]) translate([0,0,3.2]) rotate([180,0,0]) cylinder_outer(6, 12/2);
                translate([0, screw_hole_dr, 0]) translate([0,0,3.2]) rotate([180,0,0]) cylinder_outer(6, 12/2);   
            }
        }
        translate([-screw_hole_dr, 0, 0]) translate([0,0,3.2]) rotate([180,0,0]) CounterSunkScrew(3.5, 18, 3.2, 8);
        translate([screw_hole_dr, 0, 0]) translate([0,0,3.2]) rotate([180,0,0]) CounterSunkScrew(3.5, 18, 3.2, 8);
        translate([0, -screw_hole_dr, 0]) translate([0,0,3.2]) rotate([180,0,0]) CounterSunkScrew(3.5, 18, 3.2, 8);
        translate([0, screw_hole_dr, 0]) translate([0,0,3.2]) rotate([180,0,0]) CounterSunkScrew(3.5, 18, 3.2, 8);

        cylinder_outer(6, 5/2);
        cylinder_outer(3, 10/2);
    }
}

module WallMount() {
    difference() {
        union() {
            hull() {
                // base part
                cylinder_outer(6, half_screw_hole_pad_size);
                translate([-screw_hole_dr, 0, 0]) cylinder_outer(6, half_screw_hole_pad_size);
                translate([+screw_hole_dr, 0, 0]) cylinder_outer(6, half_screw_hole_pad_size);
                translate([0, -screw_hole_dr * 2, 0]) cylinder_outer(6, half_screw_hole_pad_size);
            }

            hull() {
                // base
                translate([-screw_hole_dr, 0, 0]) cylinder_outer(6, half_screw_hole_pad_size);
                translate([+screw_hole_dr, 0, 0]) cylinder_outer(6, half_screw_hole_pad_size);
                // rotated
                translate(mount_tran) rotate(mount_rot) {
                    translate([-screw_hole_dr, 0, 0]) cylinder_outer(6, half_screw_hole_pad_size);
                    translate([+screw_hole_dr, 0, 0]) cylinder_outer(6, half_screw_hole_pad_size);
                }
             }
        }

        // nail-in anchor hole
        translate([0,-screw_hole_dr,0]) {
            translate([0,0,0]) cylinder_outer(6, 5/2);
            translate([0,0,3]) cylinder_outer(3, 10/2);
        }

        // for screws
        // module CounterSunkScrew(screw_dia, screw_len, csc_len, csc_head_dia, screw_z_offset=de_minimis) {
        // translate([0, screw_hole_dr, 0]) CounterSunkScrew(3.5, 18, 3.2, 8);
        screw_len=18;
        translate(mount_tran) rotate(mount_rot) {
            translate([-screw_hole_dr, 0, -screw_len + 6]) cylinder_outer(screw_len, 3.5 / 2);
            translate([screw_hole_dr, 0, -screw_len + 6]) cylinder_outer(screw_len, 3.5 / 2);
        }

    }
    
}

CameraRing();
// WallMount();