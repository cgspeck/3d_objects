use <MCAD/regular_shapes.scad>

min_od=20;
max_od=23;
hat_height=5;
inner_height=10;
min_thickness=2.4;

module cone_outer(height,radius1,radius2,fn=72){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r1=radius1*fudge,r2=radius2*fudge,$fn=fn);
}

module PoolFencePlug(id) {
    echo("id", id);
    min_or=min_od  / 2;
    max_or=max_od / 2;
    cone_outer(hat_height, min_or, max_or);
    ir = id / 2;
    translate([0, 0, hat_height]) difference() {
        linear_extrude(inner_height) hexagon(false, id, false);
        linear_extrude(inner_height) hexagon(false, id - min_thickness, false);
    }
}


PoolFencePlug(20);

translate([30, 0, 0]) PoolFencePlug(20.4);

translate([60, 0, 0]) PoolFencePlug(20.8);
