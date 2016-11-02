///////////////////////////////////////////////////////////////////////
// leadscrewtop.scad
////////////////////////////////////////////////////////////////////////
// created 9/4/16
// last upate 9/4/16
////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
////////////////////////////////////////////////////////////////////////
$fn=100;

top();
translate([0,15,0]) top();

//////////////////////////////////////////////////////////////////////////

module top() {
	difference() {
		cylinder(h=8,d=screw8+2);
		translate([0,0,2]) cylinder(h=8,d=screw8);
	}
	hull() {
		cylinder(h=2,d=screw8+2);
		translate([10,0,0]) cylinder(h=2,d=screw2);
	}
}

///////////////////////// end of leadscrewtop.scad //////////////////////