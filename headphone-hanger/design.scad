headband_width=54;
tounge_width=37;
drop=40;

// [ Hidden ]
min_thickness=2.4;
de_minimus=0.1;

tounge_rad=74;

hole_d=4.2;
counter_sink_d=8.8;

screw_margin=counter_sink_d * 2;

drop_z=10.5;
lip_z=5;

oh_dim=[
    screw_margin + tounge_width + screw_margin,
    5,
    drop_z + headband_width + lip_z,
];

tounge_thickness=5;

drop_dim=[
    tounge_width,
    drop,
    drop_z
];

drop_trans=[
    (oh_dim.x - drop_dim.x) / 2,
    oh_dim.y,
    0
];

tounge_dim=[
    tounge_width,
    tounge_thickness,
    oh_dim.z
];

hanger_trans=[
    (oh_dim.x - tounge_dim.x) / 2,
    oh_dim.y + drop_dim.y,
    0
];

drop_reo_sz=oh_dim.y + (2 * drop_dim.z);

drop_reo_yz_points=[
    [0, 0],
    [drop_reo_sz, 0],
    [0, drop_reo_sz],
];

drop_reo_trans=[
    drop_dim.x + ((oh_dim.x - drop_dim.x) / 2),
    0,
    0,
];

fn=72*4;
$fn=fn;

module cone_outer(height,radius1,radius2,fn=fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r1=radius1*fudge,r2=radius2*fudge,$fn=fn);
}

module toungeInner() {
    cylinder(r=tounge_rad - tounge_dim.y, h=tounge_dim.z, center=false);
}

module Tounge(h=tounge_dim.z) {
    difference() {
        cylinder(r=tounge_rad, h=h, center=false);
        toungeInner();
        translate([-tounge_rad, 0, 0]) cube([tounge_rad * 2, tounge_rad, h], center=false);
        translate([-tounge_rad, -tounge_rad, 0]) cube([(tounge_rad) - tounge_width / 2, tounge_rad, h], center=false);
        translate([tounge_width / 2, -tounge_rad, 0]) cube([(tounge_rad) - tounge_width / 2, tounge_rad, h], center=false);
    }
}

module Lip() {
    adz_z=oh_dim.z - lip_z;
    translate([0, 0, adz_z]) {
        difference() {
            hull() {
                translate(toung_vert_trans) {
                    Tounge(de_minimus);
                    translate([0, -lip_z, lip_z]) Tounge(de_minimus);
                }
            }
            translate([0, 0, -adz_z]) translate(toung_vert_trans) {
                toungeInner();
            }
        }
    }
}

hole_xz_pts=[
    [screw_margin / 2, screw_margin / 2],
    [screw_margin / 2, oh_dim.z - screw_margin / 2],
    [oh_dim.x - screw_margin / 2, screw_margin / 2],
    [oh_dim.x - screw_margin / 2, oh_dim.z - screw_margin / 2],
];

difference() {
    cube(oh_dim, center=false);
    for (hole_xz=hole_xz_pts) {
        translate([
            hole_xz[0],
            0,
            hole_xz[1]
        ]) rotate([270, 0, 0]) cone_outer(oh_dim.y, hole_d / 2, counter_sink_d / 2);
    }
}


toung_vert_trans=[
    (oh_dim.x) / 2,
    tounge_rad + drop_dim.y + tounge_dim.y,
    0
];

difference() {
    translate(drop_trans) cube([
        drop_dim.x,
        tounge_rad,
        drop_dim.z
    ], center=false);
    translate(toung_vert_trans) toungeInner();
}

intersection() {
    translate(toung_vert_trans) Tounge();
    Lip();
}

difference() {
    translate(toung_vert_trans) Tounge();
    translate(toung_vert_trans) translate([
        -drop_dim.x,
        -tounge_rad,
        oh_dim.z - lip_z,
    ]) cube([
        drop_dim.x * 2,
        lip_z * 2,
        lip_z
    ]);
}


translate(drop_reo_trans) rotate([0, 270, 0]) linear_extrude(drop_dim.x) polygon(points=drop_reo_yz_points);

Lip();
