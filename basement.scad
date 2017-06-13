// Jim's basement recording studio
// all units in inches

concrete_height = 9 * 12;
slab_thickness = 12;

basement = [400.5, 375, concrete_height];
jutout = [48, 160];

// Original uncarpeted area:
//studio = [161, 173];

// Alloted space from back wall:
studio = [161,250];
// Useless corner space dedicated to water main pipe and valve:
nw_corner_water_main = [26, 28];

// How much space to leave between concrete and studio walls:
studio_inner_cut = [12, 12];

// Inner studio dimensions:
studio_inner = studio - [0, nw_corner_water_main[1]] - studio_inner_cut * 2;
// Studio height off basement floor:
studio_inner_z = 3;

// draw outer walls minus ceiling (so we can look down in):
module walls(extents, height, thickness, north=true,east=true,south=true,west=true,floor=true) {
    nthick = north ? thickness : 0;
    ethick = east ? thickness : 0;
    sthick = south ? thickness : 0;
    wthick = west ? thickness : 0;
    union() {
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
        if (floor) {
            translate([-wthick, -nthick, -thickness])
                linear_extrude(thickness)
                square([extents[0]+wthick+ethick, extents[1]+nthick+sthick]);
        }
    }
}

// TODO: draw stairwell
module stairwell(extents) {
    linear_extrude(5)
    square(extents);
}

// Flip Y-coordinate:
mirror([0,1,0]) {
    // Basement walls:
    color("gray", 0.5)
        union() {
            difference() {
                walls(basement, concrete_height, slab_thickness);
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
                walls(jutout, concrete_height, slab_thickness, west=false);
            // utility room:
            translate([studio[0],-200,0])
                walls([basement[0]-studio[0], 200], concrete_height, slab_thickness, south=false);
        }

    // Stairwell:
    color("brown")
        translate([studio[0],44,0])
        stairwell([45, 140]);

    // Carpeted area:
    color("silver", 1)
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
        linear_extrude(0.5)
        difference() {
            square(studio);
            square(nw_corner_water_main);
        }
    
    // Studio room inner:
    color("blue")
        translate(studio_inner_cut + [0, nw_corner_water_main[1]])
        translate([0, 0, studio_inner_z])
        walls(studio_inner, concrete_height - studio_inner_z, 3.5);

}