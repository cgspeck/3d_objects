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
    2
];

module ThicknessRollingFrame(card_count) {
    z=CARD_THICKNESS_MAP[card_count];

    outer_dim=[175, 105, z];
    rad=10;

    fn=72*4;
    $fn=fn;

    inner_dim=[130, 69, z];
    inner_rad=30;
    text_size=10;

    label=str(card_count, " cards / ", z , " mm");
    echo(label);

    difference() {
        roundedBox(outer_dim, rad, true);
        roundedBox(inner_dim, inner_rad, true);
        translate([
        -outer_dim.x / 2 + rad,
        outer_dim.y / 2 -text_size * 1.2,
        (z / 2) - min(z/2, 0.3)
        ]) linear_extrude(z) text(label, size=text_size);
    }
}

// supported sizes: 2, 3, 4, 5, 6, 8
card_sizes=[2, 3, 4, 5, 6, 8];

for (i=[0:1:(len(card_sizes)-1)]) {
    echo(i);
    translate([0, 120 * i]) ThicknessRollingFrame(card_sizes[i]);
}
