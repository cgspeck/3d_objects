include <shared.scad>
use <threadlib/threadlib.scad>

$fn = 100;                    // Resolution for smooth curves
flange_thickness = 3;         // Thickness of the bottom flat flange section
flange_diameter = 50;         // Total outer diameter of the wide clamping base
nut_flats_width = 46;         // Width across flat sides of the hex nut (spanner size)


// if it's not "M32x1.5" then it's 1 1⁄4" BSP: "G1 1/4", 2.309 pitch
thread_designator = "M32x1.5"; //"G1"; 
thread_pitch = 1.5; // 2.309; //1.5;           // M32 fine pitch is 1.5mm
thread_turns = 10;             // 8 turns * 1.5mm pitch = 12mm total thread height

// Calculate total height dynamically based on thread turns
nut_thickness = thread_turns * thread_pitch; 


filter_notch_dia=24;
filter_notch_cutout_dx=2;

filter_notch_rad=filter_notch_dia/2;

difference() {
    union() {
        // #translate([0, 0, thread_pitch / 2]) nut("M32x1.5", turns = thread_turns, Douter=48, nut_sides=6);
        translate([0, 0, thread_pitch / 2]) nut(thread_designator, turns = thread_turns, Douter=50, nut_sides=6);
        
        // Flat Flange Base (for maximum surface contact under sink)
        difference() {
            cylinder(h = flange_thickness, d = flange_diameter, $fn = $fn);
            cylinder(h = flange_thickness, d = 38, $fn = $fn);
        }
    }

    translate([
        8,
        0
    ]) cylinder_outer(60, filter_notch_rad);
}
