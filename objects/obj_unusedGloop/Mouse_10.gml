
if issleep=0 and is_chasing>0
{
	var inst = instance_create_layer(x+16, y, "Instances", obj_effect_heart);
	inst.depth=depth-1
	//sleep_counter=sleep_counter+(sleep_counter_max-400)
	sleep_counter=sleep_counter_max
	sprite_index=Slm_All_Base_Expressions
	image_index=1
	image_speed=0
}