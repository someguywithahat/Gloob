

x+=xx
y+=yy
despawn_counter++


if despawn_counter>20{
	xx=0
	yy=0
	image_speed=1
	if image_index>=image_number-1
		instance_destroy()
	
}