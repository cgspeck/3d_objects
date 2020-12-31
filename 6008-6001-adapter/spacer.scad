fn=72*4;
$fn=fn;

clearance_tight=0.2;
clearance_loose=0.4;

module cylinder_mid(height,radius,fn=fn) {
   fudge = (1+1/cos(180/fn))/2;
   cylinder(h=height,r=radius*fudge,$fn=fn);
}
z=2.5;
od=14;
id=5;
inner_clearance=clearance_tight;
outer_clearance=0;
difference() {
    cylinder_mid(z, (od / 2) + outer_clearance);
    cylinder_mid(z, (id / 2) + inner_clearance);
}
