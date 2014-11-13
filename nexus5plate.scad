$fn=50;

//tollerance
t = 0.4;

// rounded corner radius
roundness = 12;

//magnet dimensions
mag_d = 10;
mag_t = 2.1;

//magnet placment positions
l_offset = -23;
r_offset = +23;
t_offset =  -23;
b_offest =  +23;

//magnet distance from plane
closeness = 0.4; 

//charging coil dimentions
coil_d = 51;
coil_t = 1;

coil_wire_d=43;
coil_wire_t=1;

//charging pcb dimensions
pcb_w = 62 + 2*t;
pcb_h = 39 + 2*t;
pcb_t = 5;

pcb_from_edge = 7;
pcb_seperation = 1;

pcb_usb_w = 10;
pcb_usb_d = 5;

//micro usb dimensions
usb_w = 7;
usb_h = 3;


//pcb mount holes
pcb_hole_radius= .5;
pcb_hole_bevel_radius=1;
pcb_hole_bevel_depth=1;

pcb_hole_t= pcb_h/2 -3;
pcb_hole_b= -(pcb_h/2 -9);
pcb_hole_l=-(pcb_w/2 -2.5);
pcb_hole_r=pcb_w/2 -2.5;

//starting box dimensions
width = max(pcb_w, coil_d) + 5;
height = max(pcb_h, coil_d) + 10;
thickness = closeness + coil_t + usb_h + pcb_seperation + 2 * coil_wire_t;

//pcbAssembly();
body();
//coilAssembly();

//pcb_holes();

module body(){
	difference() {	
		translate([0,0,thickness/2])
	 		roundedCube([width,height,thickness], roundness);
	 	magnets();
	
		pcbAssembly();
	
		coilAssembly();
	}
}

module coilAssembly(){
	wireWidth = 10*coil_wire_t + 2 * t;

	translate([0, 0, closeness]){
		translate([0, 0, coil_wire_t]){
			translate([0, 0, coil_wire_t])
				cylinder(d=coil_d + 2 * t, h=thickness);

			cylinder(d=coil_wire_d + 2 * t, h=thickness);		
		}

			// wire cutouts
			translate([-wireWidth/2, 0, 0])
				cube([wireWidth, coil_d/2 + coil_wire_t, thickness + coil_wire_t*2]);	

			translate([-wireWidth/2, coil_d/2, 0])
				cube([wireWidth, 3 * coil_wire_t, thickness + coil_wire_t*2]);		
	}
}

module pcbAssembly(){	
	translate([0,
			  pcb_h/2 - height/2 + pcb_from_edge,
			  closeness + coil_t + 2 * coil_wire_t + pcb_seperation]){

		translate([-pcb_w/2, -pcb_h/2 , 0])
			cube([pcb_w, pcb_h, pcb_t + height]);

		translate([-pcb_usb_w/2, -(pcb_h/2 + pcb_usb_d),0])
			cube([pcb_usb_w, pcb_usb_d, 50 + t]);

		translate([-usb_w/2, -pcb_h/2-10,0])
			cube([usb_w, pcb_h, usb_h + t]);

		translate([0, 0, -(coil_t  + pcb_seperation + coil_wire_t*2)])
			pcb_holes();

		
	}	
}

module pcb_holes(){
  translate([pcb_hole_l, pcb_hole_t, 0])
   pcbHole();   
  translate([pcb_hole_r, pcb_hole_t, 0])
   pcbHole();
  translate([pcb_hole_l, pcb_hole_b, 0])
   pcbHole();
  translate([pcb_hole_r, pcb_hole_b, 0])
   pcbHole();
}

module pcbHole(){
	cylinder(r= pcb_hole_radius + t, h=thickness);
	translate([0,0, -pcb_hole_bevel_depth+(coil_t  + pcb_seperation + coil_wire_t*2)])
    		cylinder(r1= pcb_hole_radius + t, 
		    		r2= pcb_hole_bevel_radius + t, 
				h= pcb_hole_bevel_depth + t);
}

module magnets(){
  translate([t_offset, l_offset, closeness])
    cylinder(d=mag_d + t, h=thickness);
  translate([t_offset, r_offset, closeness])
    cylinder(d=mag_d + t, h=thickness);
  translate([b_offest, r_offset, closeness])
    cylinder(d=mag_d + t, h=thickness);
  translate([b_offest, l_offset, closeness])
    cylinder(d=mag_d + t, h=thickness);
}

module roundedCube(size, radius){
    cube(size - [2*radius,0,0], true);
    cube(size - [0,2*radius,0], true);
    for (x = [radius-size[0]/2, -radius+size[0]/2],
           y = [radius-size[1]/2, -radius+size[1]/2]) {
      translate([x,y,0]) 
		cylinder(r=radius, h=size[2], center=true);
    }
}

