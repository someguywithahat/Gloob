time++
phase_time++

//---- Fading in and out (the game is running underneath) ----
if phase="fade_in"
{
	fade = phase_time/fade_frames
	if phase_time>=fade_frames
	{
		instance_deactivate_all(true) //Freeze the game underneath, like the pause menu
		set_phase("intro")
	}
	exit
}
if phase="fade_back"
{
	fade = 1-phase_time/fade_frames
	if phase_time>=fade_frames
		instance_destroy()
	exit
}
if phase="fade_out" //Still animating while it goes black
{
	fade = phase_time/fade_frames
	if phase_time>=fade_frames
	{
		instance_activate_all()
		set_phase("fade_back")
		exit
	}
}

//Escape skips it
if phase<>"fade_out" and keyboard_check_pressed(vk_escape)
{
	set_phase("fade_out")
	exit
}

//---- The story ----
switch (phase)
{
	case "intro": //The winner waits.  Two friends hop in from the left
		fade = max(0, 1-phase_time/fade_frames)
		var arrived = hop_toward(helper_a, 55, 1.1) + hop_toward(helper_b, 97, 1.3)
		if arrived=2
		{
			arrive_time++
			if arrive_time=1
			{
				set_face(win, UG_FACE.HAPPY, 40)
				set_face(helper_a, UG_FACE.HAPPY, 40)
				set_face(helper_b, UG_FACE.SASSY, 40)
			}
			if arrive_time>50
			{
				set_phase("lift")
				play_snd(snd_slm_yay, 0.5)
			}
		}
		break

	case "lift": //The friends squeeze in underneath and lift the winner up
		var k = min(1, phase_time/40)
		var e = k*k*(3-2*k)
		helper_a.x = lerp(55, win.x-9, e)
		helper_b.x = lerp(97, win.x+9, e)
		win.y = ground_y - 17*e //Sitting on their heads
		if phase_time=20
			set_face(win, UG_FACE.LOVE, -1)
		if phase_time>=55
			set_phase("carry")
		break

	case "carry": //Hop it over to the ball pit
		helper_a.x += carry_speed
		helper_b.x += carry_speed
		win.x += carry_speed
		var b1 = abs(sin(time*0.2))*4
		var b2 = abs(sin(time*0.2+1.6))*4
		helper_a.y = ground_y - b1
		helper_b.y = ground_y - b2
		helper_a.look = "jump"
		helper_b.look = "jump"
		win.y = ground_y - 17 - (b1+b2)/2
		win.ang = sin(time*0.12)*10 //Wobbling up there
		if win.x>=pit_l-12
		{
			set_phase("heave")
			set_face(win, -1, -1)
		}
		break

	case "heave": //Squish down... and throw!
		helper_a.look = "idle"
		helper_b.look = "idle"
		helper_a.y = ground_y
		helper_b.y = ground_y
		var sq = (phase_time<26) ? 0.25*phase_time/26 : lerp(0.25, -0.15, (phase_time-26)/14)
		helper_a.ys = 1-sq
		helper_a.xs = 1+sq*0.6
		helper_b.ys = helper_a.ys
		helper_b.xs = helper_a.xs
		win.ang = lerp(win.ang, 0, 0.2)
		win.y = ground_y - 17 + 22*sq
		if phase_time>=40
		{
			helper_a.xs = 1
			helper_a.ys = 1
			helper_b.xs = 1
			helper_b.ys = 1
			win.row = 1
			fly_to(win, win.slot.x, win.slot.y, 55, 56, -720, true)
			set_face(win, UG_FACE.DIZZY, -1)
			set_face(helper_a, UG_FACE.HAPPY, -1)
			set_face(helper_b, UG_FACE.HAPPY, -1)
			play_snd(snd_slm_woo, 0.6)
			set_phase("throw")
		}
		break

	case "throw": //Wait for it to land, then let it get its bearings
		if win.mode="pit"
		{
			landed_time++
			if landed_time=45
				set_face(win, UG_FACE.LOVE, -1)
			if landed_time>=60
				set_phase("pile")
		}
		break

	case "pile": //Everyone jumps in after it, one at a time.  Friends first, then the rest from both sides
		if phase_time mod jump_in_every=1 and queue_i<array_length(jump_queue)
		{
			var s = jump_queue[queue_i]
			if queue_i>=2
			{
				s.x = (queue_i mod 2=0) ? cam-16 : cam+view_w+16
				s.y = ground_y
			}
			queue_i++
			s.row = s.slot.row
			fly_to(s, s.slot.x, s.slot.y, random_range(40, 55), 46, (s.slot.x>s.x) ? -360 : 360, true)
			set_face(s, UG_FACE.HAPPY, -1)
			play_snd(choose(snd_slm_yay, snd_slm_woo), 0.35, 0.9, 1.25)
		}
		//All in.  Party
		if queue_i>=array_length(jump_queue)
		{
			var all_in = true
			for (var i = 0; i < array_length(slimes); i++)
				if slimes[i].mode<>"pit"
					all_in = false
			if all_in
			{
				set_phase("celebrate")
				play_snd(snd_achievement, 0.7, 1, 1)
				add_confetti(90)
				crown_drop = 0
				set_face(win, -1, -1)
			}
		}
		break

	case "celebrate":
		celebrate_time++
		if random(1)<0.35
			add_confetti(1)
		if crown_drop>=0 and crown_drop<45
		{
			crown_drop++
			if crown_drop=45
			{
				play_snd(snd_boing, 0.5)
				win.squash = 1
			}
		}
		if celebrate_time>prompt_delay and (mouse_check_button_pressed(mb_left) or keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_space))
			set_phase("fade_out")
		break
}

