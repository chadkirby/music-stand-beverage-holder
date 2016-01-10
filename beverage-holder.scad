$fs = 1;
$fa = 6;
bottleD = 65;
glassD1 = 60;
glassD2 = 88;
glassH = 135+13;
standD = 24 + 2.5;
holderHeight = 50;
wallThickness = 2.5;
gap = 2;
x=[65, 41, 24];

module glass(inflate = 0) {
	cylinder(d1 = glassD1+inflate, d2 = glassD2+inflate, h=glassH, center=false);
}

module bottle(inflate = 0) {
	cylinder(d = bottleD+inflate, h=glassH, center=false);
}

module moveToStand() {
    translate([0,20+glassD2/2,0]) children();
}

module stand() {
	moveToStand() translate([0,0,-100 + holderHeight + 25 - 10]) cylinder(d=standD, h=200, center=true);
	moveToStand() translate([0,0,50+ holderHeight + 25 - 10]) cylinder(d=17.5 + 3, h=100, center=true);
}
module limitZ(plus = 0) {
    intersection() {
        cylinder(r=100, h=holderHeight + plus, center=false);
        children();
    }
}
module rotStand() {
    translate([0, 5, 5]) rotate([10, 0, 0]) stand();
}
module standGap() {
    hull() {
        limitZ(-10) {
            rotStand();
            translate([50, -5, 0]) rotStand();
        }
    }
}
module standClamp() {
    cylinder(d=glassD2, h=holderHeight/2, center=false);
    limitZ()
        hull() {
            moveToStand() rotate([30,0,0]) cylinder(d=standD-10, h=10, center=false);
            cylinder(d=glassD2, h=holderHeight, center=false);
        }
    difference() {
        hull() {
            translate([0, 0, holderHeight - 15]) moveToStand() cylinder(d=standD + 10, h=15, center=false);
            translate([0, 4, 0]) moveToStand() cylinder(d=standD + 4, h=1, center=false);
            cylinder(d=standD + 10, h=holderHeight, center=false);

        }
        hull() {
            stand();
            translate([40, -15, 0]) stand();
            translate([0, -50, 0]) stand();
            translate([40, -50, 0]) stand();
        }
        standGap();
        translate([(holderHeight)*2 - (standD)/2, 0, 0]) moveToStand() cylinder(r1=(holderHeight)*2, r2=(holderHeight * 1.5), h=(holderHeight), center=false);
    }
}
module glassBottle() {
    translate([0, 0, -35]) {
        glass(gap);
        bottle(gap);
    }
}
module holder() {
	difference() {
		standClamp();
		translate([0, 0, 25]) stand();
        rotStand();
        translate([0, 0, holderHeight/2]) rotate([0, 90, 0]) cylinder(d=holderHeight/1.5, $fn=4, h=200, center=true);
        hull() {
            glassBottle();
            translate([0, -45, 200]) glassBottle();
        }
        #translate([0, -standD/2 - 6, 0]) moveToStand() cylinder(d=4.75, h=holderHeight - 25, center=false);
	}
}
holder();
