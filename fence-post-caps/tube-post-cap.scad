use <MCAD/regular_shapes.scad>

min_od=20;
max_od=23;
hat_height=5;
inner_height=10;
min_thickness=2.4;
fn=4 * 72;
$fn=fn;

module cone_outer(height,radius1,radius2,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r1=radius1*fudge,r2=radius2*fudge,$fn=fn);
}

module hexagon(diameter)
{
    // too many warnings using the MCAD hexagon, issues with naming/not naming parameters
    // and it using a deprecated reg_polygon method
    r = diameter/2;
    regular_polygon(6,r);
}

module PoolFencePlug(id) {
    min_or=min_od  / 2;
    max_or=max_od / 2;
    cone_outer(hat_height, min_or, max_or);
    ir = id / 2;
    translate([0, 0, hat_height]) difference() {
        linear_extrude(inner_height) hexagon(id);
        linear_extrude(inner_height) hexagon(id - min_thickness);
    }
}

PoolFencePlug(20.8);
