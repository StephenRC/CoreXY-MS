///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Corexy-x-carriage - x carriage for makerslide and vertical x-axis with 8mm rods
// created: 2/3/2014
// last modified: 10/25/2016
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/12/16 - added bevel on rear carriage for x-stop switch to ride up on
// 1/21/16 - added Prusa i3 style extruder mount to makerslide carriage and put it into a seperate module
// 3/6/16  - added BLTouch mounting holes, sized for the tap for 3mm screws (centered behind hotend)
// 5/24/16 - adjusted makerslide carriage for i3(30mm) mount by making it a bit wider
//			 added a proximity sensor option
// 6/27/16 - added corexy belt holder
// 7/2/16  - new file from x-carraige.scad and removed everything not needed for corexy
//			 one belt clamp set per side
// 7/3/16  - added tappable mounting holes for the endstopMS.scad holders
//			 added all() to print everything
//			 added third wall to the belt holder frame (it broke without one)
//			 added assembly info
// 7/17/16 - adjusted proximity sensor position
// 8/1/16  - added note on extruder plate & proximity sensor
// 9/11/16 - added irsensor bracket to extruder plate
// 9/16/16 - added combined rear carriage & belt holder
// 9/26/16 - design for using the E3D Titan
// 10/25/16 - added Titan mount for AL extruder plate and for mounting right on x-carraige using i3x_sep
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// What rides on the x-axis is separate from the extruder plate
// The screw2 holes must be drilled with a 2.5mm drill for a 3mm tap or to allow a 3mm to be screwed in without tapping
// I used 3x16mm cap head screws to mount the extruder plate to the carriage
// ---------------------------------------------------------
// PLA can be used for the carriage & belt parts
// ---------------------------------------------------------
// Extruder plate use ABS or better if you have a hotend that gets hot at it's mounting.
// for example: using an E3DV6, PLA will work fine, since it doesn't get hot at the mount.
// ---------------------------------------------------------
// Each belt holder uses 3 3x25mm screws and 3 3mm nuts
// Put round one on the screws first, followed by the slotted one, then it mount on the holder.
// One screw & nut in the adjuster hole, screw head pointing to front, belt anvil on nut side.
// Left side use lower adjuster hole
// Right side use upper adjuster hole
// Assemble both belt clamps before mounting on x-carriage, leave loose enough to install belts
// The four holes on top are for mounting an endstopMS.scad holder, tap them with a 5mm tap.
//----------------------------------------------------------
// If the extruder plate is used with an 18mm proximity sensor, don't install the center mounting screw, it gets
// in the way of the washer & nut.
//-----------------------------------------------------------
// Changed to using a front & rear carriage plate with the belt holder as part of it.  The single carriage plate
// wasn't solid enough, the top started to bend, loosening the hold the wheels had on the makerslide
//-----------------------------------------------------------
// To use rear carriage belt in place of the belt holder, you need three M5x50mm, three 7/8" nylon M5 spacers along
// with the three makerslide wheels, three M5 washers, three M5 nuts, two M3x16mm screws
//////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/configuration.scad> // http://github.com/prusajr/PrusaMendel, which also uses functions.scad & metric.scad
include <inc/screwsizes.scad>
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
use <inc/Nema17.scad>	// https://github.com/mtu-most/most-scad-libraries
$fn=50;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// variables
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
wall = 8;		// thickness of the plates
width = 75;		// width of back/front/extruder plates
depth = wall;	// used where depth is a better description
height = 90;	// height of the back/front plates
widthE = width;	// extruder plate width
depthE = wall;	// thickness of the extruder plate
heightE = 60; 	// screw holes may need adjusting when changing the front to back size
dual_sep = 50.6; // distance between bottom two wheels (this is less than what's on a standard carriage aluminum plate)
tri_sep = 64.6;	// distance between bottom two wheels and top wheel
screw = 5.4;	// makerslide wheel screw hole (all the screw holes are oversize since slic3r makes them too small)
screw_hd = 12.5;	// size of hole for screw head for countersink
screw4 = 4.5;	// extruder mount screw hole
screw3 = 3.5;	//3mm screw hole
screw2 = 2.6;	// 3mm screw tapping hole size
screw5 = 5.7;	// 5mm screw hole
screw5t = 4.5;	// 5mm tapping hole size
adjuster = 7.3; // adjuster hole size
extruder = 50;	// mounting hole distance
extruder_back = 18; // adjusts extruder mounting holes from front edge
strutw=8;		// little side struts
struth = 25;
fan_spacing = 32;
fan_offset = -6;  // adjust to align fan with extruder
servo_spacing = 32;
servo_offset = 20; // adjust to move servo mount
screw_depth = 25;
vertx_distance = 70; // distance between x rods for vertical x axis
ps_spacer = 10.5; // don't need to print support between lm8uu holders, adjust this when width changes
i3x_sep = 23;	// mount for Prusa i3 stlye extruder; Wilson is 23, Prusa i3 is 30
i3x_ht = 11.5;	// move the Prusa i3 extruder mounting holes up/down
psensord = 19;	// diameter of proximity sensor (x offset is 0)
layer = 0.2;	// printed layer thickness
// BLTouch variables - uses the screw2 size for the mounting holes, which work fine with the provided screws or can
// ----------------   tapped for 3mm screws
bltouch = 18;// hole distance on BLTouch by ANTCLabs
bltl = 30;	// length of bltouch mount plus a little
bltw = 16;	// width of bltouch mount plus a little
bltd = 14;	// diameter of bltouch body plus 1mm
bltdepth = -2;	// a recess to adjust the z position to keep the retracted pin from hitting the bed
//                         value provided was for the inital test
// BLTouch X offset: 0 - centered behind hotend
// BLTouch Y offset: 38mm - behind hotend (see titan module for titan offsets)
// BLTouch Z offset: you'll have to check this after assembly
// BLTouch retracted size: 42.6mm - as measured on the one I have
// BLTouch extended size: 47.87mm
// The hotend tip must be in the range of the BLTouch to use the plate as coded in here,
// adjust the BLTouch vars as necessary
// The top mounting through hole works for the old MakerGear hotend (which is what I have)
// J-head and the E3dV6 - not tested
// -------------------------------------
belt_adjust = 29;	// belt clamp hole position (increase to move rearward)
//---------------------------------------------------------------------------------------
// following are taken from https://miscsolutions.wordpress.com/mini-height-sensor-board
hole1x = 2.70;
hole1y = 14.92;
hole2x = 21.11;
hole2y = 14.92;
holedia = 2.8;
//---------------------------------------------------------------------------------------
iroffset = 3;		// ir sensor mount hole distance
iroffset2 = 9;	// shift extruder mount holes
irnotch_d = 4;	// depth of notch to clear thru hole components
irmount_height = 25;	// height of the mount
irmount_width = 27;	// width of the mount
irthickness = 6;		// thickness of the mount
irmounty = irmount_height-3; // position of the ir mount holes from end
irreduce = 13.5; // hole in ir mount vertical position
irrecess = -2; // recess in ir mount for pin heater vertical depth
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//all(1,3,3);
partial();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module all(Crg,Ext,Htr) {
	if(Crg == 0) {
		carriage();		// makerslide x-carriage
		translate([0,-90,-4]) belt(); 		// x-carriage belt attachment with the clamps
	}
	if(Crg == 1) {	// rear carriage with belt
		carriagebelt(1);
		translate([-90,0,0]) carriage();		// makerslide x-carriage
	}
	if(Ext == 0)
		translate([65,15,0]) extruder(Htr);	// for BLTouch: 0 = top mounting through hole, 1 - bottom mount in recess
											// 2 - proximity sensor hole in psensord size
											// 3 - dc42's ir sensor
	if(Ext == 1)							// 4 or higher = none
		translate([55,0,0]) rotate([0,0,90]) extruderplatedrillguide();	// drill guide for using an AL plate instead of a printed one
	if(Ext == 2)  // extruder platform for e3d titan with (0,1)BLTouch or (2)Proximity or (3)dc42's ir sensor
		translate([75,25,0]) titan(Htr);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module partial() {
	//carriage();		// makerslide x-carriage
	//extruder(3);	// for BLTouch: 0 = top mounting through hole, 1 - bottom mount in recess
	//belt(); 		// x-carriage belt attachment with the clamps
	//belt_drive();	// x-carriage belt attachment only
	//extruderplatedrillguide();	// drill guide for using an AL plate instead of a printed one
	//wireclamp();
	//carriagebelt(0);
	titan(); // extruder platform for e3d titan with (0,1)BLTouch or (2)Proximity or (3)dc42's ir sensor
	// following not tested:
	//titan2();
	//titan3();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module carriage() { // wheel side
	difference() {
		cubeX([width,height,wall],radius=2,center=true); // makerslide side
		notch_bottom();	// remove space used by extruder plate
		// wheel holes
		hull() { // bevel the countersink to get easier access to adjuster
			translate([0,tri_sep/2,-1]) cylinder(h = depth+10,r = screw_hd/2,$fn=50);
			translate([0,tri_sep/2,10]) cylinder(h = depth,r = screw_hd/2+11,$fn=50);
		}
		translate([0,tri_sep/2,-10]) cylinder(h = depth+10,r = adjuster/2,$fn=50);
		translate([dual_sep/2,-tri_sep/2,-10]) cylinder(h = depth+10,r = screw/2,$fn=50);
		translate([-dual_sep/2,-tri_sep/2,-10]) cylinder(h = depth+10,r = screw/2,$fn=50);
		translate([dual_sep/2,-tri_sep/2,0]) cylinder(h = depth+10,r = screw_hd/2,$fn=50);
		translate([-dual_sep/2,-tri_sep/2,0]) cylinder(h = depth+10,r = screw_hd/2,$fn=50);
		hull() { // side notch
			translate([width/2-9,height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([width/2-9,-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([width/2,height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([width/2,-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
		}
		hull() { // side notch
			translate([-(width/2-9),height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([-(width/2-9),-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([-(width/2),height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([-(width/2),-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
		}
		hull() { // reduce usage of filament
			translate([0,height/8,-wall]) cylinder(h = wall+10, r = 6,$fn=50);
			translate([0,-height/4,-wall]) cylinder(h = wall+10, r = 6,$fn=50);
		}
		// screw holes to mount extruder plate
		translate([0,-20,0]) rotate([90,0,0]) cylinder(h = 25, r = screw2/2, $fn = 50);
		translate([width/2-5,-20,0]) rotate([90,0,0]) cylinder(h = 25, r = screw2/2, $fn = 50);
		translate([-(width/2-5),-20,0]) rotate([90,0,0]) cylinder(h = 25, r = screw2/2, $fn = 50);
		translate([width/4-2,-20,0]) rotate([90,0,0]) cylinder(h = 25, r = screw2/2, $fn = 50);
		translate([-(width/4-2),-20,0]) rotate([90,0,0]) cylinder(h = 25, r = screw2/2, $fn = 50);
		// screw holes in top (alternate location for a belt holder)
		translate([width/4-5,height/2+2,0]) rotate([90,0,0]) cylinder(h = 25, r = screw2/2, $fn = 50);
		translate([-(width/4-5),height/2+2,0]) rotate([90,0,0]) cylinder(h = 25, r = screw2/2, $fn = 50);
		i3mount(); // mounting holes for a Prusa i3 style extruder
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module servo()
{		// mounting holes
		translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module fan()
{		// mounting holes
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([extruder/2-10,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([extruder/2-10,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);

		//translate([-extruder/2,-heightE/2 - 1.8*wall+2,heightE - extruder_back]) // metal extruder cooling fan mount
			//rotate([0,0,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50); // one screw hole in front
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module extruder(recess=0) // bolt-on extruder platform, works for either makerslide or lm8uu versions
{
	difference() {
		cubeX([widthE,heightE,wall],radius=2,center=true); // extruder side
		if(recess == 2) {
			translate([0,-height/3-6,0]) { // extruder notch
				minkowski() {
					cube([25,60,wall+5],true);
					cylinder(h = 1,r = 5,$fn=50);
				}
			}
		} else {
			translate([0,-height/3,0]) { // extruder notch
				minkowski() {
					cube([25,60,wall+5],true);
					cylinder(h = 1,r = 5,$fn=50);
				}
			}
		}
		// screw holes to mount extruder plate
		translate([0,30-wall/2,-10]) cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([width/2-5,30-wall/2,-10]) cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([-(width/2-5),30-wall/2,-10]) cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([width/4-2,30-wall/2,-10]) cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([-(width/4-2),30-wall/2,-10]) cylinder(h = 25, r = screw3/2, $fn = 50);
		// extruder mounting holes
		hull() {
			translate([extruder/2+2,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2,$fn=50);
			translate([extruder/2-4,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2,$fn=50);
		}
		hull() {
			translate([-extruder/2+4,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2,$fn=50);
			translate([-extruder/2-2,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2,$fn=50);
		}
		translate([0,28,41+wall/2]) rotate([90,0,0]) servo();
		translate([0,26,41+wall/2]) rotate([90,0,0]) fan();
		// BLTouch mounting holes
		if(recess == 1) {	// dependent on the hotend, for mounting under the extruder plate
			translate([-bltl/2+3,bltw/2+3,bltdepth]) minkowski() { // depression for BLTouch
				// it needs to be deep enough for the retracted pin not to touch bed
				cube([bltl-6,bltw-6,wall]);
				cylinder(h=1,r=3,$fn=100);
			}
			translate([-bltl/2+8,bltw/2,-5]) cube([bltd,bltd+1,wall+3]); // hole for BLTouch
			translate([bltouch/2,16,-10]) cylinder(h=25,r=screw2/2,$fn=100);
			translate([-bltouch/2,16,-10]) cylinder(h=25,r=screw2/2,$fn=100);
		}
		if(recess == 0) {	// for mounting on top of the extruder plate
			translate([-bltl/2+8,bltw/2,-5]) cube([bltd,bltd+1,wall+3]); // hole for BLTouch
			translate([bltouch/2,16,-10]) cylinder(h=25,r=screw2/2,$fn=100);
			translate([-bltouch/2,16,-10]) cylinder(h=25,r=screw2/2,$fn=100);
		}
		if(recess == 2) { // proximity sensor
			translate([0,10,-6]) cylinder(h=wall*2,r=psensord/2,$fn=50);
		}
	}
	if(recess == 3) { // dc42's ir sensor mount
		translate([irmount_width/2,5,0]) rotate([90,0,180]) iradapter();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module notch_bottom()
{
	translate([0,-height/2,-0.5]) cube([width+1,wall,wall+2], true);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_drive()	// corexy
{
	difference() {	// base
		translate([-3,-0,0]) cubeX([47,40,wall],2);
		hull() {	// nut slot
			translate([-4,belt_adjust,8]) rotate([0,90,0]) nut(m3_nut_diameter,14); // make room for nut
			translate([-4,belt_adjust,4]) rotate([0,90,0]) nut(m3_nut_diameter,14); // make room for nut
		}
		hull() {	// nut slot
			translate([31,belt_adjust,8]) rotate([0,90,0]) nut(m3_nut_diameter,14);
			translate([31,belt_adjust,4]) rotate([0,90,0]) nut(m3_nut_diameter,14);
		}
		// mounting screw holes
		translate([6,wall/2,-1]) rotate([0,0,0]) cylinder(h = 15, r = screw3/2, $fn = 50);
		translate([6+(width/4+8.5),wall/2,-1]) rotate([0,0,0]) cylinder(h = 15, r = screw3/2, $fn = 50);
		hull() {
			translate([21,16,-5]) cylinder(h= 20, r = 8,$fn=50); // access to the top screw
			translate([21,25,-5]) cylinder(h= 20, r = 8,$fn=50);
		}
		translate([4,13,-5]) cylinder(h= 20, r = screw5t/2,$fn=50); // mounting holes for an endstop holder
		translate([4,33,-5]) cylinder(h= 20, r = screw5t/2,$fn=50);
		translate([37,13,-5]) cylinder(h= 20, r = screw5t/2,$fn=50);
		translate([37,33,-5]) cylinder(h= 20, r = screw5t/2,$fn=50);
	}
	difference() {	// right wall
		translate([-wall/2-1,0,0]) cubeX([wall-2,40,29],2);
		translate([-wall/2-2,belt_adjust,27]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-wall/2-2,belt_adjust,4]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-0.5,belt_adjust,27]) rotate([0,90,0]) nut(m3_nut_diameter,3);
		translate([-0.5,belt_adjust,4]) rotate([0,90,0]) nut(m3_nut_diameter,3);
	}
	beltbump(0);
	difference() {	// left wall
		translate([36+wall/2,0,0]) cubeX([wall-2,40,29],2);
		translate([32,belt_adjust,4]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([32,belt_adjust,27]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([38.5,belt_adjust,4]) rotate([0,90,0]) nut(m3_nut_diameter,3);
		translate([32,belt_adjust,27]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([38.5,belt_adjust,27]) rotate([0,90,0]) nut(m3_nut_diameter,3);
	}
	difference() {	// rear wall - adds support to walls holding the belts
		translate([-wall/2+1,42-wall,0]) cubeX([47,wall-2,belt_adjust],2);
		translate([4,33,-5]) cylinder(h= 25, r = screw5/2,$fn=50);	// clearance for endstop screws
		translate([37,33,-5]) cylinder(h= 25, r = screw5/2,$fn=50);
	}
	beltbump(1);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module beltbump(Bump) { // add a little plastic at the belt clamp screw holes at the edge
	if(Bump) {
		difference() {	
			translate([40,belt_adjust,27]) rotate([0,90,0]) cylinder(h = wall-2, r = screw3+0.5,$fn=50);
			translate([32,belt_adjust,27]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([38.5,belt_adjust,27]) rotate([0,90,0]) nut(m3_nut_diameter,3);
		}
	} else {
		difference() {	
			translate([-wall/2-1,belt_adjust,27]) rotate([0,90,0]) cylinder(h = wall-2, r = screw3+0.5,$fn=50);
			translate([-wall/2-2,belt_adjust,27]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([-0.5,belt_adjust,27]) rotate([0,90,0]) nut(m3_nut_diameter,3);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt() // belt mount plate or if MkrSld: top plate
{
	belt_drive();
	translate([52,0,3.5]) belt_roundclamp();
	translate([60,0,-0.5]) belt_adjuster();
	translate([75,0,4]) belt_anvil();
	translate([52,35,3.5]) belt_roundclamp();
	translate([60,35,-0.5]) belt_adjuster();
	translate([75,35,4]) belt_anvil();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_adjuster()
{
	difference() {
		minkowski() {
			translate([0,0,-wall/2+4.5]) cube([8,30,9]);
			cylinder(h = 1,r = 1,$fn=50);
		}
		translate([-1.5,5.5,9]) cube([11,7,3.5]);
		translate([-1.5,16.5,9]) cube([11,7,3.5]);
		translate([4,3,-5]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([4,26,-5]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-5,9,4.5]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-2,9,4.5]) rotate([0,90,0]) nut(m3_nut_diameter,3);
		translate([-5,20,4.5]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([7,20,4.5]) rotate([0,90,0]) nut(m3_nut_diameter,3);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_anvil()
{
	translate([0,0,-3]) rotate([0,0,90]) difference() {
		rotate([0,90,0]) cylinder(h = 9, r = 4, $fn= 100);
		translate([3,0,-6]) cube([15,10,10],true);
		translate([4,0,-3]) cylinder(h = 5, r = screw3/2,$fn = 50);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_roundclamp() // something round to let the belt smoothly move over when using the tensioner screw
{
	rotate([0,90,90]) difference() {
		cylinder(h = 30, r = 4, $fn= 100);
		translate([-6,0,3]) rotate([0,90,0])cylinder(h = 15, r = screw3/2,$fn = 50);
		translate([-6,0,26]) rotate([0,90,0])cylinder(h = 15, r = screw3/2,$fn = 50);
		translate([4.5,0,8]) cube([2,8,45],true); // flatten the top & bottom
		translate([-4.5,0,8]) cube([2,8,45],true);
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module i3mount() { // four mounting holes for using a Prusa i3 style extruder
	// lower
	translate([i3x_sep/2,-height/4 + i3x_ht,-5]) cylinder(h = wall+10, r = screw4/2,$fn = 50);
	//translate([i3x_sep/2,-height/4 + i3x_ht,2]) nut(m3_nut_diameter,3);
	translate([-i3x_sep/2,-height/4+ i3x_ht,-5]) cylinder(h = wall+10, r = screw4/2,$fn = 50);
	//translate([-i3x_sep/2,-height/4+ i3x_ht,2]) nut(m3_nut_diameter,3);
	// upper
	translate([i3x_sep/2,-height/4 + i3x_ht + i3x_sep,-5]) cylinder(h = wall+10, r = screw4/2,$fn = 50);
	//translate([i3x_sep/2,-height/4 + i3x_ht + i3x_sep,2]) nut(m3_nut_diameter,3);
	translate([-i3x_sep/2,-height/4+ i3x_ht + i3x_sep,-5]) cylinder(h = wall+10, r = screw4/2,$fn = 50);
	//translate([-i3x_sep/2,-height/4+ i3x_ht + i3x_sep,2]) nut(m3_nut_diameter,3);
}

////////////////////////////////////////////////////////////////////

module extruderplatedrillguide() { // for drilling 1/8" 6061 in place of a printed extruder plate
	// Use the printed extruder plate as a guide to making an aluminum version
	difference() {
		cube([width,wall,wall],true); // makerslide side
		// screw holes to mount extruder plate
		translate([0,10,0]) rotate([90,0,0]) cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([width/2-5,10,0]) rotate([90,0,0]) cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([-(width/2-5),10,0]) rotate([90,0,0]) cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([width/4-2,10,0]) rotate([90,0,0]) cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([-(width/4-2),10,0]) rotate([90,0,0]) cylinder(h = 25, r = screw3/2, $fn = 50);
	}
}

/////////////////////////////////////////////////////////////////////////////

module wireclamp() {  // uses screws holding the extruder plate, this is current not used
	difference() {
		translate([8.5,0,0]) cube([25,wall,wall-2],true); // makerslide side
		translate([0,10,0]) rotate([90,0,0]) cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([width/4-2,10,0]) rotate([90,0,0]) cylinder(h = 25, r = screw3/2, $fn = 50);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module iradapter(Top) {  // ir sensor bracket stuff is from irsensorbracket.scad
	difference() {
		cubeX([irmount_width,irmount_height,irthickness],2); // mount base
		reduce();
		block_mount();
		recess();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module recess() { // make space for the thru hole pin header
	translate([hole1x+3,hole1y+irrecess+(irmount_height/4),irnotch_d]) cube([15.5,10,5]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module reduce() { // reduce plastic usage and gives somewhere for air to go if using an all-metal hotend w/fan
	translate([13.5,irmount_height-irreduce,-1]) cylinder(h=10,r = irmount_width/4);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module block_mount() // mounting screw holes for the ir sensor
{
	//mounting screw holes
	translate([hole1x+iroffset-1.5,irmounty,-5]) rotate([0,0,0]) cylinder(h=20,r=screw3t/2,$fn=50);
	translate([hole2x+iroffset-1.5,irmounty,-5]) rotate([0,0,0]) cylinder(h=20,r=screw3t/2,$fn=50);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module carriagebelt(Clamps=0) {
	rotate([0,180,0]) {
		difference() { // back side carriage
			translate([0,3,0]) cubeX([width,height+3,wall],radius=2,center=true); // makerslide side
			// wheel holes
			translate([0,tri_sep/2,-1]) cylinder(h = depth+10,r = screw_hd/2,$fn=50);
			translate([0,tri_sep/2,-10]) cylinder(h = depth+10,r = adjuster/2,$fn=50);
			translate([dual_sep/2,-tri_sep/2,-10]) cylinder(h = depth+10,r = screw/2,$fn=50);
			translate([-dual_sep/2,-tri_sep/2,-10]) cylinder(h = depth+10,r = screw/2,$fn=50);
			translate([dual_sep/2,-tri_sep/2,0]) cylinder(h = depth+10,r = screw_hd/2,$fn=50);
			translate([-dual_sep/2,-tri_sep/2,0]) cylinder(h = depth+10,r = screw_hd/2,$fn=50);
			hull() { // side notch
				translate([width/2-6,height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
				translate([width/2-6,-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
				translate([width/2,height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
				translate([width/2,-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			}
			hull() { // side notch
				translate([-(width/2-6),height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
				translate([-(width/2-6),-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
				translate([-(width/2),height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
				translate([-(width/2),-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			}
			hull() { // reduce usage of filament
				translate([0,height/8,-wall]) cylinder(h = wall+10, r = 6,$fn=50);
				translate([0,-height/4,-wall]) cylinder(h = wall+10, r = 6,$fn=50);
			}
		}
		// hole supports
		translate([0,tri_sep/2,-1]) cylinder(h = layer,r = screw_hd/2,$fn=50);
		translate([dual_sep/2,-tri_sep/2,0]) cylinder(h = layer,r = screw_hd/2,$fn=50);
		translate([-dual_sep/2,-tri_sep/2,0]) cylinder(h = layer,r = screw_hd/2,$fn=50);
	}
	difference() {
		translate([20.5,53,36]) rotate([90,180,0]) belt_drive2();	// x-carriage belt attachment only
		translate([0,tri_sep/2,-10]) cylinder(h = depth+10,r = adjuster/2,$fn=50);
			rotate([0,180,0]) translate([0,tri_sep/2,-1]) cylinder(h = depth+10,r = screw_hd/2,$fn=50);
	}
	if(Clamps) belt2();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_drive2()	// corexy
{
	difference() {	// base
		translate([-3,-10,0]) cubeX([47,50,wall],2);
		hull() {	// nut slot
			translate([-4,belt_adjust-10,8]) rotate([0,90,0]) nut(m3_nut_diameter,14); // make room for nut
			translate([-4,belt_adjust-10,4]) rotate([0,90,0]) nut(m3_nut_diameter,14); // make room for nut
		}
		hull() {	// nut slot
			translate([31,belt_adjust-10,8]) rotate([0,90,0]) nut(m3_nut_diameter,14);
			translate([31,belt_adjust-10,4]) rotate([0,90,0]) nut(m3_nut_diameter,14);
		}
		// mounting screw holes
		translate([7,wall/2-10,-1]) rotate([0,0,0]) cylinder(h = 15, r = screw3/2, $fn = 50);
		translate([7+(width/4+8.5),wall/2-10,-1]) rotate([0,0,0]) cylinder(h = 15, r = screw3/2, $fn = 50);
		hull() {
			translate([21,6,-5]) cylinder(h= 20, r = 8,$fn=50); // access to the top screw
			translate([21,23,-5]) cylinder(h= 20, r = 8,$fn=50);
		}
		translate([4,5,-5]) cylinder(h= 20, r = screw5t/2,$fn=50); // mounting holes for an endstop holder
		translate([4,25,-5]) cylinder(h= 20, r = screw5t/2,$fn=50);
		translate([37,5,-5]) cylinder(h= 20, r = screw5t/2,$fn=50);
		translate([37,25,-5]) cylinder(h= 20, r = screw5t/2,$fn=50);
	}
	difference() {	// right wall
		translate([-wall/2-1,-10,0]) cubeX([wall-2,50,29],2);
		translate([-wall/2-2,belt_adjust-10,27]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-wall/2-2,belt_adjust-10,4]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-0.5,belt_adjust-10,27]) rotate([0,90,0]) nut(m3_nut_diameter,3);
		translate([-0.5,belt_adjust-10,4]) rotate([0,90,0]) nut(m3_nut_diameter,3);
	}
	beltbump2(0);
	difference() {	// left wall
		translate([36+wall/2,-10,0]) cubeX([wall-2,50,29],2);
		translate([32,belt_adjust-10,4]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([32,belt_adjust-10,27]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([38.5,belt_adjust-10,4]) rotate([0,90,0]) nut(m3_nut_diameter,3);
		translate([32,belt_adjust-10,27]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([38.5,belt_adjust-10,27]) rotate([0,90,0]) nut(m3_nut_diameter,3);
	}
	beltbump2(1);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt2() // belt mount plate or if MkrSld: top plate
{
	translate([-35,-10,-0.5]) belt_roundclamp();
	translate([-50,-10,-4.5]) belt_adjuster();
	translate([-45,-40,0]) belt_anvil();
	translate([-35,25,-0.5]) belt_roundclamp();
	translate([-50,25,-4.5]) belt_adjuster();
	translate([-45,-25,0]) belt_anvil();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module beltbump2(Bump) { // add a little plastic at the belt clamp screw holes at the edge
	if(Bump) {
		difference() {	
			translate([40,belt_adjust-10,27]) rotate([0,90,0]) cylinder(h = wall-2, r = screw3+1,$fn=50);
			translate([32,belt_adjust-10,27]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([38.5,belt_adjust-10,27]) rotate([0,90,0]) nut(m3_nut_diameter,3);
		}
	} else {
		difference() {	
			translate([-wall/2-1,belt_adjust-10,27]) rotate([0,90,0]) cylinder(h = wall-2, r = screw3+1,$fn=50);
			translate([-wall/2-2,belt_adjust-10,27]) rotate([0,90,0]) cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([-0.5,belt_adjust-10,27]) rotate([0,90,0]) nut(m3_nut_diameter,3);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

e3dv6 = 35;			// hole for e3dv6
shifttitanup = 0;	// move motor up/down
shifthotend = 0;	// move hotend opening front/rear
shifthotend2 = 2;	// move hotend opening left/right
spacing = 17; 		// ir sensor bracket mount hole spacing
shiftir = -20;	// shift ir sensor bracket mount holes

module titan(recess=3) { // extruder platform for e3d titan with (0,1)BLTouch or (2)Proximity or (3)dc42's ir sensor
	difference() {		 // ir sensor is relative -28y; BLTouch +20y, Proximity +6y (going by translates)
		translate([0,-5.5,0]) cubeX([widthE,heightE+11,wall],radius=2,center=true); // extruder side
		extmount();
		hull() {	// hole for e3dv6, shifted to front by 11mm
			translate([-17.5+shifthotend2,-16+shifthotend,-10]) cylinder(h=20,d=e3dv6,$fn=100);
			translate([-35+shifthotend2,-16+shifthotend,-10]) cylinder(h=20,d=e3dv6);
		}
		translate([20,-5,-10]) cylinder(h=20,d=20,$fn=100); // remove some plastic under the motor
		translate([0,16,44]) rotate([90,0,0]) sidemounts();
		if(recess == 0) translate([-16,-4,0]) blt(1); // BLTouch mount
		if(recess == 1) translate([-16,-4,0]) blt(0); // BLTouch mount in a recess
		if(recess == 2) translate([-16,10,-6]) cylinder(h=wall*2,r=psensord/2,$fn=50); // proximity sensor
		if(recess == 3) ir_mount(); // mounting holes for irsensor bracket
	}
	translate([0,-30,0]) rotate([90,0,90]) titanmotor();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titan2() { // extruder platform for e3d titan to mount on a AL extruder plate
	difference() {
		translate([0,0,0]) cubeX([40,53,5],2); // extruder side
		translate([20,28,-10]) cylinder(h=20,d=20,$fn=100); // remove some plastic under the motor
		translate([10,10,-1]) cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
		translate([30,10,-1]) cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
		translate([10,45,-1]) cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
		translate([30,45,-1]) cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
	}
	translate([0,1,0]) rotate([90,0,90]) titanmotor();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titan3() { // extruder platform for e3d titan to mount directly on the x-carraige
	difference() {
		translate([0,0,0]) cubeX([40,56,5],2); // extruder side
		translate([20,28,-10]) cylinder(h=20,d=20,$fn=100); // remove some plastic under the motor
	}
	translate([0,1,0]) rotate([90,0,90]) titanmotor(3);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
module extmount() {		// screw holes to mount extruder plate
	translate([0,30-wall/2,-10]) cylinder(h = 25, r = screw3/2, $fn = 50);
	translate([width/2-5,30-wall/2,-10]) cylinder(h = 25, r = screw3/2, $fn = 50);
	translate([-(width/2-5),30-wall/2,-10]) cylinder(h = 25, r = screw3/2, $fn = 50);
	translate([width/4-2,30-wall/2,-10]) cylinder(h = 25, r = screw3/2, $fn = 50);
	translate([-(width/4-2),30-wall/2,-10]) cylinder(h = 25, r = screw3/2, $fn = 50);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module blt(Ver=0) { // BLTouch mounts
	if(Ver == 0) {
		translate([-bltl/2+3,bltw/2+3,bltdepth]) minkowski() { // depression for BLTouch
			// it needs to be deep enough for the retracted pin not to touch bed
			cube([bltl-6,bltw-6,wall]);
			cylinder(h=1,r=3,$fn=100);
		}
		translate([-bltl/2+8,bltw/2,-5]) cube([bltd,bltd+1,wall+3]); // hole for BLTouch
		translate([bltouch/2,16,-10]) cylinder(h=25,r=screw2/2,$fn=100);
		translate([-bltouch/2,16,-10]) cylinder(h=25,r=screw2/2,$fn=100);
	}
	if(Ver == 1) {
		translate([-bltl/2+8,bltw/2,-5]) cube([bltd,bltd+1,wall+3]); // hole for BLTouch
		translate([bltouch/2,16,-10]) cylinder(h=25,r=screw2/2,$fn=100);
		translate([-bltouch/2,16,-10]) cylinder(h=25,r=screw2/2,$fn=100);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titanmotor(WallMount) {
	difference() {	// motor mounting holes
		if(WallMount) {
			translate([-1,0,0]) cubeX([57,50,5],2);
		} else {
			translate([-1,0,0]) cubeX([54,50,5],2);
		}
		translate([25,25+shifttitanup,-1]) rotate([0,0,45])  NEMA17_x_holes(8, 2);
	}
	difference() { // front support
		translate([-1,0,0]) cubeX([4,50,50],2);
		translate([-3,50,4]) rotate([56,0,0]) cube([7,50,70]);
		translate([-4,-4,36]) cube([wall,wall,wall]);
	}
	if(WallMount) {
		difference() { // rear support
			translate([52,0,0]) cubeX([4,50,40],2);
			translate([40,15,15]) rotate([0,90,0]) cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
			translate([40,15+i3x_sep,15]) rotate([0,90,0])  cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
		}
	} else {
		difference() { // rear support
			translate([49,0,0]) cubeX([4,50,50],2);
			translate([47,50,4]) rotate([56,0,0]) cube([7,50,70]);
			translate([47,-4,36]) cube([wall,wall,wall]);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module sidemounts() {	// mounting holes (copied from fan() & servo() modules
	translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
	translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
	translate([extruder/2-10,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
	translate([extruder/2-10,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
	translate([-extruder/2-25,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset]) // l-r
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
//
	translate([-extruder/2-25,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
	translate([-extruder/2-25,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
//
	translate([-extruder/2-25,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset]) // l-f
		rotate([0,90,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ir_mount() // ir screw holes for mounting to extruder plate
{
	translate([spacing+shiftir+shifthotend,-25,0]) rotate([90,0,0]) cylinder(h=20,r=screw3t/2,$fn=50);
	translate([shiftir+shifthotend,-25,0]) rotate([90,0,0]) cylinder(h=20,r=screw3t/2,$fn=50);
}

///////////////////end of x-carriage.scad////////////////////////////////////////////////////////////////////////////
