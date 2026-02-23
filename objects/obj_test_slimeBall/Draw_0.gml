

draw_sprite_ext(sprite_index,image_index,x,y,1,1,rotation,c_white,1)

if is_makeSnowman=1
{
	sprite_index = Spr_Slm_Move_Spin
	snowball+=0.15
	if snowball>=15
	{
		is_makeSnowman=2
	}
		
}

if is_makeSnowman=1
{
	sprite_index = Spr_Slm_Move_Spin
	snowball+=0.015
	if snowball>=15
	{
		is_makeSnowman=2
	}
		
}
//if is_makeSnowman=2
//{
//	jump_targetx
//}

//if is_makeSnowman>0
//draw_circle(x+sprite_width-6+(snowball/2),y+sprite_height-snowball-3,snowball,0)
//draw_sprite_ext(spr_effect_particle_test,0,x+sprite_width-6+(snowball/2),y+sprite_height-snowball-3,snowball,snowball,0,c_white,1)