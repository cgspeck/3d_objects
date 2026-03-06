include <shared.scad>;

hole_dx=125;
hole_dy=125;
hole_dia=3.5;
fan_dx=15;
thickness=1.6;
inner_dia=1;
// 
hole_rad=hole_dia/2+clearance_loose;
plate_size=hole_rad*2;

pts=[
    [0,0,0],
    [hole_dx, 0, 0],
    [hole_dx + fan_dx, 0, 0],
    [hole_dx, hole_dy, 0],
    [hole_dx + fan_dx, hole_dy, 0],
    [0, hole_dy, 0],
    
];

pts_extd=[
    [hole_dx + fan_dx + hole_dx, 0, 0],
    [hole_dx + fan_dx + hole_dx, hole_dy, 0],
];

module ThreeDPrint() {
        difference() {
        sequentialHull() {
            cylinder_outer(thickness, plate_size);
            translate([hole_dx, 0, 0]) cylinder_outer(thickness, plate_size);
            translate([hole_dx + fan_dx, 0, 0]) cylinder_outer(thickness, plate_size);
            translate([hole_dx, 0, 0]) cylinder_outer(thickness, plate_size);
            translate([hole_dx, hole_dy, 0]) cylinder_outer(thickness, plate_size);
            translate([hole_dx + fan_dx, hole_dy, 0]) cylinder_outer(thickness, plate_size);
            translate([hole_dx, hole_dy, 0]) cylinder_outer(thickness, plate_size);
            translate([0, hole_dy, 0]) cylinder_outer(thickness, plate_size);
            cylinder_outer(thickness, plate_size);
        }

        for(pt=pts) {
            translate([0,0,-de_minimis]) translate(pt) LocatedHole(thickness + de_minimis * 2, hole_dia, inner=false);
        }
    }
}

module Full() {
    projection(true) translate([0,0,-thickness/2]) difference() {
        union() {
            sequentialHull() {
                cylinder_outer(thickness, plate_size);
                translate([hole_dx + fan_dx + hole_dx, 0, 0]) cylinder_outer(thickness, plate_size);
                translate([hole_dx + fan_dx + hole_dx, hole_dy, 0]) cylinder_outer(thickness, plate_size);
                translate([0, hole_dy, 0]) cylinder_outer(thickness, plate_size);
                cylinder_outer(thickness, plate_size);
            }
            hull() {
                translate([hole_dx, 0, 0]) cylinder_outer(thickness, plate_size);
                translate([hole_dx, hole_dy, 0]) cylinder_outer(thickness, plate_size);
            }
        }


        for(pt=pts) {
            translate([0,0,0]) translate(pt) LocatedHole(thickness + de_minimis * 2, hole_dia, inner_dia=inner_dia, inner=true);
        }
        for(pt=pts_extd) {
            translate([0,0,-de_minimis]) translate(pt) LocatedHole(thickness + de_minimis * 2, hole_dia, inner_dia=inner_dia, inner=true);
        }
    }
}

ThreeDPrint();

// Full();