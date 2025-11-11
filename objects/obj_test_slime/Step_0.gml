if locked=1{
	x=mouse_x-16
	y=mouse_y-16
}
	
if !mouse_check_button(mb_left)
{
	if locked=1 		
		target_obj = instance_create_layer(x+8, y, "Instances", obj_effect_heart );
	locked=0
}


if (mouse_check_button_pressed(mb_left)) {
    if (position_meeting(mouse_x, mouse_y, id)) {
        locked=1
    }
}

if mixit<>0
{
	if mix_percent>=1
	{
		mixit=-1
	}
	else if mix_percent<=0
	{
		mixit=1
	}
	
	mix_percent+=(0.005 * mixit)
}