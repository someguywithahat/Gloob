/*
	Victory scene: for making it through all four seasons.
	(For now it only starts from the debug menu: "Victory Scene" in obj_weather_controller)

	Two friends lift up the winner (the slime with the most points), carry it to a giant ball pit and throw
	it in.  Then everyone jumps in after it, "Congratulations!" shows, and they all keep celebrating.
	Click (or Escape) to go back to the game.

	Everything is 8 times bigger.  The scene is drawn small on a surface (1 pixel = 1 sprite pixel) and then
	scaled up, so the slimes, balls and confetti all share the same chunky pixels.
	The scene is two screens wide: the field on the left, the ball pit on the right.  The view pans across.
	The game underneath is frozen while it plays (deactivated, like the pause menu).
*/

//---- Settings ----
scene_scale = 8
fade_frames = 30
prompt_delay = 150   //Steps of celebrating before "Click to keep playing" shows
carry_speed = 1.1    //How fast the friends carry the winner to the pit (sprite pixels a step)
jump_in_every = 22   //Steps between each slime jumping into the pit

//---- Size of the small scene (sprite pixels) ----
view_w = ceil(room_width/scene_scale)   //171
view_h = ceil(room_height/scene_scale)  //96
ground_y = 84
surf = -1
cam = 5 //Left edge of the view

//---- The ball pit ----
pit_l = 200
pit_r = 330
pit_x = (pit_l+pit_r)/2
pit_wall_y = 70 //Top of the tub's front wall
back_y = 66     //Where back row slimes sit (their bottom)
front_y = 77    //Where front row slimes sit
front_cut = 68  //Balls this low get drawn again over the front row, so it sits in the balls too
ball_colors = [
	make_colour_rgb(235, 70, 70),
	make_colour_rgb(250, 210, 60),
	make_colour_rgb(70, 140, 240),
	make_colour_rgb(90, 200, 90),
	make_colour_rgb(245, 120, 190),
	make_colour_rgb(250, 150, 50),
]
balls = [] //The heap in the pit: rounded in the middle
for (var bx = pit_l+1; bx <= pit_r-4; bx += 3)
{
	var top = round(62 - 3*sin(pi*(bx-pit_l)/(pit_r-pit_l)))
	for (var by = top; by <= 72; by += 3)
		array_push(balls, { x: bx+irandom(1), y: by+irandom(1)-1, c: ball_colors[irandom(array_length(ball_colors)-1)] })
}
array_sort(balls, function(a, b) { return a.y-b.y }) //Lower balls draw in front
flying_balls = [] //Splashes
confetti = []

//Clouds and decorations
clouds = []
repeat (7)
	array_push(clouds, { x: random(view_w*1.5), y: irandom_range(8, 34), w: irandom_range(12, 24) })

//---- Who's in it ----
//The winner: the slime with the most points
win_color = irandom(7)
win_acc = 0
var best = -1
with(obj_gloop_score)
{
	if gloop_score>best
	{
		best = gloop_score
		other.win_color = gloop_color_index
		other.win_acc = instance_exists(gloop) ? gloop.has_accessory : 0
	}
}
win_color = clamp(win_color, 0, 7)

//The winner's accessory (scr_get_accessory sets sa_idol, sa_jump, ...)
has_accessory = win_acc
sa_idol = noone
sa_jump = noone
if has_accessory>0
	scr_get_accessory()

//The two friends are unused gloops when there are some.  Everyone else fills in the other colors
var unused = []
with(obj_unusedGloop)
	if gloop_color_index<>other.win_color and !array_contains(unused, gloop_color_index)
		array_push(unused, gloop_color_index)
var others = []
for (var i = 0; i < 8; i++)
	if i<>win_color and !array_contains(unused, i)
		array_push(others, i)
shuffle = function(arr)
{
	for (var i = array_length(arr)-1; i > 0; i--)
	{
		var j = irandom(i)
		var t = arr[i]
		arr[i] = arr[j]
		arr[j] = t
	}
	return arr;
}
unused = shuffle(unused)
others = shuffle(others)
var colors = [] //Friends first
for (var i = 0; i < array_length(unused); i++)
	array_push(colors, unused[i])
