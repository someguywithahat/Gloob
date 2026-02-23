

draw_sprite_ext(sprite_index,image_index,x,y,1,1,rotation,c_white,1)

if makeSnowman>0
{
	sprite_index = Spr_Slm_Move_Spin
	snowball+=0.05
}


draw_circle(x+sprite_width-6+(snowball/2),y+sprite_height-snowball-3,snowball,0)