//var xx = 1204
//var yy = 40
//var xx_spr = xx+30
//var yy_spr = yy-20

//Sprite drawing positions
var spr_width = sprite_get_width(shop_sprite)
var spr_height = sprite_get_height(shop_sprite)
var spr_xx = sprite_get_xoffset(shop_sprite)
var spr_yy = sprite_get_yoffset(shop_sprite)
var xx_spr = xx+ (54-(spr_width/2))  //top left of sprite
var yy_spr = yy+16 -(spr_height/2)


//var highlighted=0
clicked_left =  scr_draw_menu_item(xx-25, yy,"<",clicked_left)	
clicked_right = scr_draw_menu_item(xx+115, yy,">",clicked_right)	

clicked_up = scr_draw_menu_spr(xx+38, yy-8-(spr_height/2), Arrow, 6, clicked_up)
clicked_down = scr_draw_menu_spr(xx+38, yy+16+(spr_height/2), Arrow, 4, clicked_down)

//clicked_up = scr_draw_menu_spr(xx+50, yy+50, Arrow, 6, clicked_up)
//clicked_down = scr_draw_menu_spr(xx+50, yy+50, Arrow, 4, clicked_down)

var sprite_opacity = 1
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);


if (point_in_rectangle(mx, my, xx_spr, yy_spr, xx_spr+spr_width, yy_spr+spr_height)) {
    sprite_opacity=1
}
else {
	sprite_opacity=0.7
}


draw_sprite_ext(shop_sprite,shop_index_sub, xx_spr+spr_xx,yy_spr+spr_yy,1,1,0,c_white,sprite_opacity)


//----------------DEBUGGING BELOW
//scr_draw_text(20,1,string(array_length(shop_sub_item)),0)
//scr_draw_text(60,1,string(shop_index_sub),0)
