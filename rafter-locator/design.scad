include <shared.scad>

marker_tip_dia=3;
marker_rad=1.5;
marker_tip_rad = marker_tip_dia / 2;

module RafterLocator(timber_width) {
    base_dim=[
        timber_width,
        timber_width + min_thickness,
        min_thickness
    ];

    lug_dim=[
        base_dim.x,
        min_thickness,
        min_thickness *3
    ];

    difference() {
        union() {
            cube(base_dim);
            cube(lug_dim);
        }
        translate([
            base_dim.x / 2 - marker_tip_rad,
            min_thickness * 2 - marker_tip_rad,
            0
        ]) roundedCube(
            [
                marker_tip_dia,
                base_dim.y - 3 * min_thickness,
                min_thickness + 2 * de_minimis
            ],
            marker_tip_rad,
            false
        );
    }
}

sizes=[35, 45, 70, 90, 140];

for (i=[0:len(sizes)-1]) {
    translate([i * 100, 0, 0]) RafterLocator(sizes[i]);
}
