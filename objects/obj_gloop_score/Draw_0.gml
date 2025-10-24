
yy = player*(sprite_height+5) + 10
var gloop_scale = 1.0 + (gloop_score/100)
//var x_shift = (parent_sprite.sprite_width*(gloop_score/100.0))/2
var x_shift = (sprite_get_width(parent_sprite))*(gloop_score/100.0)/2
var y_shift = (sprite_get_height(parent_sprite))*(gloop_score/100.0)/2



//draw_sprite(parent_sprite,1, xx, yy)
//make the score grow
//draw_sprite_ext(parent_sprite, 1, xx-x_shift, yy-y_shift, gloop_scale, gloop_scale, 0, c_white, 1);

//testing
draw_sprite_ext(parent_sprite, gloop_color_index, xx-x_shift, yy-y_shift, gloop_scale, gloop_scale, 0, c_white, 1);
draw_sprite_ext(spr_gloop_smile, gloop_color_index, xx, yy, 1, 1, 0, c_white, 1);


scr_draw_score(xx+30, yy, gloop_score)

if gloop.powerUp1>0
	draw_sprite(spr_PowerUp, gloop.powerUp1-1, xx+110, yy)





