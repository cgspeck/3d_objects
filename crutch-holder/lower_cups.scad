clearance_loose=0.4;
clearance_tight=0.2;
fn=72*4;
$fn=fn;
de_minimus=0.05;
min_thickness=2.4;

module cylinder_outer(height,radius,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

module cone_outer(height,radius1,radius2,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r1=radius1*fudge,r2=radius2*fudge,$fn=fn);
}

cone_lower_x=70;
cone_lower_y=50;
cone_lower_dx=(cone_lower_x - cone_lower_y) / 2;

cone_upper_x=100;
cone_upper_y=60;
cone_upper_dx=(cone_upper_x - cone_upper_y) / 2;

cone_z=100;

steering_column_dia=30;

steering_column_clamp_x=steering_column_dia + min_thickness * 2;
steering_column_clamp_y=5 + steering_column_dia / 2;
steering_column_clamp_z=20;


// select 4.8mm 250mm zip ties
zip_tie_width=4.8 + 1;
zip_tie_thickness=1.8 + 0.5;


module flat_cyl_assy(x, y, dx) {
    hull() {
        translate([-dx,0,0]) cylinder_outer(de_minimus, y/2);
        translate([dx,0,0]) cylinder_outer(de_minimus, y/2);
    }
}

module inner_cutout() {
    translate([0,0,min_thickness]) {
        hull() {
            flat_cyl_assy(cone_lower_x, cone_lower_y, cone_lower_dx);
            translate([0,0,cone_z]) flat_cyl_assy(cone_upper_x, cone_upper_y, cone_upper_dx); 
        }
    }
}

module outer_solid() {
    hull() {
        flat_cyl_assy(cone_lower_x + min_thickness * 2, cone_lower_y + min_thickness * 2, cone_lower_dx);
        translate([0,0,cone_z]) flat_cyl_assy(cone_upper_x + min_thickness * 2, cone_upper_y + min_thickness * 2, cone_upper_dx); 
    }
}

// steering_column_clamp_x=steering_column_dia;
// steering_column_clamp_y=2 * steering_column_clamp_x;
// steering_column_clamp_z=12;

// zip_tie_width=4.8 + 1;
// zip_tie_thickness=1.8 + 0.5;

difference() {
    union() {
        outer_solid();
        hull() {
            translate([
                -steering_column_clamp_x / 2,
                0,
                0
            ]) {
                cube([steering_column_clamp_x, steering_column_clamp_y, steering_column_clamp_z]);
            }
            translate([
                -steering_column_clamp_x / 2,
                cone_upper_y / 2 + min_thickness,
                cone_z - steering_column_clamp_z
            ]) {
                cube([steering_column_clamp_x, steering_column_clamp_y, steering_column_clamp_z]);
            }
        }
    }
    inner_cutout();

    translate([
        0,
        cone_upper_y / 2 + min_thickness + steering_column_clamp_y,
        0
    ]) cylinder_outer(cone_z, steering_column_dia/2);

    // zip_tie_width=4.8 + 1;
    // zip_tie_thickness=1.8 + 0.5;
    translate([
        0,
        cone_upper_y / 2 + min_thickness + steering_column_clamp_y,
        cone_z - steering_column_clamp_z + steering_column_clamp_y - min_thickness - zip_tie_width
    ]) {
        difference() {
            cylinder_outer(zip_tie_width, steering_column_dia / 2 + min_thickness + zip_tie_thickness);
            cylinder_outer(zip_tie_width, steering_column_dia / 2 + min_thickness);
        }
    }
    
    translate([
        0,
        cone_upper_y / 2 + min_thickness + steering_column_clamp_y,
        cone_z - steering_column_clamp_z + min_thickness
    ]) {
        difference() {
            cylinder_outer(zip_tie_width, steering_column_dia / 2 + min_thickness + zip_tie_thickness);
            cylinder_outer(zip_tie_width, steering_column_dia / 2 + min_thickness);
        }
    }
}
