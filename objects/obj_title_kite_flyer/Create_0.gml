/*
	Title screen: now and then a slime gets carried across the screen by its kite, hanging on for dear life.
	Started by obj_controller (title_kite_chance).  Blows in from the left, swings around under the kite, and is
	gone off the right side.  Then this removes itself.
	The kite is kinematic (it follows the wind).  The slime is dragged along behind on the end of the string:
	the air holds it back and gravity pulls it down, so it trails behind and below, and stretches when it's yanked.
*/

//---- Settings ----
string_len = 75          //From the kite to the slime
wind_speed = random_range(2.4, 3.2) //How fast it crosses the screen
gust_strength = 1.2      //How much the wind speeds up and slows down
bob_height = random_range(30, 55)   //How far the kite rises and dips
slime_gravity = 0.12
air_drag = 0.06          //How much the air holds the slime back.  More = trails further behind the kite
stretch_max = 0.3        //How much the slime stretches out when the string yanks it
flip_chance = 1/400      //Chance each step the slime goes head over heels
flip_frames = 36
color_index = irandom(sprite_get_number(spr_palette_all)-1) //Random slime color.  The kite matches

//---- State ----
time = 0
gust_seed = random(1000)
base_y = random_range(90, 360) //Height it crosses at (well above the Start Game sign)
kx = -80 //Where the string ties onto the kite
ky = base_y
kite_vx = 0
kite_angle = 0
frame = 0
sx = kx-20 //Where the slime holds on (its top middle)
sy = ky+string_len
svx = 0
svy = 0
slime_angle = 0
flip_time = -1 //Steps into a flip, or -1
flip_dir = 1
stretch = 0 //0 to stretch_max.  Eases toward how hard the string is pulling

//Where the string ties onto the kite: the sprite's origin, unless it was left at the top left corner
attach_x = sprite_get_xoffset(spr_kite_effect)
attach_y = sprite_get_yoffset(spr_kite_effect)
if attach_x=0 and attach_y=0
{
	attach_x = 31
	attach_y = 20
}
slime_hold_x = 16 //Where the slime holds the string, on Slm_All_Base_Expressions (the top of its body, which starts 8 pixels down)
slime_hold_y = 9

/// Draws a sprite turned around a point on it (hold_x, hold_y), with that point landing on (px, py).  Optional scale
draw_turned = function(spr, img, hold_x, hold_y, px, py, ang, xs=1, ys=1)
{
	var ox = (hold_x - sprite_get_xoffset(spr))*xs
	var oy = (hold_y - sprite_get_yoffset(spr))*ys
	var c = dcos(ang)
	var sn = dsin(ang)
	draw_sprite_ext(spr, img, px - (ox*c + oy*sn), py - (-ox*sn + oy*c), xs, ys, ang, c_white, 1)
}
