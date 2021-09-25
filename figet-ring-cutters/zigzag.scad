include <common.scad>


// waves 23 or 10
module ZigZagCutter(waves=18, amplitude=5) {
    // cube();
    wave_length=cutter_length/waves;
    half_wave_length=wave_length/2;
    half_amplitude = amplitude / 2;
    cutter_xy_points=[
        for (a=[0:waves*2]) [
            half_wave_length * a,
            a % 2 == 0 ? -half_amplitude : half_amplitude
        ],
        for (a=[0:waves*2]) [
            cutter_length - (half_wave_length * a),
            (a % 2 == 0 ? -half_amplitude : half_amplitude) - edge_thickness
        ]
    ];

    linear_extrude(edge_height) polygon(points=cutter_xy_points);
    translate([
        cutter_length/2,
        0,
        -handle_height/2,
    ]) cube([
        cutter_length, handle_thickness, handle_height
    ], center=true);
}


ZigZagCutter();