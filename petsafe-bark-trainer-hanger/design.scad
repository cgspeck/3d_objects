include <shared.scad>

inner_x=45;
h0h1_y=40;
h1h2_y=50;

bolt_dia=6;

bearer_x=min_thickness;
bolt_edge_padding=bolt_dia * 2;

y_max=bolt_edge_padding + h0h1_y + bolt_dia + h1h2_y + bolt_edge_padding;
z_max=bolt_dia * 2;

x_max=bearer_x * 2 + inner_x;
// ------------------------------------------
bolt_rad=6/2 + clearance_loose;


bearer_dim=[bearer_x, y_max, z_max];

difference() {
    union() {
        cube(bearer_dim);
        translate([inner_x + min_thickness,0,0]) cube(bearer_dim);
        translate([
            min_thickness, 
            y_max - min_thickness - bolt_edge_padding - h0h1_y,
            0
        ]) cube([inner_x, bolt_rad, z_max]);
    }
    translate([
        0,
        y_max - bolt_edge_padding,
        z_max/2
    ]) rotate([0,90,0]) cylinder_outer(x_max, bolt_rad);
    translate([
        0,
        bolt_edge_padding,
        z_max/2
    ]) rotate([0,90,0]) cylinder_outer(x_max, bolt_rad);
}
