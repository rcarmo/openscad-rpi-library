//------------------------------------------------------------------------
// OpenSCAD models of miscellaneous components and devices:
// various Raspberry Pi models, SainSmart Relays, PCD8544 LCD, etc.
//
// Author:      Niccolo Rigacci <niccolo@rigacci.org>
// Version:     1.0 2017-12-14
// License:     GNU General Public License v3.0
//------------------------------------------------------------------------

include <misc_parts.scad>;

// Interference for 3D union(), difference() and intersection();
// used to avoid the manifold problem.
interf = 0.1;

// $incolor is used to determine if color should be applied or colors should
// be undef. Colors must be defined per module to allow for this to override.
$incolor = (is_undef($incolor)) ? true : $incolor;

//------------------------------------------------------------------------
// m25_standard_hole Standard fit M2.5 hole size definition
//------------------------------------------------------------------------
module m25_standard_hole() {
	circle(r=(2.75 / 2), $fn=16);
}

//------------------------------------------------------------------------
// Move copies of children to positions in passed array
//------------------------------------------------------------------------
module array_holes(pos) {
	for (pos=pos) {			
			translate(pos) children();
	}
}

//------------------------------------------------------------------------
// 1602A LCD panel 16x2 characters.
//------------------------------------------------------------------------
module lcd_1602a() {
    $fn = 32;
	boardc  = $incolor ? "green"  : undef;

    translate([4.5, 5.5, 1.8])  color([64/255, 64/255, 128/255]) cube([71, 24, 7]);
    color(boardc) linear_extrude(height = 1.8) difference() {
        square(size=[80, 36]);
        translate([3, 3])           circle(r=3.2/2, center = true);
        translate([80 - 3, 3])      circle(r=3.2/2, center = true);
        translate([80 - 3, 36 - 3]) circle(r=3.2/2, center = true);
        translate([3, 36 - 3])      circle(r=3.2/2, center = true);
    }
}

//------------------------------------------------------------------------
// Matrix of 2.54 mm pins.
//------------------------------------------------------------------------
module pin_headers(cols, rows) {
    w = 2.54; h = 2.54; p = 0.65;
	pinc  = $incolor ? "gold"  : undef;
	basec = $incolor ? "black" : undef;
	
    for(x = [0 : (cols -1)]) {
        for(y = [0 : (rows  - 1)]) {
            translate([w * x, w * y, 0]) {
                union() {
                    color(basec) cube([w, w, h]);
                    color(pinc)  translate([(w - p) / 2, (w - p) / 2, -3]) cube([p, p, 11.54]);
                }
            }
        }
    }
}

//------------------------------------------------------------------------
// Two-relays module manufactured by SainSmart (or alike).
//------------------------------------------------------------------------
module board_2relays_sainsmart() {
    // Board with 3.0 mm holes.
    pcb_thick = 1.6;
	boardc = $incolor ? "darkgreen" : undef;
    difference() {
        color(boardc) cube([39.0, 51.0, pcb_thick]);
        translate([2.75, 2.75, -interf]) {
            translate([   0,    0, 0]) cylinder(r=1.5, h=(2 + interf * 2), $fn=16);
            translate([33.5,    0, 0]) cylinder(r=1.5, h=(2 + interf * 2), $fn=16);
            translate([   0, 45.5, 0]) cylinder(r=1.5, h=(2 + interf * 2), $fn=16);
            translate([33.5, 45.5, 0]) cylinder(r=1.5, h=(2 + interf * 2), $fn=16);
        }
    }
    translate([ 3.8, 12.2, pcb_thick])  color(relayc) cube([15, 19, 16]);
    translate([20.2, 12.2, pcb_thick])  color(relayc) cube([15, 19, 16]);
    translate([ 3.8,    4, pcb_thick])  color(relayc) cube([15, 8, 10.2]);
    translate([20.2,    4, pcb_thick])  color(relayc) cube([15, 8, 10.2]);
    translate([ 9, 46.5, 1.6]) pin_headers(4, 1);
    translate([ 9, 46.5, 1.6]) dupont_female(4, 1, [-1, 1, 0]);
    translate([24, 46.5, 1.6]) pin_headers(3, 1);
}

