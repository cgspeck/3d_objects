include <shared.scad>

od=10;
id=9;
z=1.1;

// attempted to make this directly in Prusa Slicer but got odd results
// after slicing
difference() {
    cylinder_outer(z, od/2);
    cylinder_outer(z, id/2);
}