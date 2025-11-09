
if x<target_x and is_landed=0{
	x+=xx
	y+=yy

	image_angle+=5
}
else if x>=target_x and is_landed=0
	is_landed=1

if is_landed>0{
	despawn_counter++
	xx=0
	yy=0	
}

if despawn_counter>500{
	image_alpha-=0.01
}

if despawn_counter>600{
	instance_destroy()
}


if is_landed=0{
	var gloop = instance_position(x-8, y-4, obj_gloop);
	if gloop != noone{	
		is_landed=2
		stuck_to_gloopID=gloop.id
		stuck_xx=x-gloop.x
		stuck_yy=y-gloop.y		
	}
}
if is_landed=2{
	x=stuck_to_gloopID.x+stuck_xx
	y=stuck_to_gloopID.y+stuck_yy
	
	show_debug_message(string(stuck_to_gloopID.x)+" " + string(stuck_to_gloopID.y))
}