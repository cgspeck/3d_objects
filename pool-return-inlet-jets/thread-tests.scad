include <shared.scad>;
include <BOSL2/std.scad>;
use <BOSL2/shapes3d.scad>;
use <BOSL2/transforms.scad>;
use <threadlib/threadlib.scad>;

// see [Design of threadlib](https://github.com/adrianschlatter/threadlib/blob/develop/docs/DesignOfThreadlib.md)
// [pitch, Rrotation, Dsupport, section_profile]
unf2_nominal_major_dim=50.8;
// the adjustments below are derived from unf-1"
unf2_ext_major_dim=unf2_nominal_major_dim - 2.3881;
unf2_int_major_dim=unf2_nominal_major_dim + 0.751;
measured_1_int_major_dim=50 + 0.751; 
unf2_thread_table = [
    ["UNF-1-ext", [2.11667, 11.4968, 23.0119, [[0, -0.7937], [0, 0.7937], [1.1457, 0.1323], [1.1457, -0.1323]]]],
    ["UNF-1-int", [2.11667, -12.7467, 25.4751, [[0, 0.9260], [0, -0.9260], [1.1457, -0.2646], [1.1457, 0.2646]]]],
    // CUSTOM below!
    ["UNF-2-ext", [2.11667, unf2_ext_major_dim / 2 - 0.00915, unf2_ext_major_dim, [[0, -0.7937], [0, 0.7937], [1.1457, 0.1323], [1.1457, -0.1323]]]],
    ["UNF-2-int", [2.11667, -unf2_int_major_dim / 2 - 0.00915, unf2_int_major_dim , [[0, 0.9260], [0, -0.9260], [1.1457, -0.2646], [1.1457, 0.2646]]]],
    // based on measurements
    ["measured-1-int", [2.11667, -measured_1_int_major_dim / 2 - 0.00915, measured_1_int_major_dim , [[0, 0.9260], [0, -0.9260], [1.1457, -0.2646], [1.1457, 0.2646]]]],
];

nut("UNF-2", turns=3, Douter=62, nut_sides=6, table=unf2_thread_table);

right(100) nut("measured-1", turns=3, Douter=62, nut_sides=6, table=unf2_thread_table);
