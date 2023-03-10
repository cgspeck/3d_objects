include <shared.scad>

shell_thickness=min_thickness;

vac_open_id=35.6;
vac_inside_id=35;
vac_len=31;

sander_inside_id=23.1 + 0.2 + 2 * clearance_tight;
sander_open_id=24 + 2 * clearance_tight;
sander_len=20;
//calculated
transition_len=vac_inside_id - sander_inside_id;
vac_open_od=vac_open_id + 2 * shell_thickness;
vac_inside_od=vac_inside_id + 2 * shell_thickness;
sander_inside_od=sander_inside_id + 2 * shell_thickness;
sander_open_od=sander_open_id + 2 * shell_thickness;

difference() {
    union() {
        // vac part
        cone_outer(vac_len, vac_open_od/2, vac_inside_od/2);
        // transition
        translate([0,0,vac_len]) cone_outer(transition_len, vac_inside_od/2, sander_inside_od/2);
        // sander part
        translate([0,0,vac_len + transition_len]) cone_outer(sander_len, sander_inside_od/2, sander_open_od/2);
    }
    // vac part
    translate([0,0,-de_minimis]) cone_outer(vac_len + de_minimis, vac_open_id/2, vac_inside_id/2);
    // transition
    translate([0,0,vac_len - de_minimis]) cone_outer(transition_len + de_minimis, vac_inside_id/2, sander_inside_id/2);
    // sander part
    translate([0,0,vac_len + transition_len - de_minimis]) cone_outer(sander_len + de_minimis * 2, sander_inside_id/2, sander_open_id/2);
}