//------------------------------------------------------------------------
// Two-relays module manufactured by Keyes.
//------------------------------------------------------------------------
module board_2relays_keyes() {
	boardc = $incolor ? "red" : undef;
    // Board with 3.6 mm holes.
    difference() {
        color(boardc) cube([45.5, 55, 2]);
        translate([3.5, 9, -interf]) {
            translate([ 0,  0, 0]) cylinder(r=1.8, h=(2 + interf * 2), $fn=16);
            translate([38,  0, 0]) cylinder(r=1.8, h=(2 + interf * 2), $fn=16);
            translate([0,  40, 0]) cylinder(r=1.8, h=(2 + interf * 2), $fn=16);
            translate([38, 40, 0]) cylinder(r=1.8, h=(2 + interf * 2), $fn=16);
        }
    }
    translate([7.5, 15, 2])  color(relayc) cube([15, 19, 16]);
    translate([23, 15, 2])   color(relayc) cube([15, 19, 16]);
    translate([14.5, 48, 2]) pin_headers(6, 1);
}

//------------------------------------------------------------------------
// PCD8544 LCD module (from Nokia 5110/3310 phones), blue PCB.
// Pin on bottom, 3.2 mm holes spaced 34.5 x 41
//------------------------------------------------------------------------
module board_pcd8544_blue() {
	boardc  = $incolor ? "darkblue" : undef;
	shieldc = $incolor ? "silver"   : undef;

    difference() {
        color(boardc) cube([43, 45.5, 1.2]);
        translate([4.25, 2.25, -interf]) {
            translate([ 0.0,  0, 0]) cylinder(r=1.6, h=(1.2 + interf * 2), $fn=16);
            translate([34.5,  0, 0]) cylinder(r=1.6, h=(1.2 + interf * 2), $fn=16);
            translate([ 0.0, 41, 0]) cylinder(r=1.6, h=(1.2 + interf * 2), $fn=16);
            translate([34.5, 41, 0]) cylinder(r=1.6, h=(1.2 + interf * 2), $fn=16);
        }
    }
    // Frame and LCD screen.
    difference() {
        translate([1.5, 6.0, 1.2])
            color(shieldc) cube([40, 34, 4]);
        translate([3.25, 7.5, 1.2 + 4 - 0.5])
            cube([36.5, 26, 0.6]);
    }
    translate([10.5, 2 + 2.54, 0])
        rotate(a=180, v=[1, 0, 0]) {
            pin_headers(8, 1);
            dupont_female(8, 1, [1, 1, 0]);
        }
}

//------------------------------------------------------------------------
// PCD8544 LCD module (from Nokia 5110/3310 phones), red PCB.
// Pin on top, 2.5 mm holes spaced 40 x 39
//------------------------------------------------------------------------
module board_pcd8544_red() {
	boardc = $incolor ? "red"     : undef;
	shieldc = $incolor ? "silver" : undef;

    difference() {
        color(boardc) cube([43.5, 43.0, 1.2]);
        translate([1.75, 2.0, -interf]) {
            translate([ 0,  0, 0]) cylinder(r=1.25, h=(1.2 + interf * 2), $fn=16);
            translate([40,  0, 0]) cylinder(r=1.25, h=(1.2 + interf * 2), $fn=16);
            translate([ 0, 39, 0]) cylinder(r=1.25, h=(1.2 + interf * 2), $fn=16);
            translate([40, 39, 0]) cylinder(r=1.25, h=(1.2 + interf * 2), $fn=16);
        }
    }
    // Frame and LCD screen.
    difference() {
        translate([1.75, 5, 1.2])
            color(shieldc) cube([40, 34, 4]);
        translate([3.5, 7, 1.2 + 4 - 0.5])
            cube([36.5, 26, 0.6]);
    }
    translate([11.5, 42.5, 0])
        rotate(a=180, v=[1, 0, 0]) {
            pin_headers(8, 1);
            dupont_female(8, 1, [-1, 1, 0]);
        }
}

