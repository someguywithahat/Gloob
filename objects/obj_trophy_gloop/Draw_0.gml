//Jumping or standing, twice as big, squished a bit when landing
var spr = (state="air") ? Spr_Slm_Move_Jump : Spr_Slm_Idol
var img = floor(anim) mod sprite_get_number(spr)
var xs = draw_scale*(1+0.2*squash)
var ys = draw_scale*(1-0.2*squash)
//Feet on (x, y).  The sprites are 32x32 with a top left origin, so flip around the middle
var draw_x = (facing>0) ? x-16*xs : x+16*xs
var draw_y = y-32*ys

shader_set(shd_palette_swap)
var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig")
var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap")
var u_color_count = shader_get_uniform(shd_palette_swap, "color_count")
texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0))
texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_all, color_index))
shader_set_uniform_f(u_color_count, 6.0)
draw_sprite_ext(spr, img, draw_x, draw_y, xs*facing, ys, 0, c_white, 1)
shader_reset()
