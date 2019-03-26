///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CoreXY-X-Carriage - x carriage for makerslide
// created: 2/3/2014
// last modified: 3/9/2019
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/12/16 - added bevel on rear carriage for x-stop switch to ride up on
// 1/21/16 - added Prusa i3 style extruder mount to carriage and put it into a seperate module
// 3/6/16  - added BLTouch mounting holes, sized for the tap for 3mm screws (centered behind hotend)
// 5/24/16 - adjusted carriage for i3(30mm) style mount by making it a bit wider
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
// 10/25/16 - added Titan mount for AL extruder plate and for mounting right on x-carraige using mount_seperation
// 11/29/16 - made titanmotor expand up/down with shiftitanup variable
// 12/18/16 - on the titan extruder plate, the titan was shifted towards the hotend side by 20mm to make the
//			  adjusting screw easier to get to.  Also, began adding color to parts for easier editing.
// 12/22/16 - changed z probe mounts and mounting for TitanExtruderPlatform() extruder plate
// 12/23/16 - cleaned up some code and fixed the screw hole sizes in prox_adapter() & iradapter()
// 12/27/16 - fixed fan mount screw holes on TitanExtruderPlatform()
// 1/8/17	- changed side mounting holes of titan3(), shifted up to allow access to lower mouting holes when
//			  assembled
// 1/9/17	- made TitanExtruderPlatform() able to be used as the titan bowden mount
// 7/9/18	- added a rounded bevel around the hotend clearance hole to the titan mount using corner-tools.scad
//			  and fixed the rear support to be rounded in TitanExtruderPlatform() and removed some unecessary code
//			  added rounded hole under motor to titan3() and fixed mounting holes
// 7/12/18	- Noticed the plate was not setup for a 200x200 bed
// 8/19/18	- Dual Titabnmount is in DualTitan.scad, OpenSCAD 2018.06.01 for $preview, which is used to make sure
//			  a 200x200 bed can print multiple parts.
// 8/20/18	- Added a carridge and belt only for DualTitan.scad, redid the modules for the other setups
// 12/8/18	- Changed belt clamp from adjusting type to solid (stepper motors are adjustable)
//			  Added preview color to belt modules
//			  Added x-carriage belt drive loop style
// 12/10/18	- Edited carriage() and carriagebelt() to not use center=true for the cubeX[]
// 1/26/19	- Edited BLTouchMount() to use cubeX() for recess hole and have mounting holes defined in BLTouchMount() at fan spacing
//			  Removed servo mounting holes
//			  Added one piece titan direct mount on x carriage
// 1/31/18	- Fixed/added a few mounting holes
//			  Adjusted fan adapter position on TitanExtruderPlatform()
//			  Changed titan2() name to TitanExtruderBowdenMount()
//			  Removed titan3()
//			  Ziptie hole on BLTouchMount()
// 2/12/19	- Moved BeltHolder.scad into here.  Renamed BeltHolder.scad height to LoopHeight.
// 2/21/19	- Fixed bevel hole access to adjuster on carraige plate in carriagebelt()
// 2/23/19	- Combined carriagebelt() into carriage(), bug fixes, removed unused modules, renamed modules for a better
//			  description of what they do
// 3/9/19	- Added a m3 nut holder on the titanextrudermount() at the end since tapping that hole may not be strong enough
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
// Belt clamp style: Assemble both belt clamps before mounting on x-carriage, leave loose enough to install belts
// The four holes on top are for mounting an endstopMS.scad holder, tap them with a 5mm tap.
// ---------------------------------------------------------
// For the loop belt style: tap holes for 3mm and mount two belt holders, it's in belt_holder.scad
//----------------------------------------------------------
// If the extruder plate is used with an 18mm proximity sensor, don't install the center mounting screw, it gets
// in the way of the washer & nut.
//-----------------------------------------------------------
// Changed to using a front & rear carriage plate with the belt holder as part of it.  The single carriage plate
// wasn't solid enough, the top started to bend, loosening the hold the wheels had on the makerslide
//-----------------------------------------------------------
// To use rear carriage belt in place of the belt holder, you need three M5x50mm, three 7/8" nylon M5 spacers along
// with the three makerslide wheels, three M5 washers, three M5 nuts, two M3x16mm screws
//-----------------------------------------------------------
// IR sensor bracket is in irsensorbracket.scad
//-----------------------------------------------------------
// corner-tools.scad fillet_r() doesn't show in preview
//////////////////////////////////////////////////////////////////////////////////////////////////////////
include <CoreXY-MSv1-h.scad>
use <ybeltclamp.scad>	// modified https://www.thingiverse.com/thing:863408
$fn=75;
TestLoop=0; // 1 = have original belt clamp mount hole visible
LoopHoleOffset=28;	// distance between the belt lopp mounting holes (same as in belt_holder.scad)
LoopHOffset=0;		// shift horizontal the belt loop mounting holes
LoopVOffset=-2;		// shift vertical the belt loop mounting holes
LoopHeight = 20;
MountThickness=5;
//---------------------------------------------------------------------------------------------------------------
e3dv6 = 36.5;		// hole for e3dv6 with fan holder
shifttitanup = 2.5;	// move motor +up/-down
shifthotend = 0;	// move hotend opening front/rear
shifthotend2 = -20;	// move hotend opening left/right
spacing = 17; 		// ir sensor bracket mount hole spacing
shiftir = -20;	// shift ir sensor bracket mount holes
shiftblt = 10;	// shift bltouch up/down
shiftprox = 5;	// shift proximity sensor up/down
//-----------------------------------------------------------------------------------------
// info from irsensorbracket.scad
//-----------------------------------
hotend_length = 50; // 50 for E3DV6
board_overlap = 2.5; // amount ir borad overlap sensor bracket
irboard_length = 17 - board_overlap; // length of ir board less the overlap on the bracket
ir_gap = 0;		// adjust edge of board up/down
//-----------------------------------------------------------------------------------------
ir_height = (hotend_length - irboard_length - ir_gap) - irmount_height;	// height of the mount
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

