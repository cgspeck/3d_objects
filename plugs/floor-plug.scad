use <MCAD/regular_shapes.scad>

Hole_Diameter=22;
Hole_Depth=25;
Cap_Height=2.4;
Do_Bulge=true;
Bulge_Width=1.5;

/* [ Advanced ] */
Minimum_Thickness=1.2;

bulge_height=Bulge_Width * 2;
fn=72 * 4;
$fn=fn;

cap_lower_dia=Hole_Diameter * 2;
cap_upper_dia=cap_lower_dia-(Cap_Height * 2);
2Minimum_Thickness=Minimum_Thickness * 2;
de_minimus=0.1 * 1;

total_cylinder_height= Do_Bulge ? Hole_Depth + bulge_height : Hole_Depth;

module cylinder_outer(height,radius,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);}


module cone_outer(height,radius1,radius2,fn=72){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r1=radius1*fudge,r2=radius2*fudge,$fn=fn);
}

cone_outer(Cap_Height, cap_upper_dia / 2, cap_lower_dia / 2);

tri_pts=[
    [0, bulge_height / 2],
    [Bulge_Width, 0],
    [0, -bulge_height / 2],
];

cylinder_wall_thickness = Do_Bulge ? Minimum_Thickness : 2Minimum_Thickness;
cut_width = Do_Bulge ? 4 * Bulge_Width : 2 * Bulge_Width;

difference() {
    union() {
        translate([0, 0, Cap_Height]) difference() {
            cylinder_outer(total_cylinder_height, Hole_Diameter / 2);
            cylinder_outer(total_cylinder_height, (Hole_Diameter / 2) - cylinder_wall_thickness);
        }
        if (Do_Bulge) {
            translate([0, 0, Cap_Height + Hole_Depth + Bulge_Width]) rotate_extrude() translate([Hole_Diameter / 2, 0, 0]) polygon(points=tri_pts);
        }
    }

    translate([-cut_width / 2, -cap_lower_dia / 2, Cap_Height]) cube([cut_width, cap_lower_dia, total_cylinder_height + de_minimus]);
}