//---- View: follows the winner across the field, then settles on the ball pit ----
var cam_target = view_w
if phase="intro" or phase="lift" or phase="carry"
	cam_target = clamp(win.x-70, 0, view_w)
cam = lerp(cam, cam_target, 0.06)

//---- Slimes ----
var anim_step = 8/game_get_speed(gamespeed_fps) //The slime sprites play at 8 frames a second
for (var i = 0; i < array_length(slimes); i++)
{
	var s = slimes[i]
	if s.mode="off"
		continue
	s.anim += anim_step

	if s.face_time>0
	{
		s.face_time--
		if s.face_time=0
			s.face = -1
	}

	if s.mode="fly"
	{
		var f = s.fly
		f.t++
		var k = min(1, f.t/f.dur)
		s.x = lerp(f.x0, f.x1, k)
		s.y = lerp(f.y0, f.y1, k) - f.h*4*k*(1-k)
		s.ang = f.spin*k
		if k>=1
		{
			s.ang = 0
			s.mode = f.to_pit ? "pit" : "stand"
			s.look = "idle"
			if f.to_pit
			{
				splash(s.x, (s=win) ? 18 : 10)
				s.squash = 1
				play_snd(snd_pop, 0.4, 0.8, 1.2)
				if s<>win
					s.face_time = 40 //Happy for a bit, then back to bouncing around
			}
		}
	}
	else if s.mode="pit"
	{
		if s.jump_t>=0
		{
			//Jumping up out of the balls
			s.jump_t++
			var k = min(1, s.jump_t/s.jump_dur)
			s.y = s.slot.y - s.jump_h*4*k*(1-k)
			s.ang = s.spin*k
			s.look = "jump"
			if k>=1
			{
				s.jump_t = -1
				s.ang = 0
				s.y = s.slot.y
				s.look = "idle"
				s.squash = 1
				s.jump_wait = irandom_range(15, 70)
				splash(s.x, 4)
				if random(1)<0.3
					play_snd(snd_pop, 0.15, 0.8, 1.3)
			}
		}
		else
		{
			s.y = s.slot.y
			s.look = "idle"
			//Celebrating: keep jumping
			if phase="celebrate"
			{
				s.jump_wait--
				if s.jump_wait<=0
				{
					s.jump_t = 0
					s.jump_h = irandom_range(8, 26)
					s.jump_dur = 20 + s.jump_h
					s.spin = (random(1)<0.2) ? choose(-360, 360) : 0
					set_face(s, choose(UG_FACE.HAPPY, UG_FACE.LOVE), s.jump_dur)
				}
			}
		}
	}

	//Squish when landing
	if s.squash>0.01 and phase<>"heave"
	{
		s.squash *= 0.85
		s.xs = 1 + 0.25*s.squash
		s.ys = 1 - 0.25*s.squash
	}
}

//---- Splashing balls ----
for (var i = array_length(flying_balls)-1; i >= 0; i--)
{
	var b = flying_balls[i]
	b.vy += 0.18
	b.x += b.vx
	b.y += b.vy
	//Gone once it drops back into the pit (or off the bottom)
	if (b.vy>0 and b.y>64 and b.x>pit_l and b.x<pit_r) or b.y>view_h+4
		array_delete(flying_balls, i, 1)
}

//---- Confetti ----
for (var i = array_length(confetti)-1; i >= 0; i--)
{
	var c = confetti[i]
	c.t++
	c.x += c.vx + sin(c.t*0.1)*0.3
	c.y += c.vy
	if c.y>view_h+2
		array_delete(confetti, i, 1)
}
