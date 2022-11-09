include <shared.scad>

door_rebate_rad=11.2;
foo=6;
// select 7g x 30 hinge screws
screw_dia=4.0;
screw_rad=screw_dia / 2 + clearance_loose;

csc_len=2.7;
csc_head_dia=7 + clearance_loose;
csc_sunk_z=1;

rebate_shield_x=foo + door_rebate_rad + 3 * screw_dia;
rebate_shield_y=56;


door_rebate_z=11.2;
door_rebate_add_z=max(min_thickness, csc_len) + csc_sunk_z;
door_rebate_total_z=door_rebate_z+door_rebate_add_z;


difference() {
    roundedCube([rebate_shield_x, rebate_shield_y, door_rebate_total_z], 3.5, true);
    translate([foo + door_rebate_rad,0,0]) rotate([270,0,0]) cylinder_outer(rebate_shield_y, door_rebate_rad);
    translate([foo + door_rebate_rad,0,0]) cube([rebate_shield_x, rebate_shield_y, door_rebate_rad]);
    translate([foo + door_rebate_rad + screw_dia * 1.5, 0, 12]) {
        translate([0,rebate_shield_y/3,0]) rotate([0,0,0]) CounterSunkScrew(screw_dia, door_rebate_total_z, csc_len, csc_head_dia);
        translate([0,rebate_shield_y/3*2,0]) rotate([0,0,0]) CounterSunkScrew(screw_dia, door_rebate_total_z, csc_len, csc_head_dia);
    }   
}

translate([40,0,0]) {
    difference() {
        roundedCube([26.85,73,door_rebate_total_z], 5, true);
        translate([26.85/2, 0, 12]) {
            translate([0,73/3,0]) rotate([0,0,0]) CounterSunkScrew(screw_dia, door_rebate_total_z, csc_len, csc_head_dia);
            translate([0,73/3*2,0]) rotate([0,0,0]) CounterSunkScrew(screw_dia, door_rebate_total_z, csc_len, csc_head_dia);
        }
    }
}
