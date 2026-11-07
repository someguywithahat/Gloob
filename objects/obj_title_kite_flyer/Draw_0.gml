//String, pulled almost straight by the slime's weight, with a slight bow blown back by the wind
draw_set_color(make_colour_rgb(235, 230, 215))
var mx = (kx+sx)/2 - 3
var my = (ky+sy)/2 + 3
draw_line(kx, ky, mx, my)
draw_line(mx, my, sx, sy)
draw_set_color(c_white)

//The slime and the kite get the same palette swap (see obj_unusedGloop Draw)
shader_set(shd_palette_swap)
var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig")
var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap")
var u_color_count  = shader_get_uniform(shd_palette_swap, "color_count")
texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0))
texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_all, color_index))
shader_set_uniform_f(u_color_count, 6.0)

//Kite, turned around the spot the string ties on
draw_turned(spr_kite_effect, floor(frame) mod sprite_get_number(spr_kite_effect), attach_x, attach_y, kx, ky, kite_angle)

//Slime holding on.  Dizzy, with a scared look now and then
var face = ((time div 40) mod 3=2) ? UG_FACE.SAD : UG_FACE.DIZZY
//Stretched out along the string when it's yanked (and a little thinner)
draw_turned(Slm_All_Base_Expressions, face, slime_hold_x, slime_hold_y, sx, sy, slime_angle, 1-stretch*0.4, 1+stretch)

shader_reset()
