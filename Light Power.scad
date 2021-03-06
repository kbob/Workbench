eps = 0.1;
$fs = 0.4;
$fa = 6;

h = 31.7;
w = 64.5;
r = 3.5;
foh = 1.6;                      // front overhang
boh = 8;                        // back overhang
bid = 0.4;                      // back inset depth
bil = 9.6;                      // back inset length

swt = 3;                        // side wall thickness
bwt = 2;                        // bottom wall thickness
ft = 1;                         // face thickness
bw = 20;                        // bracket depth

ppw = 22.2;                     // power port width
pph = 17;                       //            height
ppr = 3;                        //            radius

screw_len = 1.25 * 25.4;
board_t = 9/16 * 25.4;

screw_h = (screw_len - board_t) + 2;

// ear
et = screw_h;                   // ear thickness
ed = bw;                        // ear diameter
el = bw + 2;                    // ear length
ewt = 2;                        // ear wall thickness

// screw

sd1 = 9;                        // screw diameter 1
sd2 = 4.2;                      // screw diameter 2
csl = 3.4;                      // countersink depth
csd = 2;                        // countersink depth

module countersink_bore() {
    translate([0, 0, -eps])
        cylinder(d=sd2, h=et + eps);
    translate([0, 0, et - csd - csl])
        cylinder(d1=sd2, d2=sd1, h=csl);
    translate([0, 0, et - csd - eps])
        cylinder(d=sd1, h=csd + 2 * eps);
}

module bottom_ear() {
    x0 = -el / 2 - swt;

    difference() {
        union() {
            translate([x0, 0, ed / 2])
                rotate(90, [-1, 0, 0])
                    cylinder(d=ed, h=et);
            translate([x0, 0, 0])
                cube([w / 2 - x0, et, ewt]); 
            translate([x0, 0, ed - ewt])
                cube([w / 2 - x0, et, ewt]); 
        }
        translate([x0, 0, ed / 2])
            rotate(90, [-1, 0, 0])
                    // {
                    // translate([0, 0, -eps])
                    //     cylinder(d=sd2, h=et + eps);
                    // translate([0, 0, et - csd - csl])
                    //     cylinder(d1=sd2, d2=sd1, h=csl);
                    // translate([0, 0, et - csd - eps])
                    //     cylinder(d=sd1, h=csd + 2 * eps);
                    // }
                countersink_bore();
    }
}

module front_ear() {
    x0 = w + swt;
    y0 = h + 2 * bwt + el / 2;

    difference() {
        union() {
            translate([x0, y0, ed / 2])
                rotate(90, [0, -1, 0])
                    cylinder(d=ed, h=et);
            translate([x0 - et, h / 2, 0])
                       cube([ewt, y0 - h / 2, ed]);
            translate([x0 - ewt, h / 2, 0])
                       cube([ewt, y0 - h / 2, ed]);
        }
        translate([x0, y0, ed / 2])
            rotate(90, [0, -1, 0])
                 countersink_bore();
    }
}

module outside() {
    hull()
        for (x = [r, w - r], y = [r + bwt, h - r + bwt])
            translate([x, y, 0])
                scale([(r + swt) / r, (r + bwt) / r, 1])
                    cylinder(r=r, h=bw);
     
}

module inside() {
    hull()
        for (x = [r, w - r], y = [r + bwt, h - r + bwt])
            translate([x, y, ft])
                cylinder(r=r, h=bw + eps);
//     hull()
//         for (x = [r, w - r], y = [r, h - r])
//             translate([x, y, ft])
//                 cylinder(r=r - bid, h=bil + eps);
    hull()
        for (x = [(w - ppw) / 2 + ppr, (w + ppw) / 2 - ppr],
             y = [(h - pph) / 2 + ppr + bwt, (h + pph) / 2 - ppr + bwt])
            translate([x, y, -eps])
               cylinder(r=ppr, h=ft + 2 * eps);
}

module bracket() {
    difference() {
        intersection() {
            // translate([-100, 0, -eps])
            //     cube([200, 100, 100]);
            union() {
                outside();
                bottom_ear();
                front_ear();
            }
        }
        inside();
    }
}

bracket();
translate([0, -5, 0])
    scale([+1, -1, +1])
        bracket();
