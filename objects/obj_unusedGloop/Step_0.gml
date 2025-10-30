if issleep=1
	sleep_duration++

if y<top_boundry
	y=y+2
	
if x>right_boundry
	x=x-2	
	
	
if irandom_range(1,100000)<6 and sleep_duration>1000{
//if irandom_range(1,100000)<60 and sleep_duration>1{	//debugging 
	issleep=0
	sprite_index=Spr_Slm_Move_Up_Jump	
	sleep_counter=0
}


	
	
if issleep=0
{
	move_towards_point(mouse_x,mouse_y,1)	
	sleep_counter++
	
	if image_index>image_number -1{
		image_index = 0
		var inst = instance_create_layer(x, y, "Instances", obj_effect_slime);
		inst.gloop_color_index=gloop_color_index
		
		var snd = audio_play_sound(snd_slime_move, 1, false);
		audio_sound_pitch(snd, random_range(0.9, 1.2));
		audio_sound_gain(snd, random_range(0.8, 1.0), 0);		
	}
}
if sleep_counter>sleep_timer
{
	issleep=1
	sleep_duration=0
	sprite_index=Spr_Slm_Sleep
	speed=0
}