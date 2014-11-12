$fn=350;

t = 0.4;

roundness = 15;

mag_d = 10;
mag_t = 2.1;

coil_d = 50;
coil_t = 3;

pcb_w = 62;
pcb_h = 39;
pcb_t = 3;

usb_w = 10;
usb_h = 5;

b_to_c = 5;

closeness = 0.4;

width = max(pcb_w, coil_d) + 5;
height = max(pcb_h, coil_d) + 5;
thickness = closeness + mag_t + coil_t + pcb_t;

l_offset = width/2 - 18;
r_offset = width/2 + 18;
t_offset = height/2 - 18;
b_offest = height/2 + 18;

difference() {
  body();

  translate([t_offset, l_offset, closeness])
    cylinder(d=mag_d + t, h=thickness);
  translate([t_offset, r_offset, closeness])
    cylinder(d=mag_d + t, h=thickness);
  translate([b_offest, r_offset, closeness])
    cylinder(d=mag_d + t, h=thickness);
  translate([b_offest, l_offset, closeness])
    cylinder(d=mag_d + t, h=thickness);

  translate([height/2, width/2, closeness + mag_t])
    cylinder(d=coil_d + 2 * t, h=thickness);
}

translate([height + 20, 0, 0]) difference() {
  body();

  translate([b_to_c, (width - pcb_w - t)/2, closeness])
    cube(size=[pcb_h + t, pcb_w + t, thickness]);
  translate([-0.1, (width - usb_w - t)/2, closeness * 2])
    cube(size=[20, usb_w + t, thickness]);
}

module body() {
  translate([roundness/2,roundness/2,0]) minkowski() {
    cube(size=[height-roundness,width-roundness,thickness]);
    cylinder(d=roundness,h=0.1);
  }
  *translate([width/2, width/2, 0]) cylinder(d = 68, h = thickness);
}