

despawn_counter++
if despawn_counter>despawn_timer
	instance_destroy();

x+=xx
y+=yy
yy+=gravity

image_angle+=5


if despawn_counter>60
	image_alpha-=0.02