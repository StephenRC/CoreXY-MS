///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// titan_bowden_adapter.scad - connect a bowden to the Titan
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created: 1/8/2017
// last modified: 1/8/2017
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/8/2017	- Colors are for making it easier to edit the correct bits
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Uses a threaded push fit connector
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubex.scad>
$fn=50;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// vars
adapter_d = 9.8; // hole size for ptfe connector, 9.8mm is fine for 3/8"
filament_d = 5.2;	// ptfe size or filament size, 5.2mm is for 1.75mm filament tube supllied by filastruder.com
e3dv6_clearance = 0.1;	// to make the center land a tad thinner
// from http://wiki.e3d-online.com/wiki/E3D-v6_Documentation
e3dv6_od = 16;	// e3dv6 mount outside diameter
e3dv6_id = 12;	// e3dv6 mount inner diameter
ed3v6_tl = 3.7;	// e3dv6 mount top lad height
e3dv6_il = 5.8-e3dv6_clearance;	// e3dv6 mount inner land height
e3dv6_bl = 3.6;	// e3dv6 mount bottom land height
e3dv6_total = ed3v6_tl + e3dv6_il + e3dv6_bl; // e3dv6 total mount height

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

adapter();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module adapter() {
	difference() {
		e3dv6();
		translate([0,0,-2]) color("red") cylinder(h=50,d=filament_d,$fn=100);
		translate([0,0,15]) color("blue") cylinder(h=50,d=adapter_d,$fn=100);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module e3dv6() {
	color("cyan") cylinder(h=e3dv6_total,d=e3dv6_id,$fn=100);
	translate([0,0,e3dv6_il+e3dv6_bl]) color("salmon") cylinder(h=ed3v6_tl+10,d=e3dv6_od,$fn=100);
	translate([0,0,e3dv6_il+e3dv6_bl+5]) color("salmon") cylinder(h=ed3v6_tl+4,d=e3dv6_od+3,$fn=6);
	translate([0,0,-1]) color("coral") cylinder(h=e3dv6_bl,d=e3dv6_od,$fn=100);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////