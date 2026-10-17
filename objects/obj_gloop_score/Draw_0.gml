var controller = global.controller;

//Slimes sharing this sign: the owner first, then any crown slimes still alive, in the order they appeared
var slimes = [gloop]
with(obj_gloop)
	if gloop_score_obj=other.id and id<>other.gloop and alive=1
		array_push(slimes, id)
extra_rows = array_length(slimes)-1

//Signs above this one grow taller when they have crown slimes.  Move down to make room
var y_offset = 0
var my_player = player
with(obj_gloop_score)
	if player<my_player
		y_offset += extra_rows*powerup_row_height

yy = player*(95) + 10 + y_offset
var gloop_scale = 1.0 + (gloop_score/100)

var x_shift = (sprite_get_width(parent_sprite))*(gloop_score/100.0)/2
var y_shift = (sprite_get_height(parent_sprite))*(gloop_score/100.0)/2


scr_draw_sign(5, 20+(player*95)+y_offset, 200, 60+extra_rows*powerup_row_height, 1, 2, 0, hasVines)



//testing
draw_sprite_ext(parent_sprite, gloop_color_index, xx-5-x_shift, yy+30-y_shift, gloop_scale, gloop_scale, 0, c_white, 1);
draw_sprite_ext(spr_gloop_smile, gloop_color_index, xx-5, yy+30, 1, 1, 0, c_white, 1);


scr_draw_score(xx+50, yy+15, gloop_score)

if (mouse_check_button_pressed(mb_left)
and mouse_x>xx+50
and mouse_x<xx+50+60
and mouse_y>yy+15
and mouse_y<yy+15+25
and gloop_score>0)
{
	var point = instance_create_layer(mouse_x, mouse_y, "Instances", obj_effect_point);
	gloop_score--
}


//One row of powerups per slime
for (var r = 0; r < array_length(slimes); r++)
{
	var slime = slimes[r]
	var row_y = yy + 48 + r*powerup_row_height
	if slime.powerUp1>-1
		draw_sprite(controller.PU_SPRITES[slime.powerUp1], sign_sprite_frame1, xx+52, row_y)
	if slime.powerUp2>-1
		draw_sprite(controller.PU_SPRITES[slime.powerUp2], sign_sprite_frame2, xx+52+32, row_y)
	if slime.powerUp3>-1
		draw_sprite(controller.PU_SPRITES[slime.powerUp3], sign_sprite_frame3, xx+52+64, row_y)
}

sign_sprite_frame1+=0.2
sign_sprite_frame2+=0.2
sign_sprite_frame3+=0.2
