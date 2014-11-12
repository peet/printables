$fn=35;

//tollerance
t = 0.4;

// rounded corner radius
roundness = 15;

//magnet dimensions
mag_d = 10;
mag_t = 2.1;

//magnet placment positions
l_offset = -18;
r_offset = +18;
t_offset =  -18;
b_offest =  +18;

//magnet distance from plane
closeness = 0.4; 

//charging coil dimentions
coil_d = 50;
coil_t = 3;

coil_wire_d=40;
coil_wire_t=2;

//charging pcb dimensions
pcb_w = 62;
pcb_h = 39;
pcb_t = 3;

pcb_from_edge = 7;
pcb_seperation = 5;

//micro usb dimensions
usb_w = 10;
usb_h = 5;

//starting box dimensions
width = max(pcb_w, coil_d) + 5;
height = max(pcb_h, coil_d) + 5;
thickness = closeness + mag_t + coil_t + pcb_t+10;

//pcbAssembly();
body();
//coilAssembly();

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
	translate([0, 0, closeness + mag_t]){
		translate([0, 0,coil_wire_t])
			cylinder(d=coil_d + 2 * t, h=thickness);

		cylinder(d=coil_wire_d + 2 * t, h=thickness);

		translate([-coil_wire_t, 0,0])
			cube([2*coil_wire_t,coil_d/2+coil_wire_t,coil_wire_t]);	

		translate([-coil_wire_t, coil_d/2,0])
			cube([2*coil_wire_t,coil_wire_t,thickness+coil_wire_t]);				
	}
}

module pcbAssembly(){
	translate([0,0,closeness + mag_t + coil_t  + pcb_seperation]){
		translate([-pcb_w/2, -height/2 + pcb_from_edge, 0])
			cube([pcb_w,pcb_h,pcb_t+height]);

		translate([-usb_w/2,-height/2-10,0])
			cube([usb_w,pcb_h,usb_h]);

	}
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