//------------------------------------------------------------------------
// Sub-models for the Raspberry Pi Models
//------------------------------------------------------------------------
module video_rca() {
    x = 10; y = 9.8; z = 13;
    d = 8.3; h = 9.5;
	
	shieldc = $incolor ? "silver" : undef;
	
    color("yellow") cube([x, y, z]);
    translate([-h, y / 2, (d / 2) + 4])
        rotate(a=90, v=[0, 1, 0])
            color(shieldc) cylinder(r=(d / 2), h=h);
}
module audio_jack() {
    x = 11.4; y = 12; z = 10.2;
    d = 6.7; h = 3.4;
    color("blue") cube([x, y, z]);
    translate([-h, y / 2, (d / 2) + 3])
        rotate(a=90, v=[0, 1, 0])
            color("blue") cylinder(r=(d / 2), h=h);
}
module ethernet_connector(x, y, z) {
    color($incolor ? "silver" : undef) cube([x, y, z]);
}
module usb_connector(x, y, z) {
    f = 0.6; // Flange
	shieldc = $incolor ? "silver" : undef;
    color(shieldc) { 
		cube([x, y, z]);
		translate([-f, y - f, -f])
			cube([x + f * 2, f, z + f * 2]);
	}
}
module hdmi_connector(x, y, z) {
	shieldc = $incolor ? "silver" : undef;
    color(shieldc) cube([x, y, z]);
}
module microusb_connector(x, y, z) {
	shieldc = $incolor ? "silver" : undef;
    color(shieldc) cube([x, y, z]);
}
module capacitor(d, h) {
	shieldc = $incolor ? "silver" : undef;
    color(shieldc) cylinder(r=(d / 2), h=h);
}
module micro_sd_card() {
	shieldc = $incolor ? "silver" : undef;
    color(shieldc)   translate([0,  0.0, -1.5]) cube([14, 13, 1.5]);
    color($incolor ? "darkblue" : undef) translate([2, -3.2, -1.0]) cube([11, 15, 1.0]);
}
module audio_video(size_x) {
	avc = $incolor ? [58/255, 58/255, 58/255] : undef;
    color(avc) {
        cube([size_x, 7, 5.6]);
        translate([size_x, 7 / 2, 5.6 / 2]) rotate([0,90,0]) cylinder(d=5.6, h=2.6);
    }
}

//------------------------------------------------------------------------
// Raspberry Pi Model B v.2
//------------------------------------------------------------------------
module board_raspberrypi_model_b_v2() {

    $fn = 32;
    x  = 56;     y = 85;    z =  1.6;	// Official PCB size
    //ex = 15.40; ey = 21.8; ez = 13.0;	// Official Ethernet offset
    ex = 16.00; ey = 21.3; ez = 13.5;	// Measured Ethernet offset
    ux = 13.25; uy = 17.2; uz = 15.3;	// Official USB connector size
    hx = 11.40; hy = 15.1; hz = 6.15;	// Official HDMI connector size
    mx =  7.60; my =  5.6; mz = 2.40;	// Official micro USB power connector size

    // The origin is the lower face of PCB.
    translate([0, 0, z]) {
        translate([x - 2 - ex, y - ey + 1, 0])     ethernet_connector(ex, ey, ez);
        translate([1.5, 1.0, 0])                   pin_headers(2, 13);
        //translate([1.5, 1.0, 0])                 dupont_female(1, 6, [-1, -1, 0]);
        translate([2.1, 40.6, 0])                  video_rca();
        translate([0, 59.0, 0])                    audio_jack();
        translate([18.8, 85 - uy + 7.7, 0])        usb_connector(ux, uy, uz);
        translate([x - hx + 1.2, 37.5, 0])         hdmi_connector(hx, hy, hz);
        translate([x - mx - 3.6, -0.5, 0])         microusb_connector(mx, my, mz);
        translate([14, -18, -4.4])                 sd_card();     // Inserted
        //translate([14, -32, -4.4])               sd_card();     // Extracted
        translate([x - mx, -3, 1.2])               rotate(a=180, v=[0, 0, 1]) usb_male_micro_b_connector();
        translate([49.35, 12.75])                  capacitor(6.5, 8);
        translate([18.8 + 0.625, 83, 10.4])        wifi_usb_edimax();
        translate([0, 0, -z]) {
            color(boardc) linear_extrude(height=z)
                difference() {
                    square([x, y]);
                    raspberrypi_model_b_v2_holes();
                }
        }
    }
}

