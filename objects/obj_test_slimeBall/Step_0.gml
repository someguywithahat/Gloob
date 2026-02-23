

if makeSnowman=0
{
	makeSnowman=1
	
}

//if leaf_target=0
//{
//	leaf_id = instance_nearest(x, y, obj_effectLeafPile);

//	if (instance_exists(leaf_id)) {
//	    jump_targetx = leaf_id.x+(leaf_id.sprite_width/2)+60;
//	    jump_targety = leaf_id.y+(leaf_id.sprite_height/2);
		
//		leaf_targetx = leaf_id.x+(leaf_id.sprite_width/2)+16
//		leaf_targety = leaf_id.y+(leaf_id.sprite_height/2)+16;
		
//		leaf_target=1
//		move_towards_point(jump_targetx,jump_targety,1.5)
//	}
//}

//if leaf_target=1
//{	
//	if abs(distance_to_point(jump_targetx,jump_targety))<3
//	///if distance_to_object(obj_effectLeafPile)<3
//	{
//		leaf_target=2
//		image_index=0
//		image_speed=0
//		speed=0
//	}
//}


//if leaf_target=2
//{
//	move_towards_point(leaf_targetx,leaf_targety,2)
//	rotation=abs(((jump_targetx-leaf_targetx)-(x-leaf_targetx))/(jump_targetx-leaf_targetx))*180
//	if abs(distance_to_point(leaf_targetx,leaf_targety))<3
//	{
//		leaf_id.explode=1
//		leaf_target=3
//		speed=0
//		rotation=0
//		x=leaf_id.x +16
//		y=leaf_id.y+16
//		depth=depth+4
//		audio_play_sound(snd_effect_leaf_crunch, 1, false);
		
//	}
//}