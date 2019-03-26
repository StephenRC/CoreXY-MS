///////////////////////////////////////////////////////////////////////
// Wire-Chain-Mounts-and-Supports.scad - mounts for a wire chain on the MS CoreXY
///////////////////////////////////////////////////////////////////////
// Wire chain is set to use two 4mm button head screws to attach ends
///////////////////////////////////////////////////////////////////////
// create 7/5/2016
// last update 2/28/19
///////////////////////////////////////////////////////////////////////
// 7/24/16 added extra support to corner of xy()
// 7/25/16 added y() for the y axis wireguide
// 2/28/19 added to have holes or have no holes for the wireguide bracket in y()
///////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
$fn=50;
///////////////////////////////////////////////////////////////////////
// vars
height = 50;
width = 37;	// width of wire chain
thickness = 5;
tab = 25;
tab2 = 45;
///////////////////////////////////////////////////////////////////////

all();
//partial();

////////////////////////////////////////////////////////////////////////////////////////////////////

module all() {
	if($preview) %translate([-75,-75,-5]) cubeX([200,200,5],2);
	y(1);	// on frame for y axis to hold wireguide end
	translate([40,0,0]) y(0);	// on frame for y axis to support wireguide
	translate([55,40,0]) y(0);	// on frame for y axis to support wireguide
	translate([0,40,0]) xy();	// on x axis carriage plate for both wireguide ends
	translate([-12,20,0]) xs();	// spacer for x-carriage end
	translate([-22,40,0]) zip_mount();
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module partial() {
	//y();	// on frame for y axis
	//translate([0,40,0]) y();	// on frame for y axis to support wireguide
	//translate([40,0,0]) y();	// on frame for y axis to support wireguide
	//translate([0,-40,0])
	//	xy();	// on x axis carriage plate for both wireguides
	//translate([0,40,0])
		xs();	// spacer for x-carriage end
	//translate([-22,40,0])
	//	zip_mount();
}

////////////////////////////////////////////////////////////////

module y(Holes=1) {	// 	// on frame for y axis
	difference() { // vertical
		color("cyan") cubeX([height/2+4,width,thickness],2);
		translate([height/2-10,width-8,-2]) rotate([0,0,0]) color("red") cylinder(h=thickness*2,r=screw5/2);
		translate([height/2-10,width-28,-2]) rotate([0,0,0]) color("blue") cylinder(h=thickness*2,r=screw5/2);
	}
	if(Holes) {
		difference() { // wireguide mount
			color("black") cubeX([thickness,width,tab],2);
			translate([-2,width/2-5,tab/2+thickness/2]) rotate([0,90,0]) color("yellow") cylinder(h=thickness*2,r=screw4t/2);
			translate([-2,width/2+5,tab/2+thickness/2]) rotate([0,90,0]) color("purple") cylinder(h=thickness*2,r=screw4t/2);
		}
	} else color("lightgray") cubeX([thickness,width,tab],2);
	support();
}

///////////////////////////////////////////////////////////////////////////////////////////

module support() {
	difference() {
		translate([-15,width/2-2.25,7.5]) rotate([0,40,0]) color("pink") cubeX([width,thickness,tab],2);
		translate([-20,width/2-4,-22]) rotate([0,0,0]) color("red") cube([width*2,thickness+4,tab],2);
		translate([-22,width/2-4,-2]) rotate([0,0,0]) color("blue") cube([tab,thickness+4,width],2);
	}
}

//////////////////////////////////////////////////////////////////

module xs() {	// spacer for x-carriage end
	difference() {
		color("cyan") cubeX([10,15,10]);
		translate([5,5,-2]) color("black") cylinder(h=15,r=screw5/2);
	}
}

/////////////////////////////////////////////////////////////////

module xy() {	// on x axis carriage plate for both wireguides
	difference() { // vertical
		color("cyan") cubeX([height,width,thickness],2);
		translate([height-10,width-8,-2]) rotate([0,0,0]) color("red") cylinder(h=thickness*2,r=screw5/2);
		translate([height-10,width-28,-2]) rotate([0,0,0]) color("blue") cylinder(h=thickness*2,r=screw5/2);
	}
	difference() { // wireguide mount
		color("purple") cubeX([thickness,width,tab2],2);
		translate([-2,12,tab/2-2]) rotate([0,90,0]) color("gray") cylinder(h=thickness*2,r=screw4t/2);
		translate([-2,12,tab/2+8]) rotate([0,90,0]) color("white") cylinder(h=thickness*2,r=screw4t/2);
		translate([-2,width/2+2,tab2-10]) rotate([0,90,0]) color("black") cylinder(h=thickness*2,r=screw4t/2);
		translate([-2,width/2+12,tab2-10]) rotate([0,90,0]) color("green") cylinder(h=thickness*2,r=screw4t/2);
	}
	support();
}

///////////////////////////////////////////////////////////////////////////////////

module zip_mount() {
	difference() {
		color("cyan") cubeX([20,20,4],1);
		translate([12,10,-3]) color("red") cylinder(h=10,r=screw5/2,$fn=100);
	}
	difference() {
		color("blue") cubeX([4,20,70],1);
		color("green") hull() {
			translate([-3,10,30]) rotate([0,90,0]) cylinder(h=10,r=screw5/2,$fn=100);
			translate([-3,10,60]) rotate([0,90,0]) cylinder(h=10,r=screw5/2,$fn=100);
		}
	}
}

//////////////////// end of wireguide.scad /////////////////////