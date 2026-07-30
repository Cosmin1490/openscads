// Frontier module tray — 2×4 BENECREAT tapered cork storage
// Thin plate with raised rims + stiffening ribs

module_w     = 209.5;
module_d     = 99.5;
plate_h      = 5;

cork_bot_dia = 38;       // wide end (measured)
cork_top_dia = 33.6;     // narrow end (measured)
cork_h       = 15.6;     // height (measured)

taper_per_mm = (cork_bot_dia - cork_top_dia) / cork_h;

floor_t      = 2;        // pocket floor thickness
rim_h        = 7;        // rim height above plate
rim_wall     = 2;        // rim wall thickness
clearance    = 0.5;

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
}

// preview cork in first hole
%translate([x_start, y_start, floor_t])
    cylinder(h = cork_h,
             d1 = cork_top_dia, d2 = cork_bot_dia,
             $fn = 64);