//------------------------------------------------------------------------
// Holes for the Raspberry Pi Model B v.2.
//------------------------------------------------------------------------
module raspberrypi_model_b_v2_holes() {
    x = 56; y = 85;
	holes=[
		[(x - 18), 25.5],
		[12.5, (y - 5)] 
	];
	
	if ($children > 0) {
		array_holes(pos=holes) children();
	} else {
		array_holes(pos=holes) m25_standard_hole();		
	}
}

//------------------------------------------------------------------------
// Raspberry Pi Model A+ rev.1.1
//------------------------------------------------------------------------
module board_raspberrypi_model_a_plus_rev1_1() {

    $fn = 32;
    x  = 56;     y = 65;    z = 1.60;  // Measured PCB size
    hx = 11.40; hy = 15.1; hz = 6.15;  // Measured HDMI connector size
    ux = 13.25; uy = 13.8; uz = 6.0;   // Measured USB connector size
    mx =  5.60; my =  7.6; mz = 2.40;  // Measured micro USB power connector size

    // The origin is the lower face of PCB.
    translate([0, 0, z]) {
        translate([1.0, 7.1, 0])                    pin_headers(2, 20);
        translate([x - hx + 1, 32.0 - (hy / 2), 0]) hdmi_connector(hx, hy, hz);
        translate([x - mx + 1, 10.6 - (my / 2), 0]) microusb_connector(mx, my, mz);
        translate([18, y - 12, 0.8])                usb_connector(ux, uy, uz);
        translate([20.5, 0.8, -z])                  micro_sd_card();
        translate([x - 12.8, 50, 0])                audio_video(12.8);
        translate([18.6, y - 6, 1.4])               wifi_usb_edimax();
        translate([x + 2.2, 10.55, 1.2])            rotate(a=270, v=[0, 0, 1]) usb_male_micro_b_connector();
        translate([0, 0, -z]) {
            color(boardc) linear_extrude(height=z)
                difference() {
                    hull() {
                        translate([  3,   3]) circle(r=3);
                        translate([x-3,   3]) circle(r=3);
                        translate([x-3, y-3]) circle(r=3);
                        translate([  3, y-3]) circle(r=3);
                    }
                    raspberrypi_model_a_plus_rev1_1_holes();
                }
        }
    }
}

//------------------------------------------------------------------------
// Holes for the Raspberry Pi Model A+ rev.1.1.
//------------------------------------------------------------------------
module raspberrypi_model_a_plus_rev1_1_holes() {
 	off=3.5;
	x=49 + off;
	y=58 + off;
	holes=[
		[off,off], [x, off],
		[off, y],  [x, y]
	];
	
	if ($children > 0) {
		array_holes(pos=holes) children();
	} else {
		array_holes(pos=holes) m25_standard_hole();		
	}
}


//------------------------------------------------------------------------
// Raspberry Pi 3 Model B v.1.2.
//------------------------------------------------------------------------
module board_raspberrypi_3_model_b(microusb=true) {
    x  = 56;     y = 85;    z = 1.60;  // Measured PCB size
    ex = 15.9; ey = 21.5; ez = 13.5;   // Ethernet measure
    ux = 13.1; uy = 17.1; uz = 15.5;   // Measured USB connector size
    hx = 11.40; hy = 15.1; hz = 6.15;  // Measured HDMI connector size
    mx =  5.60; my =  7.6; mz = 2.40;  // Measured micro USB power connector size

	boardc  = $incolor ? "green"  : undef;

