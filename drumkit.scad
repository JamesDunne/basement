// 4-pc drum kit

module shell(r, d, t = 0.5) {    
    difference() {
        // Solid body:
        cylinder(d, r, r, $fn = 40);
        // Carve out inner shell:
        translate([0, 0, -1])
            cylinder(d + 2, r - t, r - t, $fn = 40);
    }
}

module kick(r = 11, d = 16, t = 0.5) {
    translate([0, 0, r])
        rotate([270, 0, 0]) {
            color("BurlyWood", 1)
                shell(r, d, t);

            // Resonant skin:
            color("white", 0.85)
                translate([0, 0, 1])
                difference() {
                    cylinder(0.125, r - t, r - t, $fn = 40);

                    // Sound hole:
                    translate([3, 3, -0.5])
                        cylinder(1, 3, 3, $fn = 40);
                }

            // Beater skin:
            color("white", 0.85)
                translate([0, 0, d - (1 + t*0.5)])
                cylinder(0.125, r - t, r - t, $fn = 40);
        }
}

module drum(r = 7, d = 5, t = 0.25, st = 0.125) {
    color("BurlyWood", 1)
        shell(r, d, t);

    // Resonant skin:
    color("white", 0.85)
        translate([0, 0, d - (0.5 + st*0.5)])
        cylinder(st, r - t, r - t, $fn = 40);

    // Resonant skin:
    color("white", 0.85)
        translate([0, 0, (0.5 - st*0.5)])
        cylinder(st, r - t, r - t, $fn = 40);
}

module tom(r = 7, d = 5) {
    cylinder(d, r, r, $fn = 40);
}

module kit() {
    kick_r = 11;
    kick_d = 16;
    snare_r = 7;
    snare_d = 5;
    floor_r = 8;
    floor_d = 12;

    // kick:
    kick(r = kick_r, d = kick_d);

    // snare:
    translate([12, 24, kick_r*2 - snare_d])
        rotate([-25, -10, 0])
        drum(r = snare_r, d = snare_d, t = 0.125);
    
    // floor tom:
    translate([-18, 22, 6])
        rotate([-5, 5, 0])
        drum(r = floor_r, d = floor_d, t = 0.125);
}
