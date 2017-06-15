// Jim's basement recording studio
// all units in inches

concrete_height = 9 * 12;
slab_thickness = 6;

basement = [400.5, 375, concrete_height];
jutout = [48, 160];

stud24_w = 3.5;
stud24_h = 1.5;

// Original uncarpeted area:
//studio = [161, 173];

// Alloted space from back wall:
studio = [161,256+16];
// Useless corner space dedicated to water main pipe and valve:
nw_corner_water_main = [26, 28];

// How much space to leave between concrete and studio walls:
// studio_inner_cut = [16, 16];
studio_inner_cut = [0, 0];

// Inner studio dimensions:
studio_inner = studio - [0, nw_corner_water_main[1]] - studio_inner_cut * 2;
// Studio height off basement floor:
studio_inner_z = 3;

module stud(length, height, spacing = 16) {
    exact = (floor(length / spacing) - 1);
    remainder = length - (exact * spacing);
    offset = 0;
    if (remainder > 3) {
        offset = remainder * 0.5;
    }

    space = 0;
    for (n = [0 : exact]) {
        space = offset + n * spacing;
        translate([space, 0, 0])
            cube([stud24_h, stud24_w, height - stud24_h]);
        translate([space + stud24_h, 0, 0])
            cube([spacing - (stud24_h * 2), stud24_w, stud24_h]);
        translate([space + spacing - stud24_h, 0, 0])
            cube([stud24_h, stud24_w, height - stud24_h]);
        translate([space, 0, height - stud24_h])
            cube([spacing, stud24_w, stud24_h]);
    }

    if (remainder > 0) {
        // TODO: add remainder studs
    }
}

// draw outer walls minus ceiling (so we can look down in):
module walls(extents, height, thickness, north=true,east=true,south=true,west=true,floor=true, walls=false, studs=false) {
    nthick = north ? thickness : 0;
    ethick = east ? thickness : 0;
    sthick = south ? thickness : 0;
    wthick = west ? thickness : 0;
    union() {
        if (floor) {
            translate([0, 0, -thickness])
                linear_extrude(thickness)
                square([extents[0], extents[1]]);
        }
        if (studs) {
            if (north) {
                translate([0, 0, 0])
                    rotate([0, 0, 0])
                    stud(extents[0], height);
            }
            if (east) {
                translate([extents[0], 0, 0])
                    rotate([0, 0, 90])
                    stud(extents[1], height);
            }
            if (south) {
                translate([extents[0], extents[1], 0])
                    rotate([0, 0, 180])
                    stud(extents[0], height);
            }
            if (west) {
                translate([0, extents[1], 0])
                    rotate([0, 0, 270])
                    stud(extents[1], height);
            }
        }
        if (walls) {
            if (north) {
                translate([-wthick, -nthick, -thickness])
                    linear_extrude(height+thickness)
                    square([extents[0]+wthick+ethick, nthick]);
            }
            if (east) {
                translate([extents[0], -nthick, -thickness])
                    linear_extrude(height+thickness)
                    square([ethick, extents[1]+nthick+sthick]);
            }
            if (south) {
                translate([-wthick, extents[1], -thickness])
                    linear_extrude(height+thickness)
                    square([extents[0]+wthick+ethick, sthick]);
            }
            if (west) {
                translate([-wthick, -nthick, -thickness])
                    linear_extrude(height+thickness)
                    square([wthick, extents[1]+nthick+sthick]);
            }
        }
    }
}

// TODO: draw stairwell
module stairwell(extents, height) {
    linear_extrude(0.5)
    square(extents);

    // studs:
    translate([0, extents[1], 0])
        rotate([0, 0, 270])
        stud(extents[1], height, spacing = 14);

    translate([extents[0], 0, 0])
        rotate([0, 0, 90])
        stud(extents[1], height, spacing = 14);

    // steps:
    for (n = [0 : 14]) {
        translate([stud24_w, n * 11, (n+1) * 7])
            cube([45 - stud24_w * 2, 12, stud24_h]);
    }
}

use <drumkit.scad>;

// Flip Y-coordinate:
mirror([0,1,0]) {
    // Basement walls:
    color("gray", 1)
        union() {
            difference() {
                walls(basement, concrete_height, slab_thickness, walls=false);
                // jut out:
                translate([basement[0]-1,96,0])
                    linear_extrude(concrete_height+1)
                    square(jutout);
                // utility room:
                translate([studio[0],1,0])
                    mirror([0,1,0])
                    linear_extrude(concrete_height+1)
                    square([basement[0]-studio[0], slab_thickness+2]);
            }
            // jut out:
            translate([basement[0],96,0])
                walls(jutout, concrete_height, slab_thickness, west=false, walls=false);
            // utility room:
            translate([studio[0],-200,0])
                walls([basement[0]-studio[0], 200], concrete_height, slab_thickness, south=false, walls=false);
        }

    // Carpeted area:
    color("DarkGray", 1)
        linear_extrude(0.5)
        union() {
            difference() {
                // Full extent of the basement:
                square([basement[0],basement[1]]);
                // Subtract non-carpeted studio areas:
                square(studio);
                square(nw_corner_water_main);
                // Subtract area behind stairwell:
                translate([studio[0],0,0])
                    square([45, 44]);
                // Subtract stairwell:
                translate([studio[0],0,0])
                    square([45, 44+140]);
                // Workout corner area:
                translate([0,basement[1],0])
                    mirror([0,1,0])
                    square([72,95]);
            }
            translate([basement[0],96,0])
                square(jutout);
        }

    // Studio area:
    color("green", 1)
        translate([0,0,0])
        linear_extrude(0.25)
        difference() {
            square(studio);
            square(nw_corner_water_main);
        }

    // Stairwell:
    color("Sienna", 1)
        translate([studio[0],44+140,0])
        mirror([0, 1, 0])
        stairwell([45, 140], concrete_height);

    // Studio room inner:
    translate(studio_inner_cut + [0, nw_corner_water_main[1]])
        translate([0, 0, 0]) {
            // Outer walls:
            color("DarkBlue", 1)
                walls(studio_inner, concrete_height - studio_inner_z, 3.5, walls=false, studs=true, floor=false);

            translate([0, 0, studio_inner_z]) {
                // Inner walls:
                color("MediumBlue", 1)
                    translate([7, 7, 0])
                    walls(studio_inner - [14, 14], concrete_height - studio_inner_z - 2, 3.5, walls=false, studs=true, floor=true);

                // place the drum kit inside for scale:
                translate([60, 180, 0])
                    rotate([0, 0, 180])
                    mirror([0, 1, 0])
                    kit();
            }
        }

}