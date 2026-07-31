// Frontier module tray — 2×4 BENECREAT tapered cork storage
// Thin plate with raised rims + stiffening ribs

module_w     = 220;
module_d     = 110;
plate_h      = 3;

cork_bot_dia = 38;       // wide end (measured)
cork_top_dia = 33.6;     // narrow end (measured)
cork_h       = 15.6;     // height (measured)

taper_per_mm = (cork_bot_dia - cork_top_dia) / cork_h;

floor_t      = 2;        // pocket floor thickness
rim_h        = 7;        // rim height above plate
rim_wall     = 2;        // rim wall thickness
clearance    = 0;        // zero clearance — snug fit without interference

pocket_depth = plate_h - floor_t + rim_h;
pocket_d_bot = cork_top_dia + clearance;
pocket_d_top = pocket_d_bot + taper_per_mm * pocket_depth;

rim_outer_d  = pocket_d_top + 2 * rim_wall;

cols = 4;
rows = 2;

x_gap   = (module_w - cols * rim_outer_d) / (cols + 1);
y_gap   = (module_d - rows * rim_outer_d) / (rows + 1);
x_start = x_gap + rim_outer_d / 2;
y_start = y_gap + rim_outer_d / 2;
x_step  = rim_outer_d + x_gap;
y_step  = rim_outer_d + y_gap;

// --- Honeycomb parameters ---
hex_size = 12;       // flat-to-flat width of each hex cutout
hex_wall = 2;        // wall thickness between hexagons
hex_border = 3;      // solid border around tray edge

hex_spacing = hex_size + hex_wall;
hex_row_h   = hex_spacing * sin(60);

module honeycomb_grid() {
    nx = ceil(module_w / hex_spacing) + 1;
    ny = ceil(module_d / hex_row_h) + 1;
    intersection() {
        // limit to plate area minus border
        translate([hex_border, hex_border, -0.5])
            cube([module_w - 2 * hex_border,
                  module_d - 2 * hex_border,
                  plate_h + 1]);
        // hex field
        for (ix = [0 : nx])
            for (iy = [0 : ny])
                translate([ix * hex_spacing + (iy % 2) * hex_spacing / 2,
                           iy * hex_row_h,
                           -0.5])
                    cylinder(d = hex_size, h = plate_h + 1, $fn = 6);
    }
}

module honeycomb_cuts() {
    difference() {
        honeycomb_grid();
        // keep-out zones — preserve solid floor under each pocket
        for (c = [0 : cols - 1])
            for (r = [0 : rows - 1])
                translate([x_start + c * x_step,
                           y_start + r * y_step,
                           -1])
                    cylinder(d = rim_outer_d + 2, h = plate_h + 2, $fn = 64);
    }
}

// --- Assembly ---

difference() {
    union() {
        // flat plate
        cube([module_w, module_d, plate_h]);

        // raised rims
        for (c = [0 : cols - 1])
            for (r = [0 : rows - 1])
                translate([x_start + c * x_step,
                           y_start + r * y_step,
                           plate_h])
                    cylinder(h = rim_h, d = rim_outer_d, $fn = 64);
    }

    // tapered pockets
    for (c = [0 : cols - 1])
        for (r = [0 : rows - 1])
            translate([x_start + c * x_step,
                       y_start + r * y_step,
                       floor_t])
                cylinder(h = pocket_depth + 0.1,
                         d1 = pocket_d_bot, d2 = pocket_d_top,
                         $fn = 64);

    // honeycomb cutouts (pocket floors preserved)
    honeycomb_cuts();
}

// preview cork in first hole
%translate([x_start, y_start, floor_t])
    cylinder(h = cork_h,
             d1 = cork_top_dia, d2 = cork_bot_dia,
             $fn = 64);
