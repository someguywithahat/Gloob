if issleep=1
	sleep_duration++

if y<top_boundry
	y=y+2
	
if x>right_boundry
	x=x-2	
	
if is_sad_gameOver=0
{
	//wake up chance	
	if irandom_range(1,100000)<5 and sleep_duration>1000 and issleep=1{
	//if irandom_range(1,100000)<60 and sleep_duration>1{	//debugging 
		issleep=0
		sprite_index=Spr_Slm_Move_Up_Jump	
		sleep_counter=0
	}	
	//awake and chasing cursor
	else if issleep=0 and well_fed<=0
	{
		move_towards_point(mouse_x,mouse_y,1)	
		sleep_counter++
	
		if image_index>image_number -1{
			image_index = 0
			var inst = instance_create_layer(x, y, "Instances", obj_effect_slime);
			inst.gloop_color_index=gloop_color_index
		
			//var snd = audio_play_sound(snd_slime_move, 1, false);
			//audio_sound_pitch(snd, random_range(0.9, 1.2));
			//audio_sound_gain(snd, random_range(0.8, 1.0), 0);		
		}
	}

	//go back to sleep
	if sleep_counter>sleep_counter_max
	{
		issleep=1
		is_sad=0
		sleep_duration=0
		sprite_index=Spr_Slm_Sleep
		speed=0
		image_speed=1
	}
	//Failed to get attention and is now sad
	else if(sleep_counter>sleep_counter_max-sad_range and issleep=0)
	{
		is_sad=1
		speed=0	
	}

	//Annoy sleeping slime
	if (mouse_check_button_pressed(mb_left) and issleep>=1) {
	    if (position_meeting(mouse_x, mouse_y, id)) {
			clicked_while_sleeping++
			var shake_amount=2
		    x += random_range(-shake_amount, shake_amount);
		    y += random_range(-shake_amount, shake_amount);
			if clicked_while_sleeping>10{
				clicked_while_sleeping=0
				is_angry=180
			}
	    }
	}
	//Burning off anger
	if is_angry>0
	{
		is_angry--
		if is_angry>60
			{
			var shake_amount=2
		    x += random_range(-shake_amount, shake_amount);
		    y += random_range(-shake_amount, shake_amount);
		}
	}
	
	//if global.weather=1
	//{
	//	var chilly_check = irandom_range(0,1000)
	//	{
	//		if chilly_check=1
	//			is_cold=300
	//	}
		
	//	if is_cold>0
	//	{
	//		is_cold--	
	//		var shake_amount=3
	//		if is_cold mod 2 <> 1
	//			shake_amount=shake_amount*-1
	//		x += shake_amount
	//	}
		
		
	//}
	//else is_cold=0

}
if is_sad_gameOver>0
	speed=0


	
