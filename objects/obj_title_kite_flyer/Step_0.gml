time++
frame += sprite_get_speed(spr_kite_effect)/game_get_speed(gamespeed_fps)

//---- Kite: carried left to right by gusty wind, rising and dipping ----
var t = time+gust_seed
var gust = sin(t*0.017)*0.6 + sin(t*0.043+1.3)*0.4 //About -1 to 1
kite_vx = wind_speed + gust*gust_strength
kx += kite_vx
ky = base_y + sin(t*0.021)*bob_height + sin(t*0.067+0.8)*bob_height*0.3

//---- Slime: dragged along behind on the end of the string ----
//The air holds it back and gravity pulls it down, so the string slants back from the kite.  Gusts yank it forward
svy += slime_gravity
svx -= svx*air_drag
svy -= svy*air_drag*0.5
sx += svx
sy += svy
var pull = 0
var dx = sx-kx
var dy = sy-ky
var d = point_distance(0, 0, dx, dy)
if d>string_len and d>0
{
	//Moving away from the kite is cancelled, so the string drags it along
	sx = kx + dx/d*string_len
	sy = ky + dy/d*string_len
	var out = (svx*dx + svy*dy)/d
	if out>0
	{
		svx -= out*dx/d
		svy -= out*dy/d
		pull = out
	}
}
stretch = lerp(stretch, clamp(pull*0.6, 0, stretch_max), 0.2)

//Hangs from its top, tilted along the string.  Now and then goes head over heels
var hang = point_direction(sx, sy, kx, ky) - 90
if flip_time<0 and random(1)<flip_chance
{
	flip_time = 0
	flip_dir = choose(-1, 1)
}
var flip = 0
if flip_time>=0
{
	flip_time++
	flip = flip_dir*360*min(1, flip_time/flip_frames)
	if flip_time>=flip_frames
		flip_time = -1
}
slime_angle = hang + flip + sin(time*0.25)*6 //Flailing a little

//Kite points its tail down the string, flapping in the gusts
var target = point_direction(kx, ky, sx, sy) - 270 + sin(time*0.15)*(4 + 4*abs(gust))
kite_angle += angle_difference(target, kite_angle)*0.15

//Gone off the right side
if kx>room_width+120 and sx>room_width+60
	instance_destroy()
