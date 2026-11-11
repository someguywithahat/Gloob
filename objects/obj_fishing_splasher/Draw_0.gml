//x, y is the middle of the slime at the water line.  The slime sprites are 32x32, top left origin, body bottom at row 31

//Ripples on the water where it is (not while it's up in the air)
if state<>"jump"
{
	var ring = (current_time/600 + real(id)) mod 1 //Grows outward and fades, over and over
	draw_set_color(c_white)
	draw_set_alpha(0.35*(1-ring))
	draw_ellipse(x-8-ring*10, y-2-ring*3, x+8+ring*10, y+2+ring*3, true)
	draw_set_alpha(1)
}

shader_set(shd_palette_swap)
var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig")
var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap")
var u_color_count = shader_get_uniform(shd_palette_swap, "color_count")
texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0))
texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_all, color_index))
shader_set_uniform_f(u_color_count, 6.0)

if state="peek"
{
	//Just its head out of the water, bobbing a little: the top of the sprite down to just below its eyes
	var bob = round(sin(current_time/250 + real(id))*1)
	var show = 22 + bob
	draw_sprite_part(Spr_Slm_Idol, floor(anim) mod sprite_get_number(Spr_Slm_Idol), 0, 0, 32, show, x-16, y-show)
}
else if state="jump"
{
	//Leaping, flipped to face where it's going
	var k = min(1, state_time/jump_frames)
	var lift = jump_height*4*k*(1-k)
	var img = k*sprite_get_number(Spr_Slm_Move_Jump)*0.999
	var draw_x = (facing<0) ? x+16 : x-16
	draw_sprite_ext(Spr_Slm_Move_Jump, img, draw_x, y-28-lift, facing, 1, 0, c_white, 1)
}

shader_reset()
