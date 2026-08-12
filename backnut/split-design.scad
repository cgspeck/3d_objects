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
nut_thickness = thread_turns * thread_pitch + thread_pitch; 

cut_out_width = 5;

// Select Crescent 300mm x 4.8mm WB12100
cable_tie_z = 5.1;
cable_tie_width = 2.5; 

difference() {
    union() {
        nut(thread_designator, turns = thread_turns, Douter=50); 
    }
    translate([-flange_diameter/2, -cut_out_width / 2, -thread_pitch / 2]) cube([flange_diameter, cut_out_width, nut_thickness]);
    translate([-flange_diameter/2 + 2.4, -flange_diameter / 2, 0]) {
        translate([0, 0, 2.4 - thread_pitch]) cube([cable_tie_width, flange_diameter, cable_tie_z]);
        translate([0, 0, nut_thickness - 2.4 - cable_tie_z]) cube([cable_tie_width, flange_diameter, cable_tie_z]);
    }
    translate([flange_diameter/2 - 2.4 - cable_tie_width, -flange_diameter / 2, 0]) {
        translate([0, 0, 2.4 - thread_pitch]) cube([cable_tie_width, flange_diameter, cable_tie_z]);
        translate([0, 0, nut_thickness - 2.4 - cable_tie_z]) cube([cable_tie_width, flange_diameter, cable_tie_z]);
    }
}
