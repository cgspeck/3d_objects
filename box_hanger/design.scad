include <MCAD/nuts_and_bolts.scad>

clearance_loose=0.4;
clearance_tight=0.2;
fn=72*3;
$fn=fn;
cutout_z=60;
de_minimus=0.05;

pcb_hole_dia=3+(2*clearance_loose);
pcb_hole_dx=46;
pcb_hole_dy=85;

mount_cyl_pts=[
    [pcb_hole_dx/2, pcb_hole_dy/3, 0],
    [pcb_hole_dx/2, pcb_hole_dy/3 * 2, 0],
];

nut_thickness=METRIC_NUT_THICKNESS[3];
pcb_cyl_height=nut_thickness*2;

hanger_hole_dia=4; // clearance for #8 machine screw
hanger_head_dia=6.4+(clearance_loose * 2);
hanger_head_height=2.6;
hanger_hole_height=4;
hanger_cyl_height=hanger_hole_height+hanger_head_height;
hanger_cyl_dia=hanger_head_dia*2;

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

module PCBCylinder(body=true, cutouts=true) {
    difference() {
        union() {
            if(body) {
                cylinder_outer(pcb_cyl_height, (pcb_hole_dia/2) * 3, center=true);
            }
        }

        if(cutouts) {
            cylinder_outer(pcb_cyl_height, (pcb_hole_dia/2), center=true);
            translate([0,0,pcb_cyl_height/2]) nutHole(3, tolerance=0.02);
            translate([0,0,pcb_cyl_height]) nutHole(3, tolerance=0.02);
        }
    }
}

module MountCylinder(body=true, cutouts=true) {
    difference() {
        union() {
            if(body) {
                cylinder_outer(hanger_cyl_height, hanger_cyl_dia / 2, center=true);
            }
        }

        if(cutouts) {
            cylinder_outer(hanger_cyl_height, (hanger_hole_dia/2), center=true);
            translate([0,0,0]) cylinder_outer(hanger_head_height, (hanger_head_dia/2), center=true);
        }
    }
}


difference() {
    union() {
        multiHull() {
            translate(mount_cyl_pts[0]) MountCylinder();
            PCBCylinder();
            translate([pcb_hole_dx, 0, 0]) PCBCylinder();
        }

        multiHull() {
            translate(mount_cyl_pts[1]) MountCylinder();
            translate([0, pcb_hole_dy, 0]) PCBCylinder();
            translate([pcb_hole_dx, pcb_hole_dy, 0]) PCBCylinder();
        }

        hull() {
            translate(mount_cyl_pts[0]) MountCylinder();
            translate(mount_cyl_pts[1]) MountCylinder();
        }
    }

    PCBCylinder(body=false, cutouts=true);
    translate([pcb_hole_dx, 0, 0]) PCBCylinder(body=false, cutouts=true);
    translate([0, pcb_hole_dy, 0]) PCBCylinder(body=false, cutouts=true);
    translate([pcb_hole_dx, pcb_hole_dy, 0]) PCBCylinder(body=false, cutouts=true);
    translate(mount_cyl_pts[0]) MountCylinder(body=false, cutouts=true);
    translate(mount_cyl_pts[1]) MountCylinder(body=false, cutouts=true);
}