for (var i = 0; i < array_length(others); i++)
	array_push(colors, others[i])

make_slime = function(col, xx, yy)
{
	return {
		col: col, x: xx, y: yy,       //y is the slime's bottom
		ang: 0, xs: 1, ys: 1, squash: 0,
		look: "idle", anim: random(8), //"idle" or "jump"
		face: -1, face_time: -1,       //An expression (UG_FACE) instead of the animation
		mode: "off",                   //"off" (not in the scene yet), "stand", "fly", "pit"
		row: 2, slot: undefined, fly: undefined,
		jump_t: -1, jump_wait: irandom_range(5, 60), jump_h: 0, jump_dur: 1, spin: 0,
		acc: false, crown: false,
	}
}

//Pit spots.  The winner gets the middle of the front row
var slots = [
	{ x: 233, y: front_y, row: 1 }, { x: 297, y: front_y, row: 1 },
	{ x: 210, y: back_y, row: 0 }, { x: 238, y: back_y, row: 0 }, { x: 265, y: back_y, row: 0 },
	{ x: 292, y: back_y, row: 0 }, { x: 320, y: back_y, row: 0 },
]
slots = shuffle(slots)

helper_a = make_slime(colors[0], -20, ground_y)
helper_b = make_slime(colors[1], -48, ground_y)
win = make_slime(win_color, 75, ground_y)
win.acc = has_accessory>0 and sprite_exists(sa_idol)
win.crown = true //Shows once it drops on (crown_drop)
win.slot = { x: pit_x, y: front_y, row: 1 }
helper_a.mode = "stand"
helper_b.mode = "stand"
win.mode = "stand"

slimes = [helper_a, helper_b, win] //Draw order: the winner rides on top of the friends
jump_queue = [helper_a, helper_b]
for (var i = 0; i < 7; i++)
{
	if i>=2
	{
		var s = make_slime(colors[i], 0, ground_y)
		array_push(slimes, s)
		array_push(jump_queue, s)
	}
	jump_queue[i].slot = slots[i]
}
queue_i = 0

//---- State ----
phase = "fade_in"
phase_time = 0
time = 0
fade = 0         //Black over everything, 0 to 1
arrive_time = 0  //Steps since both friends got to the winner
landed_time = -1 //Steps since the winner landed in the pit
crown_drop = -1  //Steps since the crown started dropping on the winner, -1 before
celebrate_time = 0

set_phase = function(p)
{
	phase = p
	phase_time = 0
}

set_face = function(s, f, t)
{
	s.face = f
	s.face_time = t
}

play_snd = function(snd, vol, pitch_lo=0.95, pitch_hi=1.05)
{
	var s = audio_play_sound(snd, 1, false)
	audio_sound_gain(s, vol, 0)
	audio_sound_pitch(s, random_range(pitch_lo, pitch_hi))
}

/// Hops a slime along the ground toward tx.  Returns 1 once it's there
hop_toward = function(s, tx, spd)
{
	if abs(s.x-tx)<=spd
	{
		s.x = tx
		s.y = ground_y
		s.look = "idle"
		return 1;
	}
	s.x += (tx>s.x) ? spd : -spd
	s.y = ground_y - abs(sin(s.x*0.25))*4
	s.look = "jump"
	return 0;
}

/// Sends a slime flying in an arc to (x1, y1), turning `spin` degrees on the way
fly_to = function(s, x1, y1, h, dur, spin, to_pit)
{
	s.fly = { x0: s.x, y0: s.y, x1: x1, y1: y1, h: h, dur: dur, t: 0, spin: spin, to_pit: to_pit }
	s.mode = "fly"
	s.look = "jump"
}

/// Balls flying up out of the pit
splash = function(xx, n)
{
	repeat (n)
		array_push(flying_balls, { x: xx+random_range(-7, 7), y: 62, vx: random_range(-1.4, 1.4), vy: random_range(-3.4, -1.6),
			c: ball_colors[irandom(array_length(ball_colors)-1)] })
}

