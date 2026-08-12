// Flanged M32 Kitchen Mixer Backnut Generator
// Optimized for the "threadlib" library

// 1. INCLUDE THE LIBRARY
// Requires 'threadlib' folder containing threadlib.scad in your library path
use <threadlib/threadlib.scad>

// 2. CONFIGURABLE PARAMETERS
$fn = 100;                    // Resolution for smooth curves
flange_thickness = 3;         // Thickness of the bottom flat flange section
flange_diameter = 60;         // Total outer diameter of the wide clamping base
nut_flats_width = 46;         // Width across flat sides of the hex nut (spanner size)

// Thread Parameters (M32 x 1.5 fine pitch)
// threadlib uses standardized string designators: "-int" generates internal threads
thread_designator = "M32x1.5-int"; 
thread_pitch = 1.5;           // M32 fine pitch is 1.5mm
thread_turns = 8;             // 8 turns * 1.5mm pitch = 12mm total thread height

// Calculate total height dynamically based on thread turns
nut_thickness = thread_turns * thread_pitch; 

// 3. GEOMETRY GENERATION
difference() {
    // Solid Outer Body (Hex, Flare, and Flange Base)
    union() {
        // Flared transition using hull() between the hex nut and circular flange
        hull() {
            // Lower profile of the hex nut (positioned just above the flat flange)
            translate([0, 0, flange_thickness])
            cylinder(h = 0.1, d = nut_flats_width / cos(30), $fn = 6);
            
            // Upper profile of the circular flange base
            translate([0, 0, flange_thickness])
            cylinder(h = 0.1, d = flange_diameter, $fn = $fn);
        }
        
        // Upper Hex Nut Body (for basin wrench / spanner grip)
        translate([0, 0, flange_thickness])
        cylinder(h = nut_thickness - flange_thickness, d = nut_flats_width / cos(30), $fn = 6);
        
        // Flat Flange Base (for maximum surface contact under sink)
        cylinder(h = flange_thickness, d = flange_diameter, $fn = $fn);
    }
    
    // Internal Threaded Cutout via threadlib
    // threadlib automatically centres and aligns the thread along the Z-axis
    // It also natively builds in lead-in/lead-out tapers for easier threading
    translate([0, 0, -0.01])  // Minimal offset to clear the manifold boundary cleanly
    thread(thread_designator, turns = thread_turns);
}
