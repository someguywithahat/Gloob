var controller = global.controller;

	
	
yy = player*(95) + 10
var gloop_scale = 1.0 + (gloop_score/100)
//var x_shift = (parent_sprite.sprite_width*(gloop_score/100.0))/2
var x_shift = (sprite_get_width(parent_sprite))*(gloop_score/100.0)/2
var y_shift = (sprite_get_height(parent_sprite))*(gloop_score/100.0)/2


//	for(var s=0; s<number_of_players; s++){
scr_draw_sign(5,20+((player)*95),200,60,1,2,0,hasVines)
		
//	}


//draw_sprite(parent_sprite,1, xx, yy)
//make the score grow
//draw_sprite_ext(parent_sprite, 1, xx-x_shift, yy-y_shift, gloop_scale, gloop_scale, 0, c_white, 1);

//testing
draw_sprite_ext(parent_sprite, gloop_color_index, xx-5-x_shift, yy+30-y_shift, gloop_scale, gloop_scale, 0, c_white, 1);
draw_sprite_ext(spr_gloop_smile, gloop_color_index, xx-5, yy+30, 1, 1, 0, c_white, 1);


scr_draw_score(xx+50, yy+15, gloop_score)

if gloop.powerUp1>0
	draw_sprite(controller.PU_SPRITES[gloop.powerUp1-1], 0, xx+52, yy+48)
if gloop.powerUp2>0
	draw_sprite(controller.PU_SPRITES[gloop.powerUp2-1], 0, xx+52+32, yy+48)
if gloop.powerUp3>0
	draw_sprite(controller.PU_SPRITES[gloop.powerUp3-1], 0, xx+52+64, yy+48)	




