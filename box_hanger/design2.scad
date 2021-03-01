include <MCAD/boxes.scad>
include <MCAD/nuts_and_bolts.scad>

clearance_loose=0.4;
clearance_tight=0.2;
fn=72*3;
$fn=fn;
cutout_z=60;
de_minimus=0.05;
std_thickness=2.4;

pcb_hole_dia=2.5; // to accom #4 screw
pcb_hole_dx=46;
pcb_hole_dy=85;

mount_cyl_pts=[
    [pcb_hole_dx/2, pcb_hole_dy/3, 0],
    [pcb_hole_dx/2, pcb_hole_dy/3 * 2, 0],
];


box_tran=[
    -(pcb_hole_dia * 1.5)-std_thickness,
    -(pcb_hole_dia * 1.5)-std_thickness,
    -std_thickness
];

f_cutout_dia = 11;
f_cutout_pcb_offset_z = 10 + f_cutout_dia / 2;

hanger_hole_dia=4.3; // clearance for #8 machine screw
hanger_head_dia=6.4+(clearance_loose * 2);
hanger_head_height=2.6;
hanger_hole_height=std_thickness;
hanger_cyl_height=hanger_hole_height+hanger_head_height;
hanger_cyl_dia=hanger_head_dia*2;

pcb_cyl_height=hanger_cyl_height + 5;


box_int_dimensions=[
    pcb_hole_dx + (pcb_hole_dia) * 3 + 10,
    pcb_hole_dy + (pcb_hole_dia) * 3,
    pcb_cyl_height + 28 + 5
];

box_ext_dimensions=[
    box_int_dimensions.x + (std_thickness) * 2,
    box_int_dimensions.y + (std_thickness) * 2,
    box_int_dimensions.z + (std_thickness) * 2
];

