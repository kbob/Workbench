X        = [1, 0, 0];
Y        = [0, 1, 0];
Z        = [0, 0, 1];
A        = "a";

t        = 11/16;
w        = 48;
oh = 1;                         // overhang of shelf ends past legs

p_h      = 38.5;                // prop height
s_h      = 36;                  // shelf height

// Each leg has two components, leg-back and leg-side.

lbl      = p_h;
lbw      = 2.5;
lb_size  = [lbl, lbw, t];

lsl      = s_h - t;
lsw      = 1.5;
ls_size  = [lsl, lsw, t];

// backboard
bbl      = w + 2 * (lbw - t);
bbw      = 5.5;
bb_size  = [bbl, bbw, t];
bb_pos   = [t - lbw, -t, s_h - t - bbw];

// shelf
shl      = bbl + 2 * t + 2 * oh;
shw      = 7.5;
sh_size  = [shl, shw, t];
sh_pos   = [-lbw - t - oh, -shw - t, s_h - t];

// Boards: size (l, w, t), position (x, y, z), orientation, color
//    lb1, lb2: leg backs
//    ls1, ls2: leg sides
//    bb: backboard
//    sh: shelf

lb1 = [lb_size, [0, 0, 0],              [X, Z],    "red"      ];
ls1 = [ls_size, [t - lbw, -t -lsw, 0],  [Y, Y, Y], "yellow"   ];
lb2 = [lb_size, [w + lbw, 0, 0],        [X, Z],    "red"      ];
ls2 = [ls_size, [w + lbw, t - lsw, 0], [Y, Y, Y], "yellow"   ];
bb  = [bb_size, bb_pos,                 [X],       "lightgrey"];
sh  = [sh_size, sh_pos,                 [],        "white"    ];

boards = [lb1, ls1, lb2, ls2, bb, sh];
//boards = [lb1, ls1, lb2, ls2, bb];

module axes() {
    d = 0.3;
    h = 10;
    color("red")
        rotate(90, Y)
            cylinder(d=d, h=h);
    color("green")
        rotate(-90, X)
            cylinder(d=d, h=h);
    color("blue")
        cylinder(d=d, h=h);
}

module rotstar(i, r) {
    // echo("rotstar", r, i);
    if (i < len(r)) {
        if (r[i] == A) {
            echo("A");
            axes();
            rotstar(i + 1, r)
                children();
        } else {
            rotate(90, r[i])
                rotstar(i + 1, r)
                    children();
        }
    } else {
        children();
    }
}

module place_board(b) {
    translate(b[1])
        rotstar(0, b[2])
            color(b[3])
                cube(b[0]);
}

for (b = boards) {
    place_board(b);
}

echo("leg back", lb_size);
echo("leg side", ls_size);
echo("backboard", bb_size);
echo("shelf", sh_size);