partial();
//FrontCarridge(0,1,1);	// 1st:0-no clamps,1-clamps;2nd:clamps style,2-belt loop style
//RearCarridge(0,0);	// 1st:0-no clamps,1-clamps;2nd:clamps style,2-belt loop style
//ExtruderPlateMount(0,2); 	// 1st arg: 0 - old style hotend mount, 1 - drill guide for old style, 2 - titan/e3dv6 mount
							//			3 - combo of 2 and x-carriage
							// 2nd arg: 0 | 1 bltouch, 2 - round proxmity, 3 - dc42's ir sensor
TitanCarriage(0,0); // 1st arg: 1-one piece titan/e3dv6 on x-carriage + belt drive holder
					// 2ng arg: 0 - bltouch thru hole mount; 1 - bltouch surface mount; 2 - proximity sensor hole in psensord size
							 // 3 - dc42's ir sensor; 4 - all; 5 - none (default)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FrontCarridge(Clamps=1,Loop=0,Titan=0) {
	if($preview) %translate([-70,-50,-1]) cube([200,200,1]);
	translate([-40,0,0]) Carriage(Titan,0,Clamps,Loop,1,1,2);
							// Titan,Tshift,Clamps,Loop,DoBeltDrive
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RearCarridge(Clamps=0,Loop=0) {
	if($preview) %translate([-10,-70,-1]) cube([200,200,1]);
	translate([150,100,0]) rotate([0,0,180]) Carriage(0,1,Clamps,Loop,0); // rear x-carriage plate
										// Titan,Tshift,Clamps,Loop,DoBeltDrive
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module ExtruderPlateMount(Extruder=0,Sensor=0) {
	//if($preview) %translate([-100,-100,-5]) cube([200,200,1]);
	if(Extruder == 0)
		ExtruderPlatform(Sensor);	// for BLTouch: 0 = top mounting through hole, 1 - bottom mount in recess
							// 2 - proximity sensor hole in psensord size
							// 3 - dc42's ir sensor
	if(Extruder == 1) {			// 4 or higher = none
		// drill guide for using an AL plate instead of a printed one
		rotate([0,0,90]) ExtruderPlateDriilGuide();
	}
	if(Extruder == 2) // titan/e3dv6 combo
		translate([5,5,0]) rotate([0,0,-90]) TitanExtruderPlatform(Sensor,1,1);
	if(Extruder == 3)
		TitanCarriage();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module partial() {
	//if($preview) %translate([-100,-100,-1]) cube([200,200,1]); // parts may not be on the preview plate
	//Carriage(1,0,0,1,0,0,0);	// x-carriage, 1st arg: Titan mount; 2nd arg:Shift Titan mount;
					// 3rd arg: belt clamps; 4th arg: Loop style belt holders
					// 5:arg DoBeltDrive if 1; 6th arg: Rear carriage plate if 1; 7th arg: 1 or 2 Moves the Belt loops
					// defaults: Titan=0,Tshift=0,Clamps=0,Loop=0,DoBeltDrive=1,Rear=0,MoveBeltLoops=0
	//ExtruderPlatform(0);	// for BLTouch: 0 & 1, 2 is proximity, 3 is dc42 ir sensor, 4- none
	//translate([-50,0,0]) CarriageBeltDrive(1);	// 1 - belt loop style
	//ExtruderPlateDriilGuide();	// drill guide for using an AL plate instead of a printed one
	//wireclamp();
	//TitanExtruderPlatform(5,1,1);	// 1st arg: extruder platform for e3d titan with (0,1)BLTouch or (2)Proximity or (3)dc42's ir sensor
					// 4 - all sensor brackets; 5 - no sensor brackets
					// 2nd arg: InnerSupport ; 3rd arg: Mounting Holes
	//TitanCarriage(); // one piece titan/e3dv6 on x-carriage + belt drive holder
	//TitanExtruderBowdenMount(); // right angle titan mount to 2020 for bowden
	//TitanMotorMount(0);
	//ProximityMount(shiftprox);
	//BLTouchMount(0,shiftblt);
	//BLTouchMount(0); // makes hole for bltouch mount
	//translate([0,0,0]) BeltLoopHolder();
	//translate([30,0,0]) BeltLoopHolder();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanCarriage(One=0,Sensor=5) {
	if($preview) %translate([-80,-20,-1]) cube([200,200,1]);
	difference() {
		Carriage(1,0,0,1,1,0,2);
		if(One) {
			translate([-5,46,0]) {	
				rotate([90,90,90]) FanMountHoles(screw3t); // mounting holes for bltouch & prox sensor
				translate([40,-44.4,95]) rotate([90,0,0]) IRMountHoles(); // mounting holes for irsensor bracket
			}
		}
	}
	if(One) {
		translate([25,2,2]) color("blue") cubeX([5,60+shifttitanup,wall+5],2);
		translate([45,2,31]) rotate([-90,0,0]) // this puts the titan mount on the carriage
			TitanExtruderPlatform(Sensor,0,0);	// extruder platform for e3d titan with
												// (0,1)BLTouch or (2)Proximity or (3)dc42's ir sensor
												// 4 - all sensor brackets; 5 - no sensor brackets
	} else {
		translate([-25,40,wall/2]) TitanExtruderPlatform(Sensor,1,1);
	}
	//translate([60,120,0]) BeltLoopHolder();
	//translate([60,80,0]) BeltLoopHolder();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Carriage(Titan=0,Tshift=0,Clamps=0,Loop=0,DoBeltDrive=1,Rear=0,MoveBeltLoops=0) { // extruder side
	difference() {
		color("cyan") cubeX([width,height,wall],radius=2);
		NotchBottom();	// square bottom for an extruder plate
		// wheel holes
		if(!Rear) { // top wheel hole, if rear, don't bevel it
			translate([width/2,42,0]) color("red") hull() { // bevel the countersink to get easier access to adjuster
				translate([0,tri_sep/2,3]) cylinder(h = depth+10,r = screw_hd/2);
				translate([0,tri_sep/2,10]) cylinder(h = depth,r = screw_hd/2+11);
			}
		} else
			translate([width/2,tri_sep/2+42,3]) color("lightgray") cylinder(h = depth+10,r = screw_hd/2);
		translate([width/2,42,0]) { // wheel holes
			translate([0,tri_sep/2,-10]) color("blue") cylinder(h = depth+10,r = adjuster/2);
			translate([dual_sep/2,-tri_sep/2,-10]) color("yellow") cylinder(h = depth+10,r = screw/2);
			translate([-dual_sep/2,-tri_sep/2,-10]) color("purple") cylinder(h = depth+10,r = screw/2);
			translate([dual_sep/2,-tri_sep/2,3]) color("gray") cylinder(h = depth+10,r = screw_hd/2);
			translate([-dual_sep/2,-tri_sep/2,3]) color("green") cylinder(h = depth+10,r = screw_hd/2);
		}
		translate([38,45,2]) color("red") hull() { // side notch
			translate([width/2-9,height,-5]) cylinder(h = wall+5, r = 10);
			translate([width/2-9,-height/8,-5]) cylinder(h = wall+5, r = 10);
			translate([width/2,height,-5]) cylinder(h = wall+5, r = 10);
			translate([width/2,-height/8,-5]) cylinder(h = wall+5, r = 10);
		}
		translate([38,45,2]) color("black") hull() { // side notch
			translate([-(width/2-9),height,-5]) cylinder(h = wall+5, r = 10);
			translate([-(width/2-9),-height/8,-5]) cylinder(h = wall+5, r = 10);
			translate([-(width/2),height,-5]) cylinder(h = wall+5, r = 10);
			translate([-(width/2),-height/8,-5]) cylinder(h = wall+5, r = 10);
		}
		//if(Titan) translate([20-Tshift,50,-1]) color("yellow") cylinder(h=15,d=20); // Titan thumbwheel notch
		translate([38,37,2]) color("gray") hull() { // reduce usage of filament
			translate([0,height/8,-wall]) cylinder(h = wall+10, r = 6);
			translate([0,-height/4,-wall]) cylinder(h = wall+10, r = 6);
		}
		// screw holes to mount extruder plate
		translate([38,45,4]) {
			ExtruderMountHolesFn(screw3t,6);
			// screw holes in top (alternate location for a belt holder)
			translate([width/4-5,height/2+2,0]) rotate([90,0,0]) color("red") cylinder(h = 25, r = screw3t/2, $fn = 5);
			translate([-(width/4-5),height/2+2,0]) rotate([90,0,0]) color("blue") cylinder(h = 25, r = screw3t/2, $fn = 5);
			if(!Titan) CarridgeMount(); // 4 mounting holes for an extruder
		}
	}
	if(DoBeltDrive) {
		difference() {
			translate([70,30,0]) CarriageBeltDrive(Loop);	// belt attachment to above
			translate([128,3,30]) rotate([0,90,0]) TitanTensionHole();
		}
	}
	BeltClamps(Clamps,Loop);
	if(Loop) {
		if(MoveBeltLoops==1) {
			translate([80,0,0]) BeltLoopHolder();
			translate([15,50,0]) rotate([0,0,180]) BeltLoopHolder();
		} 
		if(MoveBeltLoops==2) {
			translate([60,120,0]) BeltLoopHolder();
			translate([90,100,0]) rotate([0,0,180]) BeltLoopHolder();
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderMountHolesFn(Screw=screw3,Fragments=100) {
	translate([0,-15,0]) rotate([90,0,0]) color("red") cylinder(h = 35, d = Screw, $fn = Fragments);
	translate([width/2-5,-15,0]) rotate([90,0,0]) color("blue") cylinder(h = 35, d = Screw, $fn = Fragments);
	translate([-(width/2-5),-15,0]) rotate([90,0,0]) color("black") cylinder(h = 35, d = Screw, $fn = Fragments);
	translate([width/4-2,-15,0]) rotate([90,0,0]) color("purple") cylinder(h = 35, d = Screw, $fn = Fragments);
	translate([-(width/4-2),-15,0]) rotate([90,0,0]) color("gray") cylinder(h = 35, d = Screw, $fn = Fragments);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanMountHoles(Screw=screw3t,Left=1) {	// fan mounting holes
	if(Left) {
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = 3*(depthE+screw_depth),d = Screw);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = 3*(depthE+screw_depth),d = Screw);
	} else { // one side fan mounting holes
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = depthE+screw_depth,d = Screw);
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = depthE+screw_depth,d = Screw);

	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderPlatform(recess=0) // bolt-on extruder platform
{							// used for extruder mount via a wades extruder style
	difference() {
		color("red") cubeX([widthE,heightE,wall],radius=2,center=true); // extruder side
		if(recess == 2) {
			translate([0,-height/3-6,0]) { // extruder notch
				color("blue") minkowski() {
					cube([25,60,wall+5],true);
					cylinder(h = 1,r = 5);
				}
			}
		} else {
			translate([0,-height/3,0]) { // extruder notch
				color("pink") minkowski() {
					cube([25,60,wall+5],true);
					cylinder(h = 1,r = 5);
				}
			}
		}
		// screw holes to mount extruder plate
		translate([0,30-wall/2,-10]) color("gray") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([width/2-5,30-wall/2,-10]) color("blue") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([-(width/2-5),30-wall/2,-10]) color("pink") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([width/4-2,30-wall/2,-10]) color("black") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([-(width/4-2),30-wall/2,-10]) color("lightblue") cylinder(h = 25, r = screw3/2, $fn = 50);
		// extruder mounting holes
		color("black") hull() {
			translate([extruder/2+2,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2);
			translate([extruder/2-4,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2);
		}
		color("gray") hull() {
			translate([-extruder/2+4,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2);
			translate([-extruder/2-2,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2);
		}
		translate([0,26,41+wall/2]) rotate([90,0,0]) FanMountHoles();
		translate([0,-6,0.6]) rotate([0,0,90]) IRMountHoles(screw3t);
		if(recess != 4) {
			BLTouch_Holes(recess);
			if(recess == 2) { // proximity sensor
				translate([0,10,-6]) color("pink") cylinder(h=wall*2,r=psensord/2);
			}
		}
	}
	if(recess == 3) { // dc42's ir sensor mount
		translate([irmount_width/2,5,0]) rotate([90,0,180]) IRAdapter();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouch_Holes(recess=0) {
				if(recess == 1) {	// dependent on the hotend, for mounting under the extruder plate
				translate([-bltl/2+3,bltw/2+3,bltdepth]) color("cyan") minkowski() { // depression for BLTouch
				// it needs to be deep enough for the retracted pin not to touch bed
				cube([bltl-6,bltw-6,wall]);
				cylinder(h=1,r=3,$fn=100);
			}
			translate([-bltl/2+8,bltw/2,-5]) color("blue") cube([bltd,bltd+1,wall+3]); // hole for BLTouch
			translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,r=screw2/2,$fn=100);
			translate([-bltouch/2,16,-10]) color("black") cylinder(h=25,r=screw2/2,$fn=100);
			}
			if(recess == 0) {	// for mounting on top of the extruder plate
				translate([-bltl/2+8,bltw/2,-5]) color("blue") cube([bltd,bltd+1,wall+3]); // hole for BLTouch
				translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,r=screw2/2,$fn=100);
				translate([-bltouch/2,16,-10]) color("black") cylinder(h=25,r=screw2/2,$fn=100);
			}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NotchBottom()
{
	translate([38,-2,4]) cube([width+1,wall,wall+2], true);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CarriageBeltDrive(Loop=0) {
	difference() {	// base
		translate([-3,-0,0]) color("cyan") cubeX([47,40,wall],2);
		if(!Loop) {
			hull() {	// belt clamp nut access slot
				translate([-4,belt_adjust,8]) rotate([0,90,0]) color("red") nut(m3_nut_diameter,14); // make room for nut
				translate([-4,belt_adjust,4]) rotate([0,90,0]) color("blue") nut(m3_nut_diameter,14); // make room for nut
			}
			color("gray") hull() {	// belt clamp nut access slot
				translate([31,belt_adjust,8]) rotate([0,90,0]) nut(m3_nut_diameter,14);
				translate([31,belt_adjust,4]) rotate([0,90,0]) nut(m3_nut_diameter,14);
			}
		}
		// mounting screw holes to x-carriage plate
		translate([6,wall/2,-1]) rotate([0,0,0]) color("blue") cylinder(h = 15, r = screw3/2, $fn = 50);
		translate([6+(width/4+8.5),wall/2,-1]) rotate([0,0,0]) color("black") cylinder(h = 15, r = screw3/2, $fn = 50);
		color("white") hull() { // plastic reduction
			translate([21,16,-5]) cylinder(h= 20, r = 8);
			translate([21,25,-5]) cylinder(h= 20, r = 8);
		}
		 // mounting holes for an endstop holder
		translate([4,13,-5]) color("khaki") cylinder(h= 20, r = screw5t/2);
		translate([4,33,-5]) color("plum") cylinder(h= 20, r = screw5t/2);
		translate([37,13,-5]) color("gold") cylinder(h= 20, r = screw5t/2);
		translate([37,33,-5]) color("red") cylinder(h= 20, r = screw5t/2);
	}
	difference() {	// right wall
		translate([-wall/2-1,0,0]) color("yellow") cubeX([wall-2,40,29],2);
		if(!Loop) {
			translate([-wall/2-2,belt_adjust,27]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, r = screw3/2);
			translate([-wall/2-2,belt_adjust,4]) rotate([0,90,0]) color("cyan") cylinder(h = 2*wall, r = screw3/2);
			translate([-0.5,belt_adjust,27]) rotate([0,90,0]) color("blue") nut(m3_nut_diameter,3);
			translate([-0.5,belt_adjust,4]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		} else BeltLoopHolderMountingHoles();
		if(TestLoop) // add one of belt clamp holes for adjusting the belt loop holder mounting holes
				translate([-wall/2-2,belt_adjust,4]) rotate([0,90,0]) color("cyan") cylinder(h = 2*wall, r = screw3/2);
	}
	if(!Loop) BeltMountingHoleBump(0);
	difference() {	// left wall
		translate([36+wall/2,0,0]) color("pink") cubeX([wall-2,40,29],2);
		if(!Loop) {
			translate([32,belt_adjust,4]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, r = screw3/2);
			translate([32,belt_adjust,27]) rotate([0,90,0]) color("cyan") cylinder(h = 2*wall, r = screw3/2);
			translate([38.5,belt_adjust,4]) rotate([0,90,0]) color("blue") nut(m3_nut_diameter,3);
			translate([38.5,belt_adjust,27]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		} else {
			BeltLoopHolderMountingHoles();
		}
	}
	difference() {	// rear wall - adds support to walls holding the belts
		translate([-wall/2+1,42-wall,0]) color("gray") cubeX([47,wall-2,belt_adjust],2);
		translate([4,33,-5]) color("blue") cylinder(h= 25, r = screw5/2);	// clearance for endstop screws
		translate([37,33,-5]) color("red") cylinder(h= 25, r = screw5/2);
		if(Loop) BeltLoopHolderMountingHoles();
	}
	if(!Loop) BeltMountingHoleBump(1);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltLoopHolderMountingHoles() { // for beltholder
	// pink side
	translate([35,8+LoopHOffset,17+LoopVOffset]) rotate([0,90,0])
		color("black") cylinder(h = 2*wall, r = screw3t/2);
	translate([35,4+LoopHoleOffset+LoopHOffset,17+LoopVOffset]) rotate([0,90,0])
		color("white") cylinder(h = 2*wall, r = screw3t/2);
	// yellow side
	translate([-10,8+LoopHOffset,17+LoopVOffset]) rotate([0,90,0])
		color("plum") cylinder(h = 2*wall, r = screw3t/2);
	translate([-10,4+LoopHoleOffset+LoopHOffset,17+LoopVOffset]) rotate([0,90,0])
		color("gray") cylinder(h = 2*wall, r = screw3t/2);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltMountingHoleBump(Bump) { // add a little plastic at the belt clamp screw holes at the edge
	if(Bump) {
		difference() {	
			translate([40,belt_adjust,27]) rotate([0,90,0]) color("cyan") cylinder(h = wall-2, r = screw3+0.5);
			translate([32,belt_adjust,27]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, r = screw3/2);
			translate([38.5,belt_adjust,27]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		}
	} else {
		difference() {	
			translate([-wall/2-1,belt_adjust,27]) rotate([0,90,0]) color("cyan") cylinder(h = wall-2, r = screw3+0.5);
			translate([-wall/2-2,belt_adjust,27]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, r = screw3/2);
			translate([-0.5,belt_adjust,27]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltAdjuster() {
	difference() {
		translate([-1,0,0]) color("blue") cubeX([9,30,9],2);
		translate([-1.5,5.5,7]) color("red") cube([11,7,3.5]);
		translate([-1.5,16.5,7]) color("cyan") cube([11,7,3.5]);
		translate([4,3,-5]) color("white") cylinder(h = 2*wall, r = screw3/2);
		translate([4,26,-5]) color("plum") cylinder(h = 2*wall, r = screw3/2);
		translate([-5,9,4.5]) rotate([0,90,0]) color("gray") cylinder(h = 2*wall, r = screw3/2);
		translate([-2,9,4.5]) rotate([0,90,0]) color("black") nut(m3_nut_diameter,3);
		translate([-5,20,4.5]) rotate([0,90,0]) color("khaki") cylinder(h = 2*wall, r = screw3/2);
		translate([7,20,4.5]) rotate([0,90,0]) color("gold") nut(m3_nut_diameter,3);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltAnvil()
{
	translate([0,0,-3]) rotate([0,0,90]) difference() {
		rotate([0,90,0]) cylinder(h = 9, r = 4, $fn= 100);
		translate([3,0,-6]) cube([15,10,10],true);
		translate([4,0,-3]) cylinder(h = 5, r = screw3/2,$fn = 50);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Belt_RoundClamp() { // something round to let the belt smoothly move over when using the tensioner screw
	rotate([0,90,90]) difference() {
		cylinder(h = 30, r = 4, $fn= 100);
		translate([-6,0,3]) rotate([0,90,0])cylinder(h = 15, r = screw3/2,$fn = 50);
		translate([-6,0,26]) rotate([0,90,0])cylinder(h = 15, r = screw3/2,$fn = 50);
		translate([4.5,0,8]) cube([2,8,45],true); // flatten the top & bottom
		translate([-4.5,0,8]) cube([2,8,45],true);
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CarridgeMount() { // four mounting holes for using seperate mounting extruder brcket
	// lower
	translate([mount_seperation/2,-height/4 + mount_height,-5]) color("black") cylinder(h = wall+10, r = screw4/2,$fn = 50);
	translate([-mount_seperation/2,-height/4+ mount_height,-5]) color("blue") cylinder(h = wall+10, r = screw4/2,$fn = 50);
	// upper
	translate([mount_seperation/2,-height/4 + mount_height + mount_seperation,-5]) color("red") cylinder(h = wall+10, r = screw4/2,$fn = 50);
	translate([-mount_seperation/2,-height/4+ mount_height + mount_seperation,-5]) color("plum") cylinder(h = wall+10, r = screw4/2,$fn = 50);
}

////////////////////////////////////////////////////////////////////

module ExtruderPlateDriilGuide() { // for drilling 1/8" 6061 in place of a printed extruder plate
	// Use the printed extruder plate as a guide to making an aluminum version
	difference() {
		color("cyan") cube([width,wall,wall],true);
		// screw holes to mount extruder plate
		translate([0,10,0]) rotate([90,0,0]) color("red") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([width/2-5,10,0]) rotate([90,0,0]) color("blue") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([-(width/2-5),10,0]) rotate([90,0,0]) color("black") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([width/4-2,10,0]) rotate([90,0,0]) color("gray") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([-(width/4-2),10,0]) rotate([90,0,0]) color("yellow") cylinder(h = 25, r = screw3/2, $fn = 50);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRAdapter(Top,Taller=0) {  // ir sensor bracket stuff is from irsensorbracket.scad
	difference() {
		color("plum") cubeX([irmount_width,irmount_height+Taller,irthickness],2); // mount base
		ReduceIR(Taller);
		IRMountingHoles(Taller);
		RecessIR(Taller);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RecessIR(Taller=0) { // make space for the thru hole pin header
	translate([hole1x+3,hole1y+irrecess+(irmount_height/4)+Taller,irnotch_d]) color("cyan") cube([15.5,10,5]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ReduceIR(Taller=0) { // reduce plastic usage and gives somewhere for air to go if using an all-metal hotend w/fan
	translate([13.5,irmount_height-irreduce+Taller/2,-1]) color("teal") cylinder(h=10,r = irmount_width/4);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRMountingHoles(Taller=0) // mounting screw holes for the ir sensor
{
	translate([hole1x+iroffset-1.5,irmounty+Taller,-5]) rotate([0,0,0]) color("black") cylinder(h=20,r=screw3t/2);
	translate([hole2x+iroffset-1.5,irmounty+Taller,-5]) rotate([0,0,0]) color("white") cylinder(h=20,r=screw3t/2);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanTensionHole() {
	color("pink") cylinder(h=10,d=20);
	//color("black") hull() {
	//	translate([0,00,15]) cylinder(h=1,d=3);
	//	translate([0,0,9]) cylinder(h=1,d=20);
	//}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltClamps(Clamps=0,Loop=0) // belt clamps
{
	if(Clamps && !Loop) {
		translate([-35,-10,-0.5]) color("red") Belt_RoundClamp();
		translate([-50,-10,-4.5]) color("blue") BeltAdjuster();
		translate([-45,-40,0]) color("black") BeltAnvil();
		translate([-35,25,-0.5]) color("cyan") Belt_RoundClamp();
		translate([-50,25,-4.5]) color("purple") BeltAdjuster();
		translate([-45,-25,0]) color("gray") BeltAnvil();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanExtruderPlatform(recess=3,InnerSupport=0,MountingHoles=1) { // extruder platform for e3d titan with (0,1)BLTouch or
	difference() {										// (2)Proximity or (3)dc42's ir sensor
		translate([-37.5,-42,-wall/2]) color("cyan") cubeX([widthE+shifthotend2/1.3,heightE+13,wall],2); // extruder side
		if(MountingHoles) ExtruderMountHoles(screw3);
        E3Dv6Hole();
 		 // remove some under the motor
		translate([20+shifthotend2,-5,-10]) color("pink") cylinder(h=20,d=23.5);
	    translate([0,-5,wall/2]) color("purple") fillet_r(2,23/2,-1,$fn);	// round top edge
	    translate([0,-5,-wall/2]) color("purple") rotate([180]) fillet_r(2,23/2,-1,$fn);	// round bottom edge
	    
		translate([-15,20,44]) rotate([90,0,0]) FanMountHoles(screw3t,0); // fan adapeter mounting holes
		translate([-50,0,44.5]) rotate([90,0,90]) FanMountHoles(screw3t); // mounting holes for bltouch & prox sensor
		translate([-10,70,0]) IRMountHoles(screw3t); // mounting holes for irsensor bracket
		translate([-30,-33,0]) rotate([90,0,0]) color("plum") nut(nut3,5);
	}
	difference() {
	if(InnerSupport!=2) 
		translate([shifthotend2,-32,0]) rotate([90,0,90]) TitanMotorMount(0,0,InnerSupport);
	else
		translate([shifthotend2,-32,0]) rotate([90,0,90]) TitanMotorMount(0,0,1);
	
		translate([-50,0,44.5]) rotate([90,0,90]) FanMountHoles(); // mounting holes for bltouch & prox sensor
		translate([-10,0,0]) IRMountHoles(screw3t); // mounting holes for irsensor bracket
	}
	if(recess != 5) {
		if(recess == 0 || recess == 1) translate([-13,40,-wall/2]) BLTouchMount(recess,shiftblt); // BLTouch mount
		if(recess == 2) translate([10,45,0]) ProximityMount(shiftprox); // mount proximity sensor
		if(recess == 3) { // ir mount
			translate([0,33,-wall/2]) difference() {
				IRAdapter(0,ir_height);
				translate([25,4,40]) rotate([90,0,0]) IRMountHoles(screw3t);
			}
		}
		if(recess==4) {
			translate([-50,37,-wall/2]) BLTouchMount(0,shiftblt); // BLTouch mount
			translate([39,55,0]) ProximityMount(shiftprox); // mount proximity sensor
			translate([10,35,-wall/2]) difference() { // ir mount
				IRAdapter(0,ir_height);
				translate([25,4,40]) rotate([90,0,0]) IRMountHoles(screw3t);
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module E3Dv6Hole() {
		// hole for e3dv6, shifted to front by 11mm
		translate([-15.5+shifthotend2,-18+shifthotend,-10]) color("pink") cylinder(h=20,d=e3dv6);
		// round top edge
	    translate([-15.5+shifthotend2,-18+shifthotend,wall/2]) color("purple") fillet_r(2,e3dv6/2,-1,$fn);
		// round bottom edge
	    translate([-15.5+shifthotend2,-18+shifthotend,-wall/2]) rotate([180]) color("purple") fillet_r(2,e3dv6/2,-1,$fn);
}
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ProximityMount(Shift) {
	difference() {
		color("red") cubeX([30,30,5],2);
		translate([15,12,-2]) color("olive") cylinder(h=wall*2,d=psensord); // proximity sensor hole
	}
	difference() {
		translate([-20,26,0]) color("cyan") cubeX([63,5,13+Shift],2);
		translate([-20,0,8]) IRBracketMountHoles(Shift);
		translate([37,35,Shift+8]) rotate([90,0,0]) color("gold") cylinder(h=20,d=screw3+0.5); // a ziptie hole
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouchMount(Type,Shift) {
	difference() {
		translate([15,0,0]) color("salmon") cubeX([40,30,5],2);
		if(Type==0) translate([35,0,bltdepth-2]) BLTouchMountHole(Type); // blt body hole
		if(Type==1) translate([35,0,bltdepth+3]) BLTouchMountHole(Type); // no blt body hole
	}
	difference() {
		translate([-1,26,0]) color("cyan") cubeX([56,5,5+Shift],2);
		BLTouchBracketMountHoles(Shift);
		translate([52,35,Shift]) rotate([90,0,0]) color("gold") cylinder(h=20,d=screw3+0.5); // a ziptie hole
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouchMountHole(Ver=0) { // BLTouch mount
	if(Ver == 0) {
		translate([-bltl/2,bltw/2,bltdepth]) { // hole for BLTouch
			// it needs to be deep enough for the retracted pin not to touch bed
			color("red") cubeX([bltl,bltw,wall],2);
		}
		translate([-bltl/2+8,bltw/2,-5]) color("blue") cube([bltd,bltd+2,wall*2]); // hole for BLTouch
		translate([bltouch/2,16,-10]) color("cyan") cylinder(h=25,r=screw2/2);
		translate([-bltouch/2,16,-10]) color("purple") cylinder(h=25,r=screw2/2);
	} else { // mounting holes only
		translate([bltouch/2,16,-10]) color("cyan") cylinder(h=25,r=screw2/2);
		translate([-bltouch/2,16,-10]) color("purple") cylinder(h=25,r=screw2/2);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouchBracketMountHoles(Shift) {
	translate([4,33,Shift]) color("black") hull() { // free end, slot it bit
		translate([-0.5,0,0]) rotate([90,0,0]) cylinder(h=20,d=screw3);
		translate([0.5,0,0]) rotate([90,0,0]) cylinder(h=20,d=screw3);
	}
	translate([19,35,Shift]) color("plum") rotate([90,0,0]) color("plum") cylinder(h=20,d=screw3); // center
	translate([4+fan_spacing,33,Shift]) rotate([90,0,0]) color("gray") cylinder(h=20,d=screw3); // under bltouch
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRBracketMountHoles(Shift) {
	translate([4,33,Shift]) color("black") rotate([90,0,0]) cylinder(h=20,d=screw3);
	translate([19,35,Shift]) color("plum") rotate([90,0,0]) color("plum") cylinder(h=20,d=screw3); // center
	translate([4+fan_spacing,33,Shift]) rotate([90,0,0]) color("gray") cylinder(h=20,d=screw3);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanExtruderBowdenMount() { // extruder bracket for e3d titan to mount on a AL extruder plate
	difference() {
		translate([0,0,0]) cubeX([40,53,5],2); // extruder side
		translate([20,28,-10]) cylinder(h=20,d=20); // remove some plastic under the motor
		translate([10,10,-1]) cylinder(h=20,d=screw4); // mounting screw hole
		translate([30,10,-1]) cylinder(h=20,d=screw4); // mounting screw hole
		translate([10,45,-1]) cylinder(h=20,d=screw4); // mounting screw hole
		translate([30,45,-1]) cylinder(h=20,d=screw4); // mounting screw hole
	}
	translate([0,1,0]) rotate([90,0,90]) TitanMotorMount();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderMountHoles(Screw=screw3) {		// screw holes to mount extruder plate
	if(Screw==screw3) {
		translate([0,30-wall/2,-10]) color("red") cylinder(h = 25, d = Screw);
		translate([width/2-5,30-wall/2,-10]) color("white") cylinder(h = 25, d = Screw);
		translate([-(width/2-5),30-wall/2,-10]) color("blue") cylinder(h = 25, d = Screw);
		translate([width/4-2,30-wall/2,-10]) color("green") cylinder(h = 25, d = Screw);
		translate([-(width/4-2),30-wall/2,-10]) color("purple") cylinder(h = 25, d = Screw);
	}
	if(Screw==screw5) {
		translate([-(width/2-5),30-wall/2,-10]) color("blue") cylinder(h = 25, d = Screw);
		translate([-(width/4-10),30-wall/2,-10]) color("red") cylinder(h = 25, d = Screw);
		translate([width/4-2,30-wall/2,-10]) color("green") cylinder(h = 25, d = Screw);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanMotorMount(WallMount=0,Screw=screw4,InnerSupport=1) {
	difference() {	// motor mount
		translate([-1,0,0]) color("red") cubeX([54,60+shifttitanup,5],2);
		translate([25,35+shifttitanup,-1]) rotate([0,0,45]) color("purple") NEMA17_x_holes(8, 2);
		translate([15,5,0]) cylinder(h=wall*2,d=20); // hotend cooling hole
	    translate([15,5,0]) color("purple") rotate([180]) fillet_r(2,10,-1,$fn);	// hotend side
	    translate([15,5,5]) color("purple") fillet_r(2,10,-1,$fn);	// motor side
	}
	difference() { // front support
		translate([-1,24,-48]) color("blue") rotate([60,0,0]) cubeX([4,60,60],2);
		translate([-3,-30,-67]) cube([7,90,70]);
		translate([-3,-67,-45]) cube([7,70,90]);
	}
	if(WallMount) {
		difference() { // rear support
			translate([52,0,0]) color("cyan") cubeX([4,45+shifttitanup,45],2);
			// lower mounting screw holes
			translate([40,15,11]) rotate([0,90,0]) color("cyan") cylinder(h=20,d=Screw);
			translate([40,15,11+mount_seperation]) rotate([0,90,0])  color("blue") cylinder(h=20,d=Screw);
			if(Screw==screw4) { // add screw holes for horizontal extrusion
				translate([40,15+mount_seperation,34]) rotate([0,90,0]) color("red") cylinder(h=20,d=Screw);
				translate([40,15+mount_seperation,34-mount_seperation]) rotate([0,90,0])  color("pink") cylinder(h=20,d=Screw);
			}
		}
	} else {
		if(InnerSupport) {
			difference() { // rear support
				translate([49,24,-48]) rotate([60]) color("cyan") cubeX([4,60,60],2);
				translate([47,0,-67]) cube([7,70,70]);
				translate([47,-70,-36]) cube([7,70,70]);
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRMountHoles(Screw=screw3t) // ir screw holes for mounting to extruder plate
{
	translate([spacing+shiftir+shifthotend,-25,0]) rotate([90,0,0]) color("red") cylinder(h=3*(depthE+screw_depth),d=Screw);
	translate([shiftir+shifthotend,-25,0]) rotate([90,0,0]) color("blue") cylinder(h=3*(depthE+screw_depth),d=Screw);
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module BeltLoopHolder() {
	difference() {
		color("blue") cubeX([23,16,LoopHeight],1);
		translate([-1,3,-4]) beltLoop(); // lower
		translate([-1,3,12]) beltLoop(); // upper
	}
	translate([19,-8,0]) BeltLoopMountingBlock();
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltLoopMountingBlock() {
	difference() {
		color("pink") cubeX([MountThickness,32,LoopHeight],1);
		translate([-5,LoopHoleOffset,LoopHeight/2]) rotate([0,90,0]) color("red") cylinder(h=LoopHeight,d=screw3);
		translate([-19,LoopHoleOffset,LoopHeight/2]) rotate([0,90,0]) color("plum") cylinder(h=LoopHeight,d=screw3hd);
		translate([-5,4,LoopHeight/2]) rotate([0,90,0]) color("blue") cylinder(h=LoopHeight,d=screw3);
		translate([-19,4,LoopHeight/2]) rotate([0,90,0]) color("red") cylinder(h=LoopHeight,d=screw3hd);
	}
}

///////////////////end of x-carriage.scad////////////////////////////////////////////////////////////////////////////