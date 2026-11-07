/*
	A kite flown by an unused gloop (obj_unusedGloop, UG_STATE.KITE) in the fall.
	The wind blows it up and to the right (same way as the leaves), with gusts and lulls.  The string holds it at a set length, so it swoops
	around on the end of the string the way a real kite does, and sags when the kite drifts in.
	After a while a big gust snaps the string and the kite tumbles away off the screen.  Then this removes itself.

	spr_kite_effect: the string ties on at the sprite's origin.  The kite turns around that point.
*/
owner = noone //The slime holding the string.  Set right after this is made
color_index = 0 //The slime's color.  The kite gets the same palette swap

//---- Settings ----
string_length_max = random_range(140, 190) //How long the string gets
reel_speed = 1.2         //How fast the string lets out at the start
fly_time = irandom_range(60*20, 60*45) //Steps it flies before the big gust takes it
wind_base = 1.5          //Average wind (pixels per step, blowing right)
gust_strength = 1.1      //How much the wind rises and falls.  Lulls below about 0.4 and the kite starts to drop
drag = 0.04              //How strongly the wind pushes the kite along
lift = 0.088             //How strongly the wind lifts the kite
gravity_pull = 0.03
damping = 0.985          //Speed kept each step
blow_away_gust = 2.5     //Extra wind in the gust that snaps the string
blow_away_build = 45     //Steps the big gust builds before the string snaps
string_color = make_colour_rgb(235, 230, 215)
snap_tail = 34           //Length of broken string trailing after the kite once it snaps

//Where the string ties on.  The sprite's origin, unless it was left at the top left corner
attach_x = sprite_get_xoffset(spr_kite_effect)
attach_y = sprite_get_yoffset(spr_kite_effect)
if attach_x=0 and attach_y=0
{
	attach_x = 31
	attach_y = 20
}

//---- State ----
kite_state = "launch" //"launch" letting the string out, "fly", "gust" the big gust building, "free" blown away
string_len = 16
kx = x //Where the string ties onto the kite
ky = y
vx = 0
vy = 0
angle = 0
spin = 0
time = 0
gust_time = 0
gust_seed = random(1000) //So two kites would not sway the same
frame = 0
wind_x = 0
wind_now = wind_base //Wind speed this step (Draw uses it for the string sag)
image_speed = 0

/// Where the slime holds the string
hand_x = function()
{
	return owner.x+24;
}
hand_y = function()
{
	return owner.y+14;
}

/// The string snaps.  The kite tumbles away and the slime is sad
snap = function()
{
	if kite_state="free"
		return;
	kite_state = "free"
	spin = random_range(2, 5)*choose(-1, 1)
	if instance_exists(owner) and owner.state=UG_STATE.KITE
	{
		//audio_play_sound(snd_slm_confused, 1, false)
		with(owner)
			kite_blew_away()
	}
}
