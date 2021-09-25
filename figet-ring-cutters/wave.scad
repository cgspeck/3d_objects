include <common.scad>

// https://github.com/openscad/scad-utils/blob/master/lists.scad
function reverse(list) = [for (i = [len(list)-1:-1:0]) list[i]];

// waves 23 or 10
module WaveCutter(waves=18, amplitude=5) {
    // cube();
    wave_length=cutter_length/waves;
    half_wave_length=wave_length/2;
    actual_amplitude = amplitude / 2;
    f=waves*3;

    j=0.01;
    k=cutter_length/j;
    l=[for(a=[0:k])  a * j ];
    m=reverse(l);
    echo(m);
    n=edge_thickness * 3;
    h=cutter_length;
    cutter_xy_points=[
        for (a=l) [
            a,
            actual_amplitude * sin(a*f)
        ],
        for (a=m) [
            a,
            actual_amplitude * sin((a)*f) - n
        ],
    ];

    render() linear_extrude(edge_height) polygon(points=cutter_xy_points);
    translate([
        cutter_length/2,
        0-n/2,
        -handle_height/2,
    ]) cube([
        cutter_length, handle_thickness, handle_height
    ], center=true);
}


WaveCutter();

translate([0, 30, 0]) WaveCutter(9);