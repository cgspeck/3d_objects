include <shared.scad>;
include <BOSL2/std.scad>;
use <BOSL2/shapes3d.scad>;
use <BOSL2/transforms.scad>;
use <threadlib/threadlib.scad>;

thickness=min_thickness;
rounding=13;
screw_hole_rad=3 / 2 + clearance_loose;
top_lip_z = 3;
top_dim = [260, 185, top_lip_z + 9];
bin_inner_dim = [246, 170, 85];
piece_inner_dim = bin_inner_dim + [-thickness * 2, -thickness * 2, epsilon * 2];
inner_outer_y_diff = (top_dim.y - piece_inner_dim.y) / 2;
hook_hole_dim = [7, top_dim.y + epsilon * 2, 5];
hook_clearance_dim = [30, inner_outer_y_diff - (thickness + epsilon), top_dim.z - top_lip_z + epsilon];

difference() {
    difference() {
        union() {
            roundedCube(top_dim, rounding, true);
            translate([(top_dim.x - bin_inner_dim.x) / 2, (top_dim.y - bin_inner_dim.y) / 2, 0]) roundedCube(bin_inner_dim, rounding, true);
        }
        translate([(top_dim.x - piece_inner_dim.x) / 2, (top_dim.y - piece_inner_dim.y) / 2, -epsilon]) roundedCube(piece_inner_dim, rounding, true);
        translate([
            (top_dim.x - hook_hole_dim.x) / 2, 
            -epsilon, 
            top_dim.z - hook_hole_dim.z - top_lip_z
        ]) cube(hook_hole_dim);
        translate([
            (top_dim.x - hook_clearance_dim.x) / 2, 
            -epsilon, 
            -epsilon
        ]) cube(hook_clearance_dim);
        translate([
            (top_dim.x - hook_clearance_dim.x) / 2, 
            top_dim.y -hook_clearance_dim.y + epsilon, 
            -epsilon
        ]) cube(hook_clearance_dim);
        translate([top_dim.x / 3, 0, bin_inner_dim.z / 2]) rotate([270,0,0]) cylinder_outer(top_dim.y, screw_hole_rad);
        translate([top_dim.x / 3 * 2, 0, bin_inner_dim.z / 2]) rotate([270,0,0]) cylinder_outer(top_dim.y, screw_hole_rad);
        translate([0, top_dim.y / 2, bin_inner_dim.z / 2]) rotate([0,90,0]) cylinder_outer(top_dim.x, screw_hole_rad);
    }
    #cube([35, 400, 200]);
    #cube([400, 20, 200]);
}
