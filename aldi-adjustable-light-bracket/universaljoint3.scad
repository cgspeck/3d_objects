//// Based on customizable Universal joint by kijja on Thingiverse: https://www.thingiverse.com/thing:4096349

$fn=48; //[36, 48, 60]

//sleeve();
module sleeve(sleeve_dia,
            sleeve_length,
            shaft_dia,
            joint_dia,
            ep,
            sp,
            cl,
            joint_hole,
            fastener_hole,
    ){
    difference(){
        union(){
        intersection(){
    //solid wing
            hull(){
            cylinder(h=sleeve_dia, d=joint_dia, center=true, $fn=32);
            translate([sleeve_dia, 0, 0])
                cube([0.001, sleeve_dia, sleeve_dia], true);
            }//h
            rotate([0, 90, 0])
            cylinder(h=sleeve_dia*2, d=sleeve_dia, center=true);
        }//i
    //solid sleeve
        translate([joint_dia/2+sp+sleeve_length/2, 0, 0])
        rotate([0, 90, 0])
            cylinder(h=sleeve_length, d=sleeve_dia, center=true);
        }//u
    //make wing space
        cube([joint_dia+sp*2, sleeve_dia+ep, joint_dia+cl*2], true);
    //make joint hole
        cylinder(h=sleeve_dia+ep, d=joint_hole, center=true, $fn=24);
    //make shaft hole
        translate([joint_dia/2+sp+sleeve_length/2, 0, 0])
        rotate([0, 90, 0])
        cylinder(h=sleeve_length+ep, d=shaft_dia, center=true, $fn=32);
    //make fastener hole
        translate([joint_dia/2+sp+sleeve_length/2, 0, 0])
        cylinder(h=sleeve_dia, d=fastener_hole, center=true, $fn=24);
    }//d
}//m


module UniversalJoint3(part=0, cl=0.4, joint_hole=3.4, joint_dia=10, joint_len=20, shaft_dia1=8, sleeve_dia1=19, sleeve_len1=16, shaft_dia2=12, sleeve_dia2=25, sleeve_len2=20, fastener_hole=3.1, ry=-15, rz=15, ep=0.002, sp=1) {
    /*
    part: display parts [0:all, 1:sleeve1, 2:sleeve2, 3:joint]
    cl: clearance between joint and wings[0.4]

    [joint]
    joint_hole: diameter of joint's hole[(M3+loose tolerance)=3.4]
    joint_dia: outer diameter of joint[10];
    joint_len: length of the joint(hole to hole)[20]

[shaft1]
shaft_dia1: diameter of shaft1[8]
sleeve_dia1: diameter of sleeve1[19]
sleeve_len1: length of sleeve1[16]

[shaft2]
shaft_dia2: diameter of shaft2[12]
sleeve_dia2: diameter of sleeve2[25]
sleeve_len2: length of sleeve2[20]

[fastener]
fastener_hole: diameter of shaft's bolt[M3+tight tolerance=3.1] [2.8:0.1:4.5]

[rotation]
//ry: y axis rotation [-45:1:45]
//rz: z axis rotation [-45:1:45]

[Hidden]
//ep: remove difference effect[0.002]
//sp: space between joint and sleeve
*/
    //// main
    if (part==0 || part==3){
    color("LightPink")
    difference(){
        hull(){
        translate([joint_len/2, 0, 0])
            cylinder( h=joint_dia, d=joint_dia, center=true);
        rotate([90, 0, 0])
        translate([-joint_len/2, 0, 0])
            cylinder( h=joint_dia, d=joint_dia, center=true);
        }//h
        translate([joint_len/2, 0, 0])
        cylinder( h=joint_dia+ep, d=joint_hole, center=true, $fn=24);
        rotate([90, 0, 0])
        translate([-joint_len/2, 0, 0])
        cylinder( h=joint_dia+ep, d=joint_hole, center=true, $fn=24);
    }//d
    }//i
    //

    if (part==0 || part==1){
    color("PaleGreen")
    translate([joint_len/2, 0, 0])
    rotate([0, 0, rz])
        sleeve(sleeve_dia=sleeve_dia1,
            sleeve_length=sleeve_len1,
            shaft_dia=shaft_dia1,
            joint_dia=joint_dia,
            ep=ep,
            sp=sp,
            cl=cl,
            joint_hole=joint_hole,
            fastener_hole=fastener_hole
            );
    }//i
    //
    if (part==0 || part==2){
    color("Aquamarine")
    translate([-joint_len/2, 0, 0])
    rotate([90, ry, 0])
    mirror([1, 0, 0])
        sleeve(sleeve_dia=sleeve_dia2,
            sleeve_length=sleeve_len2,
            shaft_dia=shaft_dia2,
            joint_dia=joint_dia,
            ep=ep,
            sp=sp,
            cl=cl,
            joint_hole=joint_hole,
            fastener_hole=fastener_hole
            );
    }//i
    //
}


UniversalJoint3();
