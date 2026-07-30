// Painting handle — shoulder pad cradle
// Lollipop style: base, stem, half-cylinder cradle with tack hole

// base
base_dia = 40;
base_h   = 5;

// stem
stem_dia = 8;
stem_h   = 50;

// cradle — convex half-cylinder matching pad interior
pad_inner_r = 4.25;     // ~8.5mm dia — MEASURE YOUR PAD
cradle_len  = 10;       // length of half-cylinder along pad axis
clearance   = 0.5;
cradle_r    = pad_inner_r - clearance;

// tack hole
tack_dia    = 3.5;
tack_depth  = 3;

// base
cylinder(h = base_h, d = base_dia, $fn = 64);

// stem
translate([0, 0, base_h])
    cylinder(h = stem_h, d = stem_dia, $fn = 64);

// cradle — half-capsule (rounded ends to match pad interior)
translate([0, 0, base_h + stem_h])
difference() {
    intersection() {
        hull() {
            translate([-(cradle_len / 2 - cradle_r), 0, 0])
                sphere(r = cradle_r, $fn = 64);
            translate([(cradle_len / 2 - cradle_r), 0, 0])
                sphere(r = cradle_r, $fn = 64);
        }
        translate([-cradle_len, -cradle_len, 0])
            cube([cradle_len * 2, cradle_len * 2, cradle_r + 1]);
    }

    // tack hole in top of curve
    translate([0, 0, cradle_r - tack_depth])
        cylinder(h = tack_depth + 0.1, d = tack_dia, $fn = 32);
}

// ghost shoulder pad sitting on cradle
%translate([0, 0, base_h + stem_h])
intersection() {
    difference() {
        rotate([0, 90, 0])
            cylinder(h = cradle_len + 2, r = pad_inner_r + 1.5,
                     center = true, $fn = 64);
        rotate([0, 90, 0])
            cylinder(h = cradle_len + 3, r = pad_inner_r,
                     center = true, $fn = 64);
    }
    translate([-cradle_len, -cradle_len, 0])
        cube([cradle_len * 2, cradle_len * 2, pad_inner_r + 5]);
}
