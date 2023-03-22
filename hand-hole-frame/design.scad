include <shared.scad>
use <MCAD/2Dshapes.scad>

frame_timber_width=70;
frame_timber_spacing=6;
frame_timber_thickness=19;

corner_dia=12.5;
hand_hole_inner_height=130;


// select Zenith 8G x 18mm Stainless Steel Long Thread Countersunk Head Timber Screws
// https://www.bunnings.com.au/zenith-8g-x-18mm-stainless-steel-long-thread-countersunk-head-timber-screws-10-pack_p2420097

csc_head_dia=7.8;
csc_len=3.2;
screw_dia=4.5;
screw_len=18;

thickness=max(min_thickness, csc_len);
internal_thickness=min_thickness;

marker_dia=1;
//calc
corner_rad=corner_dia/2;
marker_rad=marker_dia/2;
frame_width=csc_head_dia*3;


tmpl_dim=[
    (frame_timber_width * 2 + frame_timber_spacing) - ((frame_width * 2) + (thickness * 2) + 2clearance_loose),
    hand_hole_inner_height + (thickness * 2) + 2clearance_loose,
];

frame_outer_dim=[
    (frame_timber_width * 2 + frame_timber_spacing),
    hand_hole_inner_height + (2 * frame_width) + (2 * thickness),
];

frame_inner_dim=[
    frame_outer_dim.x - ((frame_width * 2) + (thickness * 2)),
    frame_outer_dim.y - ((frame_width * 2) + (thickness * 2)),
];

frame_through_part_outer_dim=[
    frame_inner_dim.x + (thickness * 2),
    frame_inner_dim.y + (thickness * 2),
];

module CutoutTemplate() {
    /*
    2d object
    circles in corners marking location of pilot holes
    straight lines
    larger then the inner part of the frame
    */
    difference() {
        roundedSquare(tmpl_dim, corner_rad);
        // markers for pilot holes
        translate([
            -tmpl_dim.x / 2 + corner_rad,
            -tmpl_dim.y / 2 + corner_rad,
        ]) circle(marker_rad);
        translate([
            -tmpl_dim.x / 2 + corner_rad,
            tmpl_dim.y / 2 - corner_rad,
        ]) circle(marker_rad);
        translate([
            tmpl_dim.x / 2 - corner_rad,
            -tmpl_dim.y / 2 + corner_rad,
        ]) circle(marker_rad);
        translate([
            tmpl_dim.x / 2 - corner_rad,
            tmpl_dim.y / 2 - corner_rad,
        ]) circle(marker_rad);

        // markers for center
        roundedSquare([
            tmpl_dim.x / 10 * 8,
            1
        ], 0.25);
        roundedSquare([
            1,
            tmpl_dim.y / 10 * 8
        ], 0.25);
    }
}

// module CounterSunkScrew(screw_dia, screw_len, csc_len, csc_head_dia, screw_z_offset=de_minimis)

module Frame() {
    difference() {
        union() {
            linear_extrude(thickness) difference() {
                roundedSquare(frame_outer_dim, corner_rad);
                roundedSquare(frame_inner_dim, corner_rad);
            }

            linear_extrude(thickness + frame_timber_thickness) difference() {
                roundedSquare(frame_through_part_outer_dim, corner_rad);
                roundedSquare(frame_inner_dim, corner_rad);
            }
        }

        screw_hole_z=min(csc_len, thickness);

        translate([
            -frame_outer_dim.x/2 + csc_head_dia * 1.5,
            0,
            screw_hole_z
        ]) rotate([180,0,0]) CounterSunkScrew(screw_dia, screw_len, csc_len, csc_head_dia);

        translate([
            frame_outer_dim.x/2 - csc_head_dia * 1.5,
            0,
            screw_hole_z
        ]) rotate([180,0,0]) CounterSunkScrew(screw_dia, screw_len, csc_len, csc_head_dia);

        translate([
            -frame_outer_dim.x/2 + frame_timber_width / 2,
            frame_outer_dim.y / 2 - csc_head_dia * 1.5,
            screw_hole_z
        ]) rotate([180,0,0]) CounterSunkScrew(screw_dia, screw_len, csc_len, csc_head_dia);

        translate([
            -frame_outer_dim.x/2 + frame_timber_width / 2,
            -frame_outer_dim.y / 2 + csc_head_dia * 1.5,
            screw_hole_z
        ]) rotate([180,0,0]) CounterSunkScrew(screw_dia, screw_len, csc_len, csc_head_dia);

        translate([
            frame_outer_dim.x/2 - frame_timber_width / 2,
            frame_outer_dim.y / 2 - csc_head_dia * 1.5,
            screw_hole_z
        ]) rotate([180,0,0]) CounterSunkScrew(screw_dia, screw_len, csc_len, csc_head_dia);

        translate([
            frame_outer_dim.x/2 - frame_timber_width / 2,
            -frame_outer_dim.y / 2 + csc_head_dia * 1.5,
            screw_hole_z
        ]) rotate([180,0,0]) CounterSunkScrew(screw_dia, screw_len, csc_len, csc_head_dia);
    }

}

module TwoDFrame() {
    projection() Frame();
}

// TwoDFrame();
Frame();
// CutoutTemplate();