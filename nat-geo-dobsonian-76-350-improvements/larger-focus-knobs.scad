include <helpers.scad>
include <shared.scad>

handle_rad=25;
handle_thickness=6;

existing_handle_od=29.66;
existing_handle_or=existing_handle_od/2;
existing_handle_height=12.25;

Handle(
    OUTDENT_COUNT=12,
    HANDLE_OUTDENT_RADIUS=4,
    WHEEL_RADIUS=handle_rad-1,
    HANDLE_THICKNESS=handle_thickness
);



module handle_base() {
    cylinder_outer(handle_thickness, handle_rad);
}

module existing_handle_cutout() {
    cylinder_outer(existing_handle_height + de_minimis, existing_handle_or);
}

module existing_handle_socket() {
    cylinder_outer(existing_handle_height, existing_handle_or + min_thickness);
}

difference() {
    hull() {
        handle_base();
        translate([
            0,0,handle_thickness
        ]) {
            existing_handle_socket();
        }
    }
    translate([
        0,0,handle_thickness
    ]) {
        existing_handle_cutout();
    }

}
