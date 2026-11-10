//Not caught yet: the empty bowl (the object's own sprite, sized in the room editor).
//Caught: the fish in its bowl, moved up so it sits on the shelf the same way
if caught and bowl_sprite>=0
	draw_sprite_ext(bowl_sprite, floor(frame), x, y-empty_drop*image_yscale, image_xscale, image_yscale, 0, c_white, 1)
else
	draw_self()

//---- Name plaque on the front of the shelf, for caught fish ----
if caught and fish_title<>""
{
	draw_set_font(global.fnt_plaque)
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	var text_w = string_width(fish_title)
	var text_h = 8 //spr_gloopFont_Tiny's letters
	var plaque_w = text_w + plaque_pad*2 + 2
	var plaque_h = text_h + plaque_pad_v*2 + 2
	//Centered under the bowl (Spr_Empty_Bowl is 72 wide, 42 to its base)
	var px = round(x + 36*image_xscale - plaque_w/2)
	var py = round(y + 42*image_yscale + plaque_drop)
	var right = px+plaque_w-1
	var bottom = py+plaque_h-1

	//Gold trim: lighter along the top and left, darker along the bottom and right, like a raised frame
	draw_set_color(plaque_gold)
	draw_rectangle(px, py, right, bottom, false)
	draw_set_color(plaque_gold_light)
	draw_rectangle(px, py, right-1, py, false)
	draw_rectangle(px, py, px, bottom-1, false)
	draw_set_color(plaque_gold_dark)
	draw_rectangle(px+1, bottom, right, bottom, false)
	draw_rectangle(right, py+1, right, bottom, false)

	//Red inside, with a little shadow under the top trim
	draw_set_color(plaque_red)
	draw_rectangle(px+1, py+1, right-1, bottom-1, false)
	draw_set_color(plaque_red_dark)
	draw_rectangle(px+1, py+1, right-1, py+1, false)

	//The name, in gold
	draw_set_color(plaque_gold_light)
	draw_text(px+1+plaque_pad, py+1+plaque_pad_v, fish_title)
	draw_set_color(c_white)
}
