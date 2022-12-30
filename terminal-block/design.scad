include <MCAD/nuts_and_bolts.scad>

fn=72*3;
$fn=fn;

module cylinder_outer(height,radius,fn=fn)
{
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

module _nuthole_assembly(terminal_width, ridge_height, nutHoleDiameter, nut_section_height, full_height, de_minimus, clearance_loose, extra_nut_len) {
    translate([
        0,
        0,
        -extra_nut_len
    ]) resize([nutHoleDiameter, nutHoleDiameter, nut_section_height + extra_nut_len]) nutHole(3);
    cylinder_outer(full_height + de_minimus, (3 + clearance_loose) / 2);
}

module _nuthole_assemblies(terminal_count, terminal_width, ridge_width, ridge_height, term_cube_dim, nut_section_height, full_height, de_minimus, clearance_loose, extra_nut_len) {
    nutHoleDiameter=METRIC_NUT_AC_WIDTHS[3] + (0.0001 * 2);
    for (i=[1:terminal_count])
    {
        start_x = (i - 1) * (terminal_width + ridge_width);
        ridge_x = start_x - ridge_width;
        nut_tran=[
            term_cube_dim.x / 2,
            term_cube_dim.y / 2,
            0
        ];
        translate([start_x, 0, 0])
        {
            translate(nut_tran)
            {
                translate([0,0, term_cube_dim.z + ridge_height/2]) cube([terminal_width, terminal_width, ridge_height], center=true);
                _nuthole_assembly(terminal_width, ridge_height, nutHoleDiameter, nut_section_height, full_height, de_minimus, clearance_loose, extra_nut_len);
            }
        }
    }
}

module TerminalBlock(
    terminal_count=1,
    terminal_width=10,
    nut_section_height=METRIC_NUT_THICKNESS[3] * 1.5,
    bridge_section_height=2.4,
    ridge_width=1.2,
    ridge_height=4,
    base_only=false,
    ridge=true,
    cutout_only=false,
    clearance_loose=0.4,
    de_minimus=0.01,
    extra_nut_len=0
    )
{
    full_height=nut_section_height+bridge_section_height;
    full_length=terminal_count * terminal_width + (terminal_count - 1) * ridge_width;
    term_cube_dim=[terminal_width,terminal_width,full_height];

    if (cutout_only) {
        _nuthole_assemblies(terminal_count, terminal_width, ridge_width, ridge_height, term_cube_dim, nut_section_height, full_height, de_minimus, clearance_loose, extra_nut_len);
    } else {
        difference() {
            union() {
                cube([
                    full_length,
                    terminal_width,
                    full_height
                ]);

                if (ridge && !base_only) {
                    for (i=[1:terminal_count])
                    {
                        start_x = (i - 1) * (terminal_width + ridge_width);
                        ridge_x = start_x - ridge_width;
                        translate([start_x, 0, 0])
                        {
                            if (i > 1)
                            {
                                translate([
                                    - ridge_width,
                                    0,
                                    0
                                ]) cube([
                                    ridge_width,
                                    terminal_width,
                                    full_height + ridge_height
                                ]);
                            }
                        }
                    }
                }
            }

            if (!base_only) {
                _nuthole_assemblies(terminal_count, terminal_width, ridge_width, ridge_height, term_cube_dim, nut_section_height, full_height, de_minimus, clearance_loose, extra_nut_len);
            }
        }
    }
}

TerminalBlock();

translate([0,20,0]) TerminalBlock(2);

translate([0,40,0]) TerminalBlock(4);

translate([0,60,0]) TerminalBlock(4, base_only=true, ridge=false, cutout_only=false);

translate([0,80,0]) TerminalBlock(4, base_only=true, ridge=true, cutout_only=false);

translate([0,100,0]) TerminalBlock(4, base_only=false, ridge=true, cutout_only=true);

translate([0,120,0]) TerminalBlock(4, base_only=false, ridge=true, cutout_only=true, extra_nut_len=10);
