min_thickness=1.2;
2min_thickness=2 * min_thickness;
clearance_tight=0.2;
clearance_loose=0.4;
fn=72 * 4;
$fn=fn;

lower_section_id=10.9 + (2 * clearance_loose);
lower_section_z=17.1;
lower_screw_distance_from_top_z=4.6;
lower_screw_diameter=4.2 + (2 * clearance_loose);

upper_section_id=9.2 + (2 * clearance_tight);
upper_section_z=lower_section_z * 3;

max_or=max(upper_section_id / 2, lower_section_id / 2) + 2min_thickness;

ziptie_xy=2;
ziptie_z=3;

module cylinder_outer(height,radius,center=false){
    fudge = 1/cos(180/fn);
    cylinder(h=height,r=radius*fudge, center=center);
}

total_z = lower_section_z + upper_section_z;

module ZipTieCutThrough() {
    translate([-max_or, -max_or - 2min_thickness, 0]) cube([max_or * 2, ziptie_xy, ziptie_z]);
}

difference() {
    union() {
        hull() {
            cylinder_outer(total_z, max_or);
            #translate([-lower_screw_diameter / 2, -max_or - ziptie_xy * 3, 0]) cube([2min_thickness * 3, ziptie_xy * 2, total_z]);
        }
    }
    // lower section
    cylinder_outer(lower_section_z, lower_section_id / 2);
    // upper section
    translate([0, 0, lower_section_z]) {
        cylinder_outer(upper_section_z, upper_section_id / 2);
    }

    translate([-max_or - .5, 0, 0]) cube([max_or * 2 + 1, max_or + 1, total_z]);

    translate([0, 0, 2min_thickness]) ZipTieCutThrough();

    translate([0, 0, lower_section_z - ziptie_z - 2min_thickness]) ZipTieCutThrough();

    translate([0, 0, lower_section_z + 2min_thickness]) ZipTieCutThrough();

    translate([0, 0, total_z - ziptie_z - 2min_thickness]) ZipTieCutThrough();

    translate([0, 0, lower_section_z + (upper_section_z / 2) - ziptie_z]) ZipTieCutThrough();
}