    // The origin is the lower face of PCB.
    translate([0, 0, z]) {
        translate([1.0, 7.1, 0])                    pin_headers(2, 20);
        translate([x - ex - 2.3, y - ey + 2.1, 0])  ethernet_connector(ex, ey, ez);
        translate([ 2.5, 85 - uy + 2.1, 0])         usb_connector(ux, uy, uz);
        translate([20.5, 85 - uy + 2.1, 0])         usb_connector(ux, uy, uz);
        translate([x - hx + 1.8, 25, 0])            hdmi_connector(hx, hy, hz);
        translate([x - 12.8, 50, 0])                audio_video(12.8);
        translate([20.5, 0.8, -z])                  micro_sd_card();
        translate([x - mx + 1, 7, 0])               microusb_connector(mx, my, mz);
        if (microusb)
			translate([x + 2.2, 10.55, 1.2])            rotate(a=270, v=[0, 0, 1]) usb_male_micro_b_connector();
        translate([0, 0, -z]) {
            color(boardc) linear_extrude(height=z)
                difference() {
                    hull() {
                        translate([  3,   3]) circle(r=3);
                        translate([x-3,   3]) circle(r=3);
                        translate([x-3, y-3]) circle(r=3);
                        translate([  3, y-3]) circle(r=3);
                    }
                    raspberrypi_3_model_b_holes();
                }
        }
    }
}

//------------------------------------------------------------------------
// Holes for the Raspberry Pi B+, 2B, 3B, 3B+ and 4B Models.
//------------------------------------------------------------------------

module raspberrypi_3_model_b_holes() {
    x0 = 3.5; y0 = 3.5; x = 49; y = 58;
    translate([x0, y0]) {
        translate([0, 0]) circle(r=(2.75 / 2), $fn=16);
        translate([x, 0]) circle(r=(2.75 / 2), $fn=16);
        translate([0, y]) circle(r=(2.75 / 2), $fn=16);
        translate([x, y]) circle(r=(2.75 / 2), $fn=16);
    }
}

//------------------------------------------------------------------------
// Raspberry Pi 4 Model B - (Credits to Richard Jelbert)
//------------------------------------------------------------------------
module board_raspberrypi_4_model_b() {
    fn = 64;
    x  = 56;    y = 85;    z = 1.40;   // Measured PCB size
    ex = 15.9; ey = 21.5; ez = 13.5;   // Ethernet port size
    ux = 13.1; uy = 17.1; uz = 15.5;   // Measured USB connector size
    hx = 7.80; hy = 6.5; hz = 3;       // Measured micro HDMI connector size
    mx =  7.60; my =  9; mz = 3.20;    // Measured USB-C power connector size
    module rpi4_cpu() { color("silver") cube([15, 15, 2.4]); }
    module rpi4_ram() { color("black") cube([15, 10.2, 1]); }
    module rpi4_wifi() { color("silver") cube([12, 10, 1.5]); }
    module rpi4_cameracon() { color("black") cube([22, 2.5, 5.5]); }
    module rpi4_usbc_connector(x, y, z) { color("silver") cube([x, y, z]); }
    // The origin is the lower face of PCB.
    translate([0, 0, z]) {
        translate([56-32.5-7.5,3.5+25.75-7.5,0]) rpi4_cpu();
        translate([56-32.5-7.5,3.5+43.75-7.5,0]) rpi4_ram();
        translate([7,6.5,0]) rpi4_wifi();
        translate([(56/2)-12,(4-1.25),0]) rpi4_cameracon();
        translate([(56)-22.3,(45),0]) rpi4_cameracon();
        translate([1.0, 7.1, 0]) pin_headers(2, 20);
        translate([x-(ex/2)-45.75, y - ey + 2.1, 0]) ethernet_connector(ex, ey, ez);
        translate([x-(ux/2)-27, 85 - uy + 2.1, 0]) usb_connector(ux, uy, uz);
        translate([x-(ux/2)-9, 85 - uy + 2.1, 0]) usb_connector(ux, uy, uz);
        translate([x - hx + 1.8, (3.5+7.7+14.8-(hy/2)), 0]) hdmi_connector(hx, hy, hz);
        translate([x - hx + 1.8, (3.5+7.7+14.8+13.5-(hy/2)), 0]) hdmi_connector(hx, hy, hz);
        translate([x - 12.8, 50, 0]) audio_video(12.8);
        translate([x - mx + 1, (3.5+7.7-(my/2)), 0]) rpi4_usbc_connector(mx, my, mz);
        //translate([20.5, 0.8, -z]) micro_sd_card();
        translate([0, 0, -z]) {
            color("green") linear_extrude(height=z)
                difference() {
                    hull() {
                        translate([  3,   3]) circle(r=3, $fn = fn);
                        translate([x-3,   3]) circle(r=3, $fn = fn);
                        translate([x-3, y-3]) circle(r=3, $fn = fn);
                        translate([  3, y-3]) circle(r=3, $fn = fn);
                    }
                    raspberrypi_3_model_b_holes();
                }
        }
    }
}

