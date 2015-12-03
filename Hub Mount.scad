eps = 0.1;
$fs = 0.1;

w = 145.2;
h1 = 27;
h2 = 0.6 + 11.8;
d = 63.2;
r = 5;

a = atan((h1 - h2) / d);
echo("a", a);

screw_len = 1.25 * 25.4;
board_t = 9/16 * 25.4;
screw_h = (screw_len - board_t) + 2;

// ear
et = screw_h;                   // ear thickness
ed = 20;                        // ear diameter
el = 20 + 2;                    // ear length
ewt = 2;                        // ear wall thickness

// screw
sd1 = 9;                        // screw diameter 1
sd2 = 4.2;                      // screw diameter 2
csl = 3.4;                      // countersink depth
csd = 2;                        // countersink depth

module box_xform(h1, d) {
	rotate(180 - a, [1, 0, 0])
		translate([0, -d, -h1])
			children();
}

module box(w, h1, h2, d, r, xh=0) {
	box_xform(h1, d)
		difference() {
			hull() {
				for (x = [r, w - r], y = [r, d - r])
					translate([x, y, 0])
						cylinder(h=h1 + xh + eps, r=r);
			}
			translate([0, 0, h2])
				rotate(a, [1, 0, 0])
					translate([-eps, -eps, xh])
						cube([w + 2 * eps,
						      (d + 2 * eps) / cos(a) + 2 * eps,
						      h1 - h2]);
				}
}

module countersink_bore() {
    translate([0, 0, -eps])
        cylinder(d=sd2, h=et + eps);
    translate([0, 0, et - csd - csl])
        cylinder(d1=sd2, d2=sd1, h=csl);
    translate([0, 0, et - csd - eps])
        cylinder(d=sd1, h=csd + 2 * eps);
}

module rear_ear() {
     y = d / cos(a) + ed / 2 + 2;
	translate([ed/2 - 3, y, 0])
		difference() {
			cylinder(d=20, h=et);
			countersink_bore();
		}
	translate([-3, d/2, 0])
		cube([2, y - d/2, et]);
}

module side_ear() {
	r1 = 8;
	t = 3;
	difference() {
		hull() {
			translate([-r1, r1, 0])
				cylinder(r=r1, h=t);
			translate([0, r1, 0])
				cylinder(r=r1, h=t);
		}
		translate([-r1, r1, eps]) {
			cylinder(d1=sd2, d2=sd1, h=t);
			cylinder(d=sd2, h=3*t, center=true);
		}
	}
}

module cutouts_left() {
	box_xform(h1, d) {
		translate([-5, 39, 5.5])
			cube([3, 14, 16.5]);
		translate([-5, 41, 7.5])
			cube([10, 10, 12.5]);
		translate([-5, 24.2, 9])
			rotate(90, [0, 1, 0])
				cylinder(d=11, h=10);
	}
}

module cutouts_right() {
	box_xform(h1, d)
		for (y = [22, 42.6])
			translate([-5, y-1, 6.6])
				cube([10, 18, 10]);
}

module end_wrap_left() {
	p = 2 * sin(a);
	difference() {
		union() {
			intersection() {
				translate([-3, -2, 0])
					box(w+4, h1 + 2 + p, h2 + 2 - p, d+4, r+2);
				translate([-3, -3, -3])
					cube([13, 2*d, 2*h1,]);
			}
			rear_ear();
			side_ear();
		}
		box(w, h1, h2, d, r, xh=3);
		cutouts_left();
	}
}

module end_wrap_right() {
	p = 2 * sin(a);
	scale([-1, +1, +1])
		difference() {
			union() {
				intersection() {
					translate([-3, -2, 0])
						box(w+4, h1 + 2 + p, h2 + 2 - p, d+4, r+2);
					translate([-3, -3, -3])
						cube([13, 2*d, 2*h1,]);
				}
				rear_ear();
				side_ear();
			}
			box(w, h1, h2, d, r, xh=3);
			cutouts_right();
		}
}

//box(w, h1, h2, d, r);

//end_wrap_left();

//translate([35, 20, 0])
	end_wrap_right();