module cylinder_outer(height,radius,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

module multiHull(){
    for (i = [1 : $children-1]) {
        hull(){
            children(0);
            children(i);
        }
    }
}

push_fit_tab_width=2;
push_fit_tab_height=9;


module push_fit_tab(origin=0) {
    z = 10;
    xy_pts = [
        [0,origin],
        [push_fit_tab_width, origin],
        [push_fit_tab_width, push_fit_tab_height],
        [-1.5, push_fit_tab_height-3.5],
        [0, push_fit_tab_height-3.5],
    ];

    translate([
        0,
        z / 2,
        0
    ]) rotate([90,0,0]) linear_extrude(z) polygon(points=xy_pts);
}

module PCBCylinder(body=true, cutouts=true) {
    difference() {
        union() {
            if(body) {
                cylinder_outer(pcb_cyl_height, (pcb_hole_dia/2) * 3);
            }
        }

        if(cutouts) {
            cylinder_outer(pcb_cyl_height, (pcb_hole_dia/2));
        }
    }
}

r_cutout_dim=[40,10,16];

module Box(section="base") {
    split_z = std_thickness + pcb_cyl_height + f_cutout_pcb_offset_z;

    base_cube_dim=[
        box_ext_dimensions.x,
        box_ext_dimensions.y,
        split_z
    ];
    push_fit_tab_z_tran=base_cube_dim.z - push_fit_tab_height - 3.5 + clearance_loose + 0.7;
    push_fit_tab_z_dim=3.5 + clearance_loose;
    translate(box_tran) {
        difference() {
            intersection() {
                difference() {
                    roundedCube(box_ext_dimensions, r=1.5, sidesonly=true, center=false);
                    translate([std_thickness, std_thickness, std_thickness]) roundedCube(box_int_dimensions, r=1.5, sidesonly=true, center=false);
                    // cutout for pot at front
                    translate([
                        box_ext_dimensions.x / 2,
                        std_thickness + de_minimus,
                        split_z
                    ]) rotate([90,0,0]) cylinder_outer(10, f_cutout_dia / 2);
                    // cutout for wires at rear
                    translate([
                        box_ext_dimensions.x / 2 - r_cutout_dim.x / 2,
                        box_ext_dimensions.y - r_cutout_dim.y / 2,
                        std_thickness + pcb_cyl_height]) roundedCube(r_cutout_dim, r=1.5, sidesonly=false, center=false);
                    // pushfit tab cutouts
                    translate([0,0,push_fit_tab_z_tran]) {
                        translate([0,base_cube_dim.y / 4 - 5, 0]) cube([box_ext_dimensions.x,10,push_fit_tab_z_dim]);
                    }
                    translate([0,0,push_fit_tab_z_tran]) {
                        translate([0,base_cube_dim.y / 4 * 3 - 5, 0]) cube([box_ext_dimensions.x,10,push_fit_tab_z_dim]);
                    }
                    if (section=="base") {
                        // pushfit tab clearance
                        width = 70;
                        translate([0,base_cube_dim.y / 2 - width / 2, split_z - std_thickness]) cube([box_ext_dimensions.x,width,std_thickness * 2]);
                    }
                }
                if (section=="base") {
                    translate([0,0,-std_thickness]) cube(base_cube_dim);
                    translate([
                        std_thickness/2 + clearance_tight,
                        std_thickness/2 + clearance_tight,
                        -clearance_tight,
                    ]) roundedCube([
                        box_int_dimensions.x + std_thickness - clearance_tight,
                        box_int_dimensions.y + std_thickness - clearance_tight,
                        base_cube_dim.z
                    ], r=1.5, sidesonly=true, center=false);
                }
            }
            if (section=="cover") {
                translate([0,0,-std_thickness]) cube(base_cube_dim);
                translate([
                    std_thickness/2,
                    std_thickness/2,
                    0
                ]) roundedCube([
                    box_int_dimensions.x + std_thickness,
                    box_int_dimensions.y + std_thickness,
                    base_cube_dim.z
                ], r=1.5, sidesonly=true, center=false);
            }
            if (section=="base") {
                // cutouts for enclosure mount holes
                translate([box_ext_dimensions.x / 2, 0,0]) {
                    translate([0, box_ext_dimensions.y / 3,0]) MountCylinder(body=true, cutouts=false);
                    translate([0, box_ext_dimensions.y / 3 * 2,0]) MountCylinder(body=true, cutouts=false);
                }
            }

            slit_large_y=25;
            slit_small_y=10;
            slit_cover_y=70;
            slit_start_z=pcb_cyl_height+std_thickness;
            slit_cover_start_x = std_thickness * 3;

            // VENTS
            translate([0,box_ext_dimensions.y/2 - slit_large_y / 2,slit_start_z]) cube([box_ext_dimensions.x,slit_large_y,std_thickness]);
            translate([0,box_ext_dimensions.y/2 - slit_large_y / 2,slit_start_z + std_thickness * 2]) cube([box_ext_dimensions.x,slit_large_y,std_thickness]);
            translate([0,box_ext_dimensions.y/2 - slit_large_y / 2,slit_start_z + std_thickness * 4]) cube([box_ext_dimensions.x,slit_large_y,std_thickness]);
            translate([0,box_ext_dimensions.y/2 - slit_large_y / 2,slit_start_z + std_thickness * 6]) cube([box_ext_dimensions.x,slit_large_y,std_thickness]);
            translate([0,box_ext_dimensions.y/2 - slit_large_y / 2,slit_start_z + std_thickness * 8]) cube([box_ext_dimensions.x,slit_large_y,std_thickness]);
            translate([0,box_ext_dimensions.y/2 - slit_large_y / 2,slit_start_z + std_thickness * 10]) cube([box_ext_dimensions.x,slit_large_y,std_thickness]);
            translate([0,box_ext_dimensions.y/2 - slit_large_y / 2,slit_start_z + std_thickness * 12]) cube([box_ext_dimensions.x,slit_large_y,std_thickness]);

            translate([0,5,slit_start_z]) cube([box_ext_dimensions.x,slit_small_y,std_thickness]);
            translate([0,5,slit_start_z + std_thickness * 2]) cube([box_ext_dimensions.x,slit_small_y,std_thickness]);
            translate([0,5,slit_start_z + std_thickness * 4]) cube([box_ext_dimensions.x,slit_small_y,std_thickness]);
            translate([0,5,slit_start_z + std_thickness * 6]) cube([box_ext_dimensions.x,slit_small_y,std_thickness]);
            translate([0,5,slit_start_z + std_thickness * 8]) cube([box_ext_dimensions.x,slit_small_y,std_thickness]);
            translate([0,5,slit_start_z + std_thickness * 10]) cube([box_ext_dimensions.x,slit_small_y,std_thickness]);
            translate([0,5,slit_start_z + std_thickness * 12]) cube([box_ext_dimensions.x,slit_small_y,std_thickness]);

            translate([slit_cover_start_x,7,box_ext_dimensions.z - std_thickness]) cube([std_thickness,slit_cover_y,std_thickness]);
            translate([slit_cover_start_x + std_thickness * 2,7,box_ext_dimensions.z - std_thickness]) cube([std_thickness,slit_cover_y,std_thickness]);
            translate([slit_cover_start_x + std_thickness * 4,7,box_ext_dimensions.z - std_thickness]) cube([std_thickness,slit_cover_y,std_thickness]);
            translate([slit_cover_start_x + std_thickness * 6,7,box_ext_dimensions.z - std_thickness]) cube([std_thickness,slit_cover_y,std_thickness]);
            translate([slit_cover_start_x + std_thickness * 8,7,box_ext_dimensions.z - std_thickness]) cube([std_thickness,slit_cover_y,std_thickness]);
            translate([slit_cover_start_x + std_thickness * 10,7,box_ext_dimensions.z - std_thickness]) cube([std_thickness,slit_cover_y,std_thickness]);
            translate([slit_cover_start_x + std_thickness * 12,7,box_ext_dimensions.z - std_thickness]) cube([std_thickness,slit_cover_y,std_thickness]);
            translate([slit_cover_start_x + std_thickness * 14,7,box_ext_dimensions.z - std_thickness]) cube([std_thickness,slit_cover_y,std_thickness]);
            translate([slit_cover_start_x + std_thickness * 16,7,box_ext_dimensions.z - std_thickness]) cube([std_thickness,slit_cover_y,std_thickness]);
            translate([slit_cover_start_x + std_thickness * 18,7,box_ext_dimensions.z - std_thickness]) cube([std_thickness,slit_cover_y,std_thickness]);
            translate([slit_cover_start_x + std_thickness * 20,7,box_ext_dimensions.z - std_thickness]) cube([std_thickness,slit_cover_y,std_thickness]);
            translate([slit_cover_start_x + std_thickness * 22,7,box_ext_dimensions.z - std_thickness]) cube([std_thickness,slit_cover_y,std_thickness]);
        }
        // ADDITIONS
        if (section=="cover") {
            pft_origin=-22.1;
            translate([0,0,base_cube_dim.z - std_thickness]) rotate([180,0,0]) {
                translate([std_thickness,0,0]) {
                    translate([0,-base_cube_dim.y / 4, 0]) push_fit_tab(pft_origin);
                    translate([0,-base_cube_dim.y / 4 * 3, 0]) push_fit_tab(pft_origin);
                }
            }
            translate([3.5 + base_cube_dim.x - std_thickness * 1.5, base_cube_dim.y,base_cube_dim.z - std_thickness]) rotate([0,180,0]) {
                translate([std_thickness,0,0]) {
                    translate([0,-base_cube_dim.y / 4, 0]) push_fit_tab(pft_origin);
                    translate([0,-base_cube_dim.y / 4 * 3, 0]) push_fit_tab(pft_origin);
                }
            }
        }
        if (section=="base") {
            translate([box_ext_dimensions.x / 2, 0,0]) {
                translate([0, box_ext_dimensions.y / 3,0]) MountCylinder();
                translate([0, box_ext_dimensions.y / 3 * 2,0]) MountCylinder();
            }
            translate([
                (box_ext_dimensions.x / 2) - pcb_hole_dx / 2,
                std_thickness + (pcb_hole_dia * 1.5),
                0
            ]) difference() {
                union() {
                    union() {
                        PCBCylinder();
                        translate([pcb_hole_dx, 0, 0]) PCBCylinder();
                    }

                    union() {
                        translate([0, pcb_hole_dy, 0]) PCBCylinder();
                        translate([pcb_hole_dx, pcb_hole_dy, 0]) PCBCylinder();
                    }
                }

                PCBCylinder(body=false, cutouts=true);
                translate([pcb_hole_dx, 0, 0]) PCBCylinder(body=false, cutouts=true);
                translate([0, pcb_hole_dy, 0]) PCBCylinder(body=false, cutouts=true);
                translate([pcb_hole_dx, pcb_hole_dy, 0]) PCBCylinder(body=false, cutouts=true);
            }
        }
    }
}

module MountCylinder(body=true, cutouts=true) {
    difference() {
        union() {
            if (body) {
                cylinder_outer(hanger_cyl_height, hanger_cyl_dia / 2);
            }
        }

        if (cutouts) {
            union() {
                translate([0,0,0]) cylinder_outer(hanger_cyl_height + de_minimus, (hanger_hole_dia/2));
                translate([0,0,hanger_cyl_height - hanger_head_height]) cylinder_outer(hanger_head_height, (hanger_head_dia/2));
            }
        }
    }
}




Box();
translate([0,0,20]) Box("cover");