//------------------------------------------------------------------------
// GPS u-blox NEO-6M.
//------------------------------------------------------------------------
module ublox_neo6m_gps() {
	pinc   = $incolor ? "gold"                    : undef;
	shieldc = $incolor ? "silver"                 : undef;
	boardc = $incolor ? [239/255, 32/255, 64/255] : undef;
	
    x = 24; y = 36; z = 0.80;
    holes_x = 18;
    holes_y = 30;
    hole_off_x = (x - holes_x) / 2;
    hole_off_y = (y - holes_y) / 2;
    pin_off_x = (x - 2.54 * 5) / 2;
    color(boardc) linear_extrude(height=z) {
        difference() {
           square(size = [x, y]);
           translate([hole_off_x, hole_off_y]) circle(r=1.5, center=true, $fn=24);
           translate([hole_off_x + holes_x, hole_off_y]) circle(r=1.5, center=true, $fn=24);
           translate([hole_off_x, hole_off_y + holes_y]) circle(r=1.5, center=true, $fn=24);
           translate([hole_off_x + holes_x, hole_off_y + holes_y]) circle(r=1.5, center=true, $fn=24);
        }
    }
    translate([2, 12, z]) color(shieldc) cube(size=[15, 12, 2.4]);
    translate([9, 33, z+0.7]) color(pinc) cylinder(r=1.3, h=1.4, center=true, $fn=24);
    //translate([pin_off_x, 3.54, 0]) rotate(a=180, v=[1, 0, 0]) pin_headers(5, 1);
    translate([pin_off_x, 3.54, 0]) rotate(a=180, v=[1, 0, 0]) pin_right_angle_low(5, 1);
}

//------------------------------------------------------------------------
// GYBMEP: BME280 pressure, humidity and temperature sensor.
//------------------------------------------------------------------------
module bme280_gybmep() {
    x = 10.5; y = 14; z = 1.5;
    pin_off_x = (x - 2.54 * 4) / 2;
	boardc  = $incolor ? [134/255, 49/255, 117/255] : undef;
    shieldc = $incolor ? "silver" : undef;
	
	color(boardc) linear_extrude(height=z) {
        difference() {
            square(size = [x, y]);
            translate([2.8, 10.9]) circle(r=1.5, center=true, $fn=24);
        }
    }
    translate([6.0, 9.6, z]) color(shieldc) cube(size=[2.5, 2.5, 0.93]);
    //translate([pin_off_x, 2.54, 0]) rotate(a=180, v=[1, 0, 0]) pin_headers(4, 1);
    translate([pin_off_x, 2.54, 0]) rotate(a=180, v=[1, 0, 0]) pin_right_angle_low(4, 1);
}

//------------------------------------------------------------------------
// GY-521: MPU-6050 Accelerometer and Gyroscope.
//------------------------------------------------------------------------
module mpu6050_gy521() {
    x = 21; y = 15.6; z = 1.2;
	
