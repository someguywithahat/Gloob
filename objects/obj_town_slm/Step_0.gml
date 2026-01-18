if locked=1{
	x=mouse_x-16
	y=mouse_y-16
}
	
if !mouse_check_button(mb_left)
{
	var heart_chance=irandom_range(1,100)
	if locked=1 and heart_chance<3
		target_obj = instance_create_layer(x+8, y, "Instances", obj_effect_heart );
	locked=0
	global.mouseDrag=0
}


if (mouse_check_button_pressed(mb_left)) and global.mouseDrag=0 {
    if (position_meeting(mouse_x, mouse_y, id)) {
        locked=1
		global.mouseDrag=1
    }
}


