include <shared.scad>

shell_thickness=min_thickness;

vac_open_id=35.6;
vac_inside_id=35;
vac_len=31;

// measured of vac bag that comes with the saw
appliance_inside_id=36.9;
appliance_open_id=37.2;
appliance_len=25;
//calculated
transition_len=abs(vac_inside_id - appliance_inside_id);
vac_open_od=vac_open_id + 2 * shell_thickness;
vac_inside_od=vac_inside_id + 2 * shell_thickness;
appliance_inside_od=appliance_inside_id + 2 * shell_thickness;
appliance_open_od=appliance_open_id + 2 * shell_thickness;

difference() {
    union() {
        // vac part
        cone_outer(vac_len, vac_open_od/2, vac_inside_od/2);
        // transition
        translate([0,0,vac_len]) cone_outer(transition_len, vac_inside_od/2, appliance_inside_od/2);
        // sander part
        translate([0,0,vac_len + transition_len]) cone_outer(appliance_len, appliance_inside_od/2, appliance_open_od/2);
    }
    // vac part
    translate([0,0,-de_minimis]) cone_outer(vac_len + de_minimis, vac_open_id/2, vac_inside_id/2);
    // transition
    translate([0,0,vac_len - de_minimis]) cone_outer(transition_len + de_minimis, vac_inside_id/2, appliance_inside_id/2);
    // sander part
    translate([0,0,vac_len + transition_len - de_minimis]) cone_outer(appliance_len + de_minimis * 2, appliance_inside_id/2, appliance_open_id/2);
}