	boardc = $incolor ? [30/255, 114/255, 198/255] : undef; 
	sensec = $incolor ? [60/255, 60/255, 60/255]   : undef;
    color(boardc) linear_extrude(height=z) {
        difference() {
            square(size = [x, y]);
            translate([3, y-3]) circle(r=1.5, center=true, $fn=24);
            translate([x-3, y-3]) circle(r=1.5, center=true, $fn=24);
        }
    }
    translate([8.3, 5.6, z]) color(sensec) cube(size=[4.0, 4.0, 0.9]);
    //translate([0.34, 2.54, 0]) rotate(a=180, v=[1, 0, 0]) pin_headers(8, 1);
    translate([0.34, 2.54, 0]) rotate(a=180, v=[1, 0, 0]) pin_right_angle_low(8, 1);
}

//------------------------------------------------------------------------
// GY-273: QMC5883L 3-Axis Magnetic Sensor.
//------------------------------------------------------------------------
module qmc5883l_gy273() {
    x = 13.6; y = 18.5; z = 1.15;
    pin_off_x = (x - 2.54 * 5) / 2;
	
	sensorc = $incolor ? [30/255, 114/255, 198/255] : undef;
	boardc  = $incolor ? [60/255, 60/255, 60/255]   : undef;
	
    color(sensorc) linear_extrude(height=z) {
        difference() {
            square(size = [x, y]);
            translate([2.5, y-3]) circle(r=1.5, center=true, $fn=24);
            translate([x-2.5, y-3]) circle(r=1.5, center=true, $fn=24);
        }
    }
    translate([5.1, 8.3, z]) color(boardc) cube(size=[3.0, 3.0, 0.9]);
    //translate([pin_off_x, 2.54, 0]) rotate(a=180, v=[1, 0, 0]) pin_headers(5, 1);
    translate([pin_off_x, 2.54, 0]) rotate(a=180, v=[1, 0, 0]) pin_right_angle_low(5, 1);
}

//------------------------------------------------------------------------
// X835 V1.1 SATA board for the Raspberry Pi, by Suptronics.com.
//------------------------------------------------------------------------
module suptronics_x835() {

    pcb_x = 101.6; pcb_y = 162.8; pcb_z = 1.75;         // X835 board PCB size.
    legs_above_height = 11.7; legs_below_height = 32;   // Legs sizes.
    legs_offset_x = 6.0; legs_offset_y = 3.5;           // Legs distance from edges.
    usb_x1 = 14.5; usb_y1 = 13.2; usb_z1 = 5.75;        // USB socket body.
    usb_x2 =  0.5; usb_y2 = 14.4; usb_z2 = 7.00;        // USB socket external flange.
    usb_x3 = 10.0; usb_y3 = 12.0; usb_z3 = 4.50;        // USB socket hole.
    usb_x4 = 10.0; usb_y4 = 11.0; usb_z4 = 1.60;        // USB socket Key.
    usb_pos = [27.0, 48.0, 80.976, 101.976];            // USB sockets positions.
    rpi_mod_b_x = 56; rpi_mod_b_y = 85;                 // Raspberry Pi Model B PCB size.
    rpi_mod_b_holes_offset = 3.5;                       // Distance from the edges.
    hd_stands_pos = [37.60, 69.35, 113.80];             // Hard disk stands positions.
    hd_a5 = 3.18;                                       // HD bottom screw holes from edge.
    pow_x = 14.0; pow_y = 9.0; pow_z = 11.0;            // Power socket size.
    pow_hole_diam = 6.2; pow_hole_x = 9.5;              // Power socket hole.
    pow_pin_diam = 2.55;                                // Power socket pin.
    legs_above_pos = [
        [ 0,  0],
        [49,  0],
        [ 0, 58],
        [49, 58]
    ];
    legs_below_pos = [
        [legs_offset_x, legs_offset_y],
        [pcb_x - legs_offset_x, legs_offset_y],
        [pcb_x - legs_offset_x, pcb_y - legs_offset_y],
        [legs_offset_x, pcb_y - legs_offset_y]
    ];

    // Submodule for standing legs.
    module x835_leg(height) {
        hole_depth = 5;
        hole_diam = 2.6;
        difference() {
            cylinder(r=5.20/2, h=height, $fn=6);
            translate([0, 0, -interf]) cylinder(r=hole_diam/2, h=hole_depth, $fn=32);
            translate([0, 0, height-hole_depth+interf]) cylinder(r=hole_diam/2, h=hole_depth, $fn=32);
        }
    }

