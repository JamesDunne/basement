// 4-pc drum kit

translate([0, 0, 20])
    rotate([270+2.5, 0, 0])
    cylinder(22, 20, 20);

translate([-4.5, 20, 0]) {
    cube([9, 25, 0.75]);

    translate([0, 25, 0])
        rotate([-25, 0, 0])
        mirror([0, 1, 0])
        cube([9, 17, 0.25]);
}
