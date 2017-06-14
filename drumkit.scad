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
    // Yamaha Birch Absolute Custom
    // toms: 10 x 8, 12 x 9, 15 x 14, and 18 x 16
    // snare: 14 x 7 snare drum
    // kick: 24 x 18 bass drum

    // MB says:
    // Kick is 22, Tom's are 10, 12, 14 and 16. I use the 10 and 14 only
    // 14 hi hat, 22 ride, 16 and 18 splash, China I think is 16, 10 inch splash

    kick_r  = 11; kick_d  = 16; // 22" x 16"
    snare_r = 7;  snare_d =  7; // 14" x 7"
    floor_r = 7;  floor_d = 14; // 14" x 14"?
    rack_r  = 5;  rack_d  =  8; // 10" x 8"

    // kick:
    kick(r = kick_r, d = kick_d);

    // floor tom:
    translate([-18, 24, 12])
        rotate([-0, 10, 0])
        drum(r = floor_r, d = floor_d, t = 0.125);

    // rack tom:
    translate([16, 8, 21])
        rotate([-25, -8, 0])
        drum(r = rack_r, d = rack_d, t = 0.125);

    // snare:
    translate([12, 24, 15])
        rotate([-5, -5, 0])
        drum(r = snare_r, d = snare_d, t = 0.125);
}

kit();
