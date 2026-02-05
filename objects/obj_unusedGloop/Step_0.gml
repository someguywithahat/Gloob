if is_bedtime=1
{
	move_towards_point(bedtimeX,bedtimeY,1)	
	if abs(distance_to_point(bedtimeX,bedtimeY))<4
	{
		speed=0	
		x=bedtimeX
		y=bedtimeY
		is_bedtime=2	
		//show_debug_message("test home?")
	}		
}
if is_bedtime=2
{
	
	image_alpha=image_alpha-0.05
	//if image_alpha<0
	//	image_alpha=0
}


if issleep=1
	sleep_duration++

if y<top_boundry
	y=y+2
	
if x>right_boundry
	x=x-2	
	
if y>bottom_boundry
	y=y-2
	
if x<left_boundry
	x=x+2	
	
if is_sad_gameOver=0
{
	
	//fall leaves
	if global.weather=global.FALL and is_movingToLeaves>0
	{
		if leaf_target=0
		{
			leaf_id = instance_nearest(x, y, obj_effectLeafPile);

			if (instance_exists(leaf_id)) {
			    jump_targetx = leaf_id.x+(leaf_id.sprite_width/2)+70;
			    jump_targety = leaf_id.y+(leaf_id.sprite_height/2)+10;
		
				leaf_targetx = leaf_id.x+(leaf_id.sprite_width/2)+16
				leaf_targety = leaf_id.y+(leaf_id.sprite_height/2)+16;
		
				leaf_target=1
				move_towards_point(jump_targetx,jump_targety,1.5)
			}
			else 
				is_movingToLeaves=0
		}
		if leaf_target=1
		{	
			move_towards_point(jump_targetx,jump_targety,1.5)
			if abs(distance_to_point(jump_targetx,jump_targety))<3
			///if distance_to_object(obj_effectLeafPile)<3
			{
				leaf_target=2
				image_index=0
				image_speed=0
				speed=0
			}
		}
		if leaf_target=2
		{
			move_towards_point(leaf_targetx,leaf_targety,2)
			rotation=abs(((jump_targetx-leaf_targetx)-(x-leaf_targetx))/(jump_targetx-leaf_targetx))*180
			if abs(distance_to_point(leaf_targetx,leaf_targety))<3
			{
				leaf_id.explode=1
				leaf_target=3
				speed=0
				rotation=0
				x=leaf_id.x +15
				y=leaf_id.y+13
				audio_play_sound(snd_effect_leaf_crunch, 1, false);
				
			}
		}
	}
	
	//wake up chance
	else if irandom_range(1,100000)<5 and sleep_duration>1000 and issleep=1{
		issleep=0
		is_chasing=1
		sprite_index=Spr_Slm_Move_Jump	
		sleep_counter=0
	}	
	else if global.weather=global.FALL and irandom_range(1,10000)<5 and sleep_duration>300 and issleep=1{
		issleep=0
		is_movingToLeaves=1
		sprite_index=Spr_Slm_Move_Jump	
		sleep_counter=0
	}
	//awake and chasing cursor
	else if issleep=0 and is_chasing=1 and well_fed<=0
	{
		move_towards_point(mouse_x,mouse_y,1)	
		sleep_counter++
	
		if image_index>image_number -1{
			image_index = 0
			var inst = instance_create_layer(x, y, "Instances", obj_effect_slime);
			inst.gloop_color_index=gloop_color_index
		}
	}

	//go back to sleep
	if sleep_counter>sleep_counter_max
	{
		issleep=1
		is_chasing=0
		is_sad=0
		sleep_duration=0
		sprite_index=Spr_Slm_Sleep
		speed=0
		image_speed=1
	}
	//Failed to get attention and is now sad
	else if(sleep_counter>sleep_counter_max-sad_range and is_chasing=1)
	{
		is_sad=1
		is_chasing=0
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
}
if is_sad_gameOver>0
	speed=0


	
