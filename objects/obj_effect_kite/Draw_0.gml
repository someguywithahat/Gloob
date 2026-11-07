//---- String ----
draw_set_color(string_color)
var segments = 16
if kite_state<>"free" and instance_exists(owner)
{
	//From the slime to the kite, sagging down in the middle.  Pulled tight it hardly sags.  Slack (or in a lull) it droops
	var hx = hand_x()
	var hy = hand_y()
	var d = point_distance(hx, hy, kx, ky)
	var tight = clamp((d-(string_len-8))/8, 0, 1) * clamp(wind_now/wind_base, 0, 1)
	var sag = lerp(20, 3, tight) * min(1, d/120)
	var mx = (hx+kx)/2 + 4 //Bows a little downwind too
	var my = (hy+ky)/2 + sag*2 //Control point.  The curve goes halfway there
	var px = hx
	var py = hy
	for (var i = 1; i <= segments; i++)
	{
		var s = i/segments
		var qx = sqr(1-s)*hx + 2*(1-s)*s*mx + sqr(s)*kx
		var qy = sqr(1-s)*hy + 2*(1-s)*s*my + sqr(s)*ky
		draw_line(px, py, qx, qy)
		px = qx
		py = qy
	}
}
else
{
	//Snapped: a loose end trails behind the kite, flapping
	var px = kx
	var py = ky
	for (var i = 1; i <= segments; i++)
	{
		var s = i/segments
		var qx = kx - s*snap_tail*0.5 + sin(time*0.3 - s*6)*3*s
		var qy = ky + s*snap_tail
		draw_line(px, py, qx, qy)
		px = qx
		py = qy
	}
}
draw_set_color(c_white)

//---- Kite, turned around the spot the string ties on ----
var ox = attach_x - sprite_get_xoffset(spr_kite_effect)
var oy = attach_y - sprite_get_yoffset(spr_kite_effect)
var c = dcos(angle)
var sn = dsin(angle)
var rx = ox*c + oy*sn
var ry = -ox*sn + oy*c
var n = sprite_get_number(spr_kite_effect)

//Same palette swap as the slime flying it (see obj_unusedGloop Draw)
shader_set(shd_palette_swap)
var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig")
var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap")
var u_color_count  = shader_get_uniform(shd_palette_swap, "color_count")
texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0))
texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_all, color_index))
shader_set_uniform_f(u_color_count, 6.0)
draw_sprite_ext(spr_kite_effect, floor(frame) mod n, kx-rx, ky-ry, 1, 1, angle, c_white, 1)
shader_reset()
