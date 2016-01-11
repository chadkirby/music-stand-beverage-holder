$fs = 1;
$fa = 6;
bottleD = 65;
glassDBottom = 60;
glassDTop = 88;
glassH = 135+13;
standD = 24 + 1.5;
holderHeight = 50;
wallThickness = 2.5;
gap = 2;
x=[65, 41, 24];

module glass(inflate = 0) {
	cylinder(d1 = glassDBottom+inflate, d2 = glassDTop+inflate, h=glassH, center=false);
}

module bottle(inflate = 0) {
	cylinder(d = bottleD+inflate, h=glassH, center=false);
}

module moveToStand() {
    translate([0,20+glassDTop/2,0]) children();
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
        limitZ() {
            rotStand();
            translate([50, 0, 0]) rotStand();
        }
    }
}
module standClamp() {
    limitZ()
        hull() {
            moveToStand() rotate([30,0,0]) cylinder(d=standD-10, h=10, center=false);
            cylinder(d=glassDTop, h=holderHeight, center=false);
        }
    difference() {
        hull() {
            translate([0, 0, holderHeight - 15]) {
                moveToStand() {
                    cylinder(d=standD + 10, h=15, center=false);
                    translate([0, 4, 0]) cylinder(d=standD + 4, h=1, center=false);
                }
            }
            cylinder(d=standD + 10, h=holderHeight, center=false);

        }
        hull() {
            stand();
            translate([40, -15, 0]) stand();
            translate([0, -50, 0]) stand();
            translate([40, -50, 0]) stand();
        }
        //standGap();
        //translate([(holderHeight)*2 - (standD)/2, 0, 0]) moveToStand() cylinder(r1=(holderHeight)*2, r2=(holderHeight * 1.5), h=(holderHeight), center=false);
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
        standGap();
        rotStand();
        *translate([0, 0, holderHeight/2]) rotate([0, 90, 0]) cylinder(d=holderHeight/1.5, $fn=4, h=200, center=true);
        hull() {
            glassBottle();
            translate([0, -40, 130]) glassBottle();
        }
        clampAxis();
        moveToClampOrigin() hull() {
            cylinder(h=15.5, d=11, center=false);
            translate([0, 10, 0]) cylinder(h=15.5, d=11, center=false);
            translate([20, 0, 0]) cylinder(h=15.5, d=11, center=false);
        }
	}
}
module bolt() {
    cylinder(d=7.7, h=5, center=false);
    cylinder(d=5.1, h=11, center=false);
    cylinder(d=4.1, h=36, center=false);
}
module moveToClampOrigin() {
    translate([standD/2 + 4, -20, 0]) moveToStand() children();
}
module clampAxis(h=50, d=4) {
    moveToClampOrigin() cylinder(d=d, h=h, center=false);
}
module clamp(inflate = 0) {
    height = 12;
    difference() {
        union() {
            moveToStand() cylinder(d=inflate+32, h=inflate+height, center=false);
            hull() {
                clampAxis(d=inflate+10, h=inflate+height);
                translate([-2, 22, 0]) clampAxis(d=inflate+3, h=inflate+height);
            }
            moveToStand() hull() {
                translate([0, standD/2 + 1.5, 0])
					cylinder(d=3+inflate, h=height+inflate, center=false);
                translate([0, standD/2 + 4, 0])
                    cylinder(d=3+inflate, h=height+inflate, center=false);
            }
        }
        moveToStand() rotate([0,0,-25]) hull() {
            cylinder(d=inflate+24, h=inflate+height, center=false);
            translate([0, -20, 0]) cylinder(d=inflate+12, h=inflate+height, center=false);
        }
        translate([-12, -10, 0]) moveToStand() cylinder(d=inflate+25, h=inflate+height, center=false);
    }
}
translate([0,0,holderHeight * 1]) rotate([180 * 1, 0, 0])
difference() {
    holder();
	rotate([-20,0,0]) translate([0,0,-holderHeight/2-5]) cylinder(r=100, h=100, center=true);
}
translate([0,0,10 * 1]) rotate([0, 180 * 1, 0])
difference() {
    clamp();
    moveToClampOrigin() bolt();
}
