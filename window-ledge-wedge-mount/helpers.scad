include <MCAD/nuts_and_bolts.scad>

fn=72*4;
$fn=fn;
clearance_tight=0.2;
clearance_loose=0.4;
2clearance_loose=2*clearance_loose;

de_minimis=0.01;
2de_minimis=2*de_minimis;
min_thickness=2.4;
2min_thickness=2*min_thickness;

module cylinder_outer(height,radius,fn=fn) {
    fudge = 1/cos(180/fn);
    cylinder(h=height,r=radius*fudge,$fn=fn);
}

module circle_outer(radius,fn=fn){
    fudge = 1/cos(180/fn);
    circle(r=radius*fudge,$fn=fn);
}

module cone_outer(height,radius1,radius2,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r1=radius1*fudge,r2=radius2*fudge,$fn=fn);
}

module doughnut(height, outer_radius, inner_radius, fn=fn) {
    difference() {
        cylinder_outer(height, outer_radius, fn);
        translate([0,0,-de_minimis]) cylinder_outer(height + (de_minimis*2), inner_radius, fn);
    }
}

module BoltHole(
    diameter,
    length,
    extra_cap_length = 0,
    user_cap_dia = 0,
    tolerance = +0.0001,
    proj = -1
)
{
	radius = COARSE_THREAD_METRIC_BOLT_MAJOR_DIAMETERS[diameter]/2+tolerance;
	capHeight = diameter+tolerance + extra_cap_length;
	capRadius = max(METRIC_BOLT_CAP_DIAMETERS[diameter]/2+tolerance, user_cap_dia / 2);

	if (proj == -1)
	{
	translate([0, 0, -capHeight])
		cylinder(r= capRadius, h=capHeight);
	cylinder(r = radius, h = length);
	}
	if (proj == 1)
	{
		circle(r = radius);
	}
	if (proj == 2)
	{
		translate([-capRadius/2, -capHeight])
			square([capRadius*2, capHeight]);
		square([radius*2, length]);
	}
}

module NutHoleAssembly(
    diameter=5,
    length=20,
    nut_depth=2.4,
    nut_mult=1,
    bolt_head_len=0,
    de_minimis=0.01
) {
    cylinder_outer(length, diameter / 2 + clearance_loose);
    nut_thickness=METRIC_NUT_THICKNESS[diameter];
    nut_total_height=nut_thickness * nut_mult;
    leading_height=length - nut_depth - nut_total_height;

    translate([
        0,
        0,
        nut_depth
    ]) scale([1, 1, nut_mult]) nutHole(diameter);

    translate([
        0,
        0,
        nut_depth + nut_total_height - de_minimis
    ]) {
        cylinder_outer(leading_height, (METRIC_NUT_AC_WIDTHS[diameter] / 2) + clearance_loose);    
    }
    
    if (bolt_head_len > 0) {
        bolt_head_dia = METRIC_BOLT_CAP_DIAMETERS[diameter] + clearance_loose * 2;
        translate([0,0,-bolt_head_len]) cylinder_outer(bolt_head_len, bolt_head_dia / 2);
    }
}

//Based on: http://www.roymech.co.uk/Useful_Tables/Screws/Hex_Screws.htm
METRIC_NUT_AF_MAX_WIDTHS =
[
	-1, //0 index is not used but reduces computation
	-1,
	-1,//m2  NO LONGER ON TABLE?
	5.5,//m3
	7.0,//m4
	8.0,//m5
	10.0,//m6
	-1,
	13.00,//m8
	-1,
	17.00,//m10
	-1,
	19.00,//m12
	-1,
	-1,
	-1,
	24.00,//m16
	-1,
	-1,
	-1,
	30.00,//m20
	-1,
	-1,
	-1,
	36.00,//m24
	-1,
	-1,
	-1,
	-1,
	-1,
	46.00,//m30
	-1,
	-1,
	-1,
	-1,
	-1,
	55.00//m36
];

module NutSlotAssembly(
    diameter=5,
    nut_depth=2.4,
    nut_height=0,
    clearance=0,
    length_behind_slot=0
) {
    nut_ac_width=METRIC_NUT_AC_WIDTHS[diameter] + 2 * clearance;
    nut_af_width=METRIC_NUT_AF_MAX_WIDTHS[diameter] + 2 * clearance;
    actual_nut_height=nut_height > 0 ? nut_height + 2 * clearance : METRIC_NUT_THICKNESS[diameter] + 2 * clearance;
    hole_len=nut_depth+actual_nut_height+length_behind_slot;
    cylinder_outer(hole_len, diameter / 2 + clearance_loose);

    translate([
        -nut_ac_width / 2,
        -nut_af_width / 2,
        nut_depth
    ]) cube([100, nut_af_width, actual_nut_height]);
}

module Handle(
    OUTDENT_COUNT=24,
    HANDLE_OUTDENT_RADIUS=4,
    WHEEL_RADIUS=50,
    HANDLE_THICKNESS=6,
    fn=64,
) {
    // handle
    translate([0,0,HANDLE_THICKNESS/2]) torus2(WHEEL_RADIUS, HANDLE_THICKNESS/2);
    // outdents
    outdent_degrees = 360 / OUTDENT_COUNT;
    for(sector = [1 : OUTDENT_COUNT]) {
        angle = outdent_degrees * sector;
        x_pos = WHEEL_RADIUS * sin(angle);
        y_pos = WHEEL_RADIUS * cos(angle);
        translate([x_pos,y_pos,HANDLE_OUTDENT_RADIUS]){
            sphere(HANDLE_OUTDENT_RADIUS, $fn=fn);
        }
    }
}

module CounterSunkScrew(screw_dia, screw_len, csc_len, csc_head_dia, screw_z_offset=de_minimis) {
    actual_screw_dia=screw_dia + (clearance_tight * 2);
    actual_csc_head_dia = csc_head_dia + (clearance_tight * 2);
    translate([
        0,
        0,
        -screw_len + screw_z_offset
    ]) {
        cylinder_outer(screw_len, actual_screw_dia / 2);
        translate([0, 0, screw_len]) cone_outer(csc_len, actual_screw_dia / 2, actual_csc_head_dia /2);
        translate([0, 0, screw_len + csc_len]) cylinder_outer(screw_len * 2, actual_csc_head_dia / 2);;
    }
}


module multiHull(){
    for (i = [1 : $children-1]) {
        hull(){
            children(0);
            children(i);
        }
    }
}

module sequentialHull(){
    for (i = [0: $children-2]) {
        hull() {
            children(i);
            children(i+1);
        }
    }
}
