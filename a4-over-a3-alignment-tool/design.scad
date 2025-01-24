include <shared.scad>;

a4_landscape_dim=[297, 210];
// a3_landscape_dim=[420, 297];
// as measured:
a3_landscape_dim=[417, 296];

tolerance=3;
ledge_xy=1.2;
ledge_z=1.2;
base_thickness=1.2;

tool_dim=[
    a3_landscape_dim.x + tolerance + ledge_xy * 2,
    a3_landscape_dim.y + tolerance + ledge_xy * 2,
    base_thickness + ledge_z
];

module entire_tool() {
    difference() {
        cube(tool_dim, center=true);
        cube([a4_landscape_dim.x + tolerance, a4_landscape_dim.y + tolerance, tool_dim.z + 2*de_minimis], center=true);
        translate([0,0,base_thickness/2]) cube([a3_landscape_dim.x + tolerance, a3_landscape_dim.y + tolerance, ledge_z + de_minimis], center=true);
    }
}

entire_tool();

divisor = 3;
translate([500, 0, 0]) {
    intersection() {
        entire_tool();
        translate([-tool_dim.x / divisor, 0, 0]) cube([tool_dim.x / divisor, tool_dim.y, tool_dim.z], center=true);
    }
}

translate([1000, 0, 0]) {
    intersection() {
        entire_tool();
        translate([-120,-155,-5])
            rotate([0,0,50])
            cube([240, 200, 10]);
        // translate([-tool_dim.x / divisor, 0, 0]) cube([tool_dim.x / divisor, tool_dim.y, tool_dim.z], center=true);
    }
}
