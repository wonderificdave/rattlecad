module insertForkBladeMax_left() {
//
//  -- insertForkBladeMax
//
    //  -- ForkCrown
    hull() {
        translate(v = [440.20757288352183, 0, 400.5749260454105]) {
            rotate([0,-18,0]) {
                translate(v = [0, 5, -3]) {
                    scale(v = [1, 0.5, 0.2]) {
                        sphere(d = 25);
                    }
                }
            }
        }
        translate(v = [584.4533316498124,53,84.13697664785134]) {
            rotate([4,-23.01905950468886,0]) {
                translate(v = [-23,0,322.5976950985368]) {
                    union() {
                        sphere(d = 7.5, center = false);
                        translate(v = [23,0,0]) {
                            sphere(d = 18.5, center = false);
                        }
                        rotate([0,90,0]) {
                            cylinder(h = 23, d1 = 7.5, d2 = 18.5, center = false);
                        }
                    }
                }
            }
        }
    }
    //  -- ForkBlade
    translate(v = [584.4533316498124,53,84.13697664785134]) {
        rotate([4,-23.01905950468886,0]) {
            hull() {
                translate(v = [0,0,230]) {
                    cylinder(h = 92.5976950985368, d = 18.5, center = false);
                }
                cylinder(h = 92.5976950985368, d1 = 14, d2 = 18.5, center = false);
                translate(v = [-23.0,0,230]) {
                    sphere(d = 7.5, center = false);
                    cylinder(h = 92.5976950985368, d = 7.5, center = false);
                }
            }
        }
    }
//
//
}//
//
//
//
//     -> FrontDropout -- create --
//
module insertForkDropoutMax_left() {
    translate([0,52.5,0]) {
        rotate([90,0,0]) {
            hull() {
                translate([584.4533316498124,84.13697664785134,0]) 
                cylinder(r=7,h=3,center=true);
                translate([592.8824524862517,66.0,0]) 
                cylinder(r=11,h=3,center=true);
            }
            translate([592.8824524862517,66.0,0]) { 
                cylinder(r=10,h=5,center=true);
            }
        }
    }
}
//
//
//
//     -> Steerer -- create --
module insertSteerer() {
    translate(v = [440.20757288352183, 0, 400.5749260454105]) {
        rotate([0,-17.5,0]) {
            translate(v = [0, 0, -12]) 
            cylinder(h = 234.80677826056024, d = 28.6, center = false);
        }
    }
    translate(v = [440.20757288352183, 0, 400.5749260454105]) {
        rotate([0,-17.5,0]) {
            translate(v = [0, 0, -20]) 
            cylinder(h = 20, d = 34.0, center = false);
        }
    }
}
//
//
// rattleCAD - Fork
//
translate([0,0,270.000]) {
    color("Green") 
    union() {
        insertForkBladeMax_left();
        insertForkDropoutMax_left();
        mirror([0,1,0]){
            insertForkBladeMax_left();
            insertForkDropoutMax_left();
         }
        insertSteerer();
    }
}
//