    // Submodule for hard disk standings.
    module x835_hd_stand() {
        hd_stand_height = 2.70;
        hd_stand_diam = 5.50;
        hd_stand_hole_diam = 2.50;
        translate([0, 0, -(hd_stand_height / 2)])
            color("silver") difference() {
                cylinder(center=true, r=hd_stand_diam/2, h=hd_stand_height, $fn=48);
                cylinder(center=true, r=hd_stand_hole_diam/2, h=hd_stand_height+interf*2, $fn=32);
            }
    }

    // Submodule for USB ports.
    module x835_usb_port() {
        color("silver")
            difference() {
                union() {
                    cube(center=true, size=[usb_x1, usb_y1, usb_z1]);
                    translate([(usb_x1 - usb_x2) / 2, 0, 0])
                        cube(center=true, size=[usb_x2, usb_y2, usb_z2]);
                }
                translate([(usb_x1 - usb_x3) / 2 + interf, 0, 0])
                    cube(center=true, size=[usb_x3, usb_y3, usb_z3]);
            }
        color([0/255, 0/255, 198/255]) translate([(usb_x1 - usb_x3) / 2, 0, usb_z4 / 2])
            cube(center=true, size=[usb_x4, usb_y4, usb_z4]);
    }

    // Submodule for 12 V power socket.
    module x835_power_socket() {
        color([35/255, 35/255, 35/255])
            difference() {
                cube(center=true, size=[pow_x, pow_y, pow_z]);
                translate([(pow_x-pow_hole_x)/2+interf, 0, (pow_y - pow_hole_diam) / 2])
                    rotate(a=90, v=[0, 1, 0])
                    cylinder(center=true, r=pow_hole_diam/2, h=pow_hole_x, $fn=32);
            }
        color("silver")
            translate([(pow_x - pow_hole_x) / 2, 0, (pow_y - pow_hole_diam) / 2])
                rotate(a=90, v=[0, 1, 0])
                    cylinder(center=true, r=pow_pin_diam/2, h=pow_hole_x, $fn=32);
    }

    translate([0, 0, legs_below_height]) {
        // The PCB.
        color ([43/255, 53/255, 77/255]) linear_extrude(height=pcb_z) {
            difference() {
                square(size=[pcb_x, pcb_y]);
                // Bottom legs holes.
                for(center = legs_below_pos) {
                    translate(center) circle(r=1.25, $fn=24);
                }
                // RPi holes.
                translate([pcb_x - rpi_mod_b_y, rpi_mod_b_x])
                    rotate(a=270, v=[0, 0, 1])
                        raspberrypi_3_model_b_holes();
                // HD holes.
                for(pos = hd_stands_pos) {
                    translate([pcb_x - hd_a5, pos]) circle(r=1.25, $fn=24);
                    translate([hd_a5, pos]) circle(r=1.25, $fn=24);
                }
            }
        }
        // HD stands.
        for(pos = hd_stands_pos) {
            translate([pcb_x - hd_a5, pos, 0]) x835_hd_stand();
            translate([hd_a5, pos, 0]) x835_hd_stand();
        }
        // USB ports.
        translate([pcb_x - (usb_x1 / 2), 0, pcb_z + (usb_z2 / 2)]) {
            for(pos = usb_pos) {
                translate([0, pos, 0])
                        x835_usb_port();
            }
        }
        // Power socket.
        translate([pcb_x - (pow_x / 2), pcb_y - 25.8, pcb_z + pow_z / 2])
            x835_power_socket();
    }
    // Bottom legs.
    for(center = legs_below_pos)
        translate(center) x835_leg(legs_below_height);
    // Top legs.
    translate([pcb_x - rpi_mod_b_y + rpi_mod_b_holes_offset, rpi_mod_b_x - rpi_mod_b_holes_offset, legs_below_height + pcb_z])
        rotate(a=270, v=[0, 0, 1])
            for(center = legs_above_pos)
                translate(center) x835_leg(legs_above_height);
}
