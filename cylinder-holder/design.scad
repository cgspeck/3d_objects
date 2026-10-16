include <BOSL2/std.scad>;

fn=72*4;
$fn=fn;
clearance_tight=0.2;
clearance_loose=0.4;

min_thickness=2.4;

$slop = clearance_tight;
epsilon = 0.001;

obj_diameter=90;
obj_radius=obj_diameter/2;
holder_height=20;

// y = +- sqrt(r2 - x2)
holder_width = sqrt(obj_radius * obj_radius - holder_height * holder_height);
echo("holder_height", holder_height);
echo("holder_width", holder_width);

side_radius=3;

holder_top_dim=side_radius * 4 + holder_width;
linear_extrude(1 * INCH) diff() {
    rect([holder_top_dim, holder_height], side_radius);
    tag("remove") back(obj_radius + side_radius) circle(d=obj_diameter);
}
