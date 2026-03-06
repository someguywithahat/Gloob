


if is_throwSnowball>15
{
	sprite_index = Spr_Slm_Move_Roll
	image_speed=-3
	
	instance_nth_nearest(x,y,obj_test_slimebrawl,2)
	
		
}
else
{
	sprite_index=Spr_Slm_Idol
	image_speed=0
}

draw_sprite_ext(sprite_index,image_index,x,y,1,1,rotation,c_white,1)