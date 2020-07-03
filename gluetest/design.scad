use <MCAD/boxes.scad>

fn=72*4;
$fn=fn;

min_thickness=1.2;
shell_thickness=2 * min_thickness;

d_max=60;
d_min=d_max / 2;
height=d_max / 4;

base_dim=[d_max, d_max, min_thickness];
base_corner_rad=6;

clearance_tight=0.2;

de_minimus=0.01;


module _cone(mode="plug", hollow=true) {
    lower_od = mode == "socket" ? d_max : d_max - (0 * (shell_thickness + clearance_tight));
    lower_id = lower_od - shell_thickness;

    upper_od = mode == "socket" ? d_min : d_min - (0 * (shell_thickness + clearance_tight));
    upper_id = upper_od - shell_thickness;

    translate([
        d_max / 2,
        d_max / 2,
        0
    ]) {
        difference() {
            cylinder(height, lower_od / 2, upper_od / 2);

            if (hollow) {
                cylinder(height, (lower_id / 2), (upper_id / 2));
            }

        }
    }
}

module BasePlug() {
    difference() {
        translate(base_dim / 2) roundedBox(base_dim, base_corner_rad, true);
        _cone("plug", false);
    }
    _cone("plug");
}

module BasePlugShifted() {
    difference() {
        translate(base_dim / 2) roundedBox(base_dim, base_corner_rad, true);
        translate([
            base_dim.x / 2,
            base_dim.y / 2,
            0
        ]) cylinder(r=(d_max - shell_thickness) / 2, h=base_dim.z, center=false);
    }
    translate([0, 0, base_dim.z]) _cone("plug");
}

module TopSocket() {
    translate([
        base_dim.x,
        0,
        height,
    ]) rotate([0, 180, 0]) {
        difference() {
            translate([
                base_dim.x / 2,
                base_dim.y / 2,
                height - base_dim.z / 2
            ]) roundedBox(base_dim, base_corner_rad, true);
            _cone("socket", false);
        }
        _cone("socket");
    }
}

BasePlug();

translate([d_max * 1.2, 0, 0]) TopSocket();

translate([d_max * 2.4, 0, 0]) BasePlugShifted();
