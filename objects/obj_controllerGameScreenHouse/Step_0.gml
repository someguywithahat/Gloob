//day end

		

		
if day_over=0 and global.controller.season_goal<=0 and global.controller.game_over_status<1
{
	audio_play_sound(snd_slm_woo, 1, false);
	day_over=1
	image_speed=1
	with obj_unusedGloop
	{
		is_bedtime=1	
		image_index = irandom(sprite_get_number(sprite_index) - 1);
		bedtimeX=other.x-16
		bedtimeY=other.y-22
	}
}

//day start
if day_over=1 and global.controller.season_goal>0
{
	day_over=0


	if global.weather=global.SUMMER
		sprite_index=Spr_House_Mushroom_summer
	else if global.weather=global.FALL
	{
		sprite_index=Spr_House_Mushroom_Fall
		var inst = instance_create_layer(x-110, y+340, "Instances", obj_effectLeafPile);
		inst.depth=depth-200
	}
	else if global.weather=global.WINTER
	{
		instance_destroy(obj_effectLeafPile)
		sprite_index=Spr_House_Mushroom_Winter	
	}
	else if global.weather=global.SPRING
		sprite_index=Spr_House_Mushroom_Spring
	
	image_speed=0
	image_index=0
	
	with obj_unusedGloop
	{
		is_angry=0
		is_sad=0
		is_sad_gameOver=0
		is_cold=0
		is_bedtime=0
		is_chasing=0
		is_movingToLeaves=0 
		is_flipping=0
		
		is_bedtime=0
		x=1130+irandom_range(1,204)
		y=180+irandom_range(1,300)
		image_alpha=1
		rotation=0
		speed=0
		issleep=1
		sleep_duration=0
	}
}