/// Confetti falling from the top of the view
add_confetti = function(n)
{
	repeat (n)
		array_push(confetti, { x: cam+random(view_w), y: random_range(-30, -2), vx: random_range(-0.3, 0.3), vy: random_range(0.3, 0.8),
			t: irandom(100), c: make_colour_hsv(irandom(255), 170, 255) })
}

/// Which layer a slime draws in: 0 back row, 1 front row (both sit in the balls), 2 out of the pit
slime_layer = function(s)
{
	if s.mode="pit"
		return s.row;
	if s.mode="fly" and s.fly.to_pit and s.fly.t>s.fly.dur*0.6
		return s.row;
	return 2;
}

//---- Drawing ----
u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig")
u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap")
u_color_count = shader_get_uniform(shd_palette_swap, "color_count")

/// Draws a sprite turned around a point on it (hold_x, hold_y), with that point landing on (px, py).  Optional scale
draw_turned = function(spr, img, hold_x, hold_y, px, py, ang, xs=1, ys=1)
{
	var ox = (hold_x - sprite_get_xoffset(spr))*xs
	var oy = (hold_y - sprite_get_yoffset(spr))*ys
	var c = dcos(ang)
	var sn = dsin(ang)
	draw_sprite_ext(spr, img, px - (ox*c + oy*sn), py - (-ox*sn + oy*c), xs, ys, ang, c_white, 1)
}

/// One slime, with its accessory and crown.  The palette shader must already be on
draw_slime = function(s, cx)
{
	var spr = Spr_Slm_Idol
	var acc_spr = sa_idol
	var crown_spr = Spr_Slm_Crown_Idol
	var img = floor(s.anim) mod sprite_get_number(Spr_Slm_Idol)
	if s.face>=0
	{
		spr = Slm_All_Base_Expressions
		img = s.face
	}
	else if s.look="jump"
	{
		spr = Spr_Slm_Move_Jump
		acc_spr = sa_jump
		crown_spr = Spr_Slm_Crown_Move_Jump
		img = floor(s.anim) mod sprite_get_number(Spr_Slm_Move_Jump)
	}
	var over_img = (s.face>=0) ? 0 : img //Accessories and the crown match the animation frame

	texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_all, s.col))
	//Turns around the middle of its body (16, 20).  Its bottom is at s.y
	var px = s.x - cx
	var py = s.y - 11*s.ys
	if s.ang=0
	{
		px = round(px)
		py = round(py)
	}
	draw_turned(spr, img, 16, 20, px, py, s.ang, s.xs, s.ys)
	if s.acc and acc_spr<>noone and sprite_exists(acc_spr)
		draw_turned(acc_spr, over_img, 16, 20, px, py, s.ang, s.xs, s.ys)
	if s.crown and crown_drop>=0
	{
		//Drops from the sky, then stays on
		var k = min(1, crown_drop/45)
		var drop = -70*(1-k)*(1-k)
		draw_turned(crown_spr, over_img, 16, 20, px, round(py+drop), s.ang, s.xs, s.ys)
	}
}

/// Every slime in one layer (see slime_layer)
draw_slime_layer = function(layer_num, cx)
{
	shader_set(shd_palette_swap)
	texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0))
	shader_set_uniform_f(u_color_count, 6.0)
	for (var i = 0; i < array_length(slimes); i++)
	{
		var s = slimes[i]
		if s.mode<>"off" and slime_layer(s)=layer_num
			draw_slime(s, cx)
	}
	shader_reset()
}

/// A little ball: a rounded 4x4 with a shine
draw_ball = function(bx, by, c)
{
	draw_set_colour(c)
	draw_rectangle(bx, by+1, bx+3, by+2, false)
	draw_rectangle(bx+1, by, bx+2, by+3, false)
	draw_set_colour(merge_colour(c, c_white, 0.6))
	draw_point(bx+1, by+1)
}

/// Pit balls lower than min_y
draw_pit_balls = function(cx, min_y)
{
	for (var i = 0; i < array_length(balls); i++)
	{
		var b = balls[i]
		if b.y>=min_y
			draw_ball(b.x-cx, b.y, b.c)
	}
}
