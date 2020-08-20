use <MCAD/boxes.scad>

CARD_THICKNESS_MAP=[
    -1,
    -1,
    0.3,
    0.6,
    1.0,
    1.2,
    1.7,
    -1,
    7
];
// suggested sizes: 2, 3, 4, 5, 6, 8
cards=3;
z=CARD_THICKNESS_MAP[cards];

outer_dim=[175, 105, z];
rad=10;

fn=72*4;
$fn=fn;

inner_dim=[130, 69, z];
inner_rad=30;
text_size=10;

label=str(cards, " cards / ", z , " mm");
echo(label);

difference() {
    roundedBox(outer_dim, rad, true);
    roundedBox(inner_dim, inner_rad, true);
    translate([
    -outer_dim.x / 2 + rad,
    outer_dim.y / 2 -text_size * 1.2,
    0
    ]) linear_extrude(z * 2) text(label, size=text_size);
}



