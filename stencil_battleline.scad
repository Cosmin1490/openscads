// Battleline arrow shoulder pad stencil
// Thin spherical shell matching purchased Ultramarines.stl curvature
// Print in TPU with 0.2mm nozzle

// Pad curvature (from Ultramarines.stl analysis)
sphere_r = 4.2;       // inner radius (pad surface)
shell_t  = 0.5;       // shell wall thickness
outer_r  = sphere_r + shell_t;

// Dome apex at origin, sphere center at (0, y_off, sphere_r)
y_off = -1.42;        // sphere center below stencil center (height dir)

// Frame and clip
frame_w = 9.5;
frame_h = 7.5;
clip_z  = 3.63;       // how high the shell wraps (gives ~4.13mm depth)

// Battleline arrow
arrow_w  = 4;
arrow_h  = 5;
head_h   = 2.5;
shaft_w  = 1.2;

module arrow_2d() {
    polygon([
        [0, arrow_h / 2],
        [-arrow_w / 2, arrow_h / 2 - head_h],
        [-shaft_w / 2, arrow_h / 2 - head_h],
        [-shaft_w / 2, -arrow_h / 2],
        [shaft_w / 2, -arrow_h / 2],
        [shaft_w / 2, arrow_h / 2 - head_h],
        [arrow_w / 2, arrow_h / 2 - head_h],
    ]);
}

difference() {
    intersection() {
        // thin spherical shell
        difference() {
            translate([0, y_off, sphere_r])
                sphere(r = outer_r, $fn = 128);
            translate([0, y_off, sphere_r])
                sphere(r = sphere_r, $fn = 128);
        }

        // clip to dome portion and frame
        translate([-frame_w / 2, -frame_h / 2, -outer_r])
            cube([frame_w, frame_h, outer_r + clip_z]);
    }

    // arrow cutout projected through the dome
    translate([0, 0, -1])
        linear_extrude(height = sphere_r * 2 + 2)
            arrow_2d();
}
