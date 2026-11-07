time++
frame += sprite_get_speed(spr_kite_effect)/game_get_speed(gamespeed_fps)

//---- Wind: a few slow waves added together make gusts and lulls ----
var t = time+gust_seed
var gust = sin(t*0.011)*0.55 + sin(t*0.029+1.7)*0.35 + sin(t*0.071+0.4)*0.2 //About -1.1 to 1.1
wind_now = wind_base + gust*gust_strength
if kite_state="gust"
	wind_now += blow_away_gust*min(1, gust_time/30)
else if kite_state="free"
	wind_now += blow_away_gust*0.6
wind_now = max(0, wind_now)
wind_x = wind_now

//Let go of (slime went home, got fed, ...)
var held = kite_state<>"free" and instance_exists(owner) and owner.state=UG_STATE.KITE
if kite_state<>"free" and !held
	snap()

//---- Forces: pushed along by the wind, lifted by it, pulled down by gravity ----
var rel = wind_x-vx
vx += rel*drag
vy += gravity_pull - lift*abs(rel)
if kite_state="free"
	vy -= 0.02 //Keeps climbing as it blows away
vx *= damping
vy *= damping
kx += vx
ky += vy

if held
{
	var hx = hand_x()
	var hy = hand_y()

	if kite_state="launch"
	{
		string_len = min(string_len+reel_speed, string_length_max)
		if string_len>=string_length_max
			kite_state = "fly"
	}
	else if kite_state="fly"
	{
		fly_time--
		if fly_time<=0
		{
			kite_state = "gust"
			gust_time = 0
		}
	}
	else if kite_state="gust"
	{
		gust_time++
		if gust_time>=blow_away_build
			snap()
	}

	if kite_state<>"free"
	{
		//Stays above the slime and on the screen
		if ky>hy-12
		{
			ky = hy-12
			vy = min(vy, 0)
		}
		if ky<12
		{
			ky = 12
			vy = max(vy, 0)
		}
		//Slimes are near the right side, so the kite stops at the edge of the screen and rides higher instead
		if kx>room_width-24
		{
			kx = room_width-24
			vx = min(vx, 0)
		}

		//The string: the kite can't get further away than its length.  Pulling outward is cancelled, so it swings around on the end
		var dx = kx-hx
		var dy = ky-hy
		var d = point_distance(0, 0, dx, dy)
		if d>string_len and d>0
		{
			kx = hx + dx/d*string_len
			ky = hy + dy/d*string_len
			var out = (vx*dx + vy*dy)/d
			if out>0
			{
				vx -= out*dx/d
				vy -= out*dy/d
			}
		}

		//Points its tail down the string, rocking a little more in gusty wind
		var target = point_direction(kx, ky, hx, hy) - 270 + sin(time*0.09)*(2 + 3*abs(gust))
		angle += angle_difference(target, angle)*0.12
	}
}

if kite_state="free"
{
	//Tumbling away
	angle += spin
	spin = clamp(spin + random_range(-0.3, 0.3), -8, 8)
	if kx<-100 or ky<-100 or kx>room_width+100
		instance_destroy()
}

x = kx
y = ky
