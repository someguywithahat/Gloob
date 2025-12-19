x+=speedx
y+=speedy

//var inst = instance_place(x, y, obj_title_ArrowUp);
//if (inst != noone) {
//    inst.hp -= 1;
//}

if (place_meeting(x, y, obj_title_ArrowUp)) {
    speedy=gloop_speed*-1
	speedx=0
}

if (place_meeting(x, y, obj_title_ArrowDown)) {
    speedy=gloop_speed
	speedx=0
}

if (place_meeting(x, y, obj_title_ArrowRight)) {
    speedy=0
	speedx=gloop_speed
}

if (place_meeting(x, y, obj_title_ArrowLeft)) {
    speedy=0
	speedx=gloop_speed*-1
}
