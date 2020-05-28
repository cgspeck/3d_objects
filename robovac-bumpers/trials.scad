fn=72*3;
$fn=fn;

clearance_loose=0.4;
leg_diameter=19.05;
leg_len=20;
thicknesses=[1.2, 2.4];
enclosure_percentages=[0.55, 0.60, 0.65, 0.70, 0.75];
leg_radius=leg_diameter/2;
i=0;

module cylinder_outer(height,radius,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

// loose ver
for (thick_idx=[0:len(thicknesses) - 1]) {
    for (enclosure_percent_idx=[0:len(enclosure_percentages) - 1]) {
        echo(enclosure_percent_idx);

        inner_radius=leg_radius+clearance_loose;
        outer_radius=inner_radius+thicknesses[thick_idx];

        translate([leg_diameter * 2 * thick_idx, leg_diameter * 2 * enclosure_percent_idx, 0]) {
            difference() {
                cylinder_outer(leg_len, outer_radius);
                cylinder_outer(leg_len, inner_radius);
                y_tran=-outer_radius + (enclosure_percentages[enclosure_percent_idx] * 2 * outer_radius);
                translate([-outer_radius, y_tran, 0]) cube([outer_radius * 2, outer_radius * 2, leg_len]);
            }
        }
    }    
}

// wedged ver
translate([100, 0, 0]) {
    for (thick_idx=[0:len(thicknesses) - 1]) {
        for (enclosure_percent_idx=[0:len(enclosure_percentages) - 1]) {
            echo(enclosure_percent_idx);

            inner_radius=leg_radius+clearance_loose;
            outer_radius=inner_radius+thicknesses[thick_idx];

            translate([leg_diameter * 3 * thick_idx, leg_diameter * 3 * enclosure_percent_idx, 0]) {
                difference() {
                    hull() {
                        translate([-outer_radius, -outer_radius, 0]) cube([outer_radius * 2, 1.2, leg_len]);
                        difference() {
                            cylinder_outer(leg_len, outer_radius);
                            cylinder_outer(leg_len, inner_radius);
                            y_tran=-outer_radius + (enclosure_percentages[enclosure_percent_idx] * 2 * outer_radius);
                            translate([-outer_radius, y_tran, 0]) cube([outer_radius * 2, outer_radius * 2, leg_len]);
                        }
                    }
                    cylinder_outer(leg_len, inner_radius);
                }
            }
        }    
    }
}
