//The exit sign in the top left corner, hanging from two chains.  Lights up when the mouse is over it
//scr_draw_sign's chains stop a few pixels above the sign's wood (its top tiles start 6 pixels down), so carry
//each chain a bit lower first, behind the sign.  Same spots scr_draw_sign uses: one tile in from each side
for (var i = 0; i < 2; i++)
	draw_sprite_ext(Signage, 6, exit_x + ((i=0) ? 32 : (exit_tiles_w-2)*32), exit_y-8, 2, 2, 0, c_white, 1)
scr_draw_sign(exit_x, exit_y, exit_w, exit_h, 2, exit_chains, 0, 0)
draw_set_font(global.fnt_Gloop)
draw_set_halign(fa_left)
draw_set_valign(fa_top)
var sign_w = exit_tiles_w*32
var sign_h = exit_tiles_h*32
var text = "Exit"
draw_set_color(c_white)
draw_set_alpha(exit_hover() ? 0.6 : 1)
draw_text(round(exit_x + (sign_w-string_width(text))/2), round(exit_y + (sign_h-string_height(text))/2), text)
draw_set_alpha(1)
