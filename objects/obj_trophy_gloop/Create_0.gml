/*
	Gloop in the trophy room, twice as big like the fish bowls.  Jumps between the shelves (obj_trophy_room
	handles the clicks).  The shelves only catch him on the way down, so he can jump up through them.
*/

//---- Settings ----
draw_scale = 2
grav = 0.45
color_index = global.GREEN //The slime from the boat
max_side_speed = 6

//---- State ----
state = "air" //"air" or "stand"
leaving = false //Jumping off the map: lands on nothing, and is gone once he's off it
vx = 0
vy = 0
target_y = -1 //The shelf he's aiming for (its y), or -1 for whichever one he comes down on
facing = 1
anim = 0
squash = 0
rest = 0 //Steps after landing before the next hop (so holding the button doesn't skip the landing)
land_rest = 8

//---- Bowl reactions ----
//Standing on a bowl (with its fish caught) for react_time steps, Gloop reacts to some of the fish:
//	bowl_faces  -- fish name: the face he makes while he stays there
//	click_sound -- fish name: the sound clicking that bowl plays (instead of hopping)
react_time = 30 //Half a second
//(Slm_All_Base_Expressions frames: UG_FACE.ANNOYED (2) looks surprised, UG_FACE.SASSY (5) sticks its tongue out,
//15 is the big puppy-dog eyes)
bowl_faces = {
	Ghoul: UG_FACE.SAD,
	Rolled: UG_FACE.DIZZY,
	LoLed: UG_FACE.ANGRY,
	Bowed: UG_FACE.LOVE,      //Heart eyes
	Mold: UG_FACE.SASSY,      //Tongue out
	Guilded: UG_FACE.HAPPY,
	Sold: UG_FACE.SAD,
	Soul: 15,                 //Puppy-dog eyes
	Colt: UG_FACE.SASSY,      //Tongue out
	Volt: UG_FACE.ANNOYED,    //Surprised
	Marigold: 15,             //Puppy-dog eyes
	Grow: [8, 9],             //Small, then fat, back and forth
	Hold: 0,                  //Just his plain face
	Bowled: UG_FACE.DIZZY,
	God: UG_FACE.ANNOYED,     //Surprised
	Finch: UG_FACE.HAPPY,
	Goat: UG_FACE.HAPPY,
	Stoled: UG_FACE.ANGRY,
	Golf: UG_FACE.HAPPY,
	Goal: UG_FACE.HAPPY,
	Cold: 15,                 //Puppy-dog eyes (and shivering, below)
	Scalled: 16,              //Sweating
}
//Fish that make him shiver (vibrate side to side) while he makes his face
bowl_shivers = {
	Cold: true,
}
//Shivering comes in bursts: a shudder, then little trembles, then a short pause.  All in screen pixels
shiver_amount = 1      //How far the little trembles go
shudder_amount = 2     //The bigger shudder at the start of each burst
shudder_time = 6       //Steps the shudder lasts
shiver_burst = 45      //Steps each burst lasts
shiver_pause = 25      //Steps between bursts
shiver_hunch = 0.06    //Huddled up while he's cold: this much shorter (and a bit narrower)
shiver_x = 0           //The current shake (picked in Step)
shiver_y = 0
face_cycle_time = 30 //Faces given as a list switch to the next one this often (steps)
//Fish name: a sound that plays by itself once he's been on that bowl for react_time (once each time he stands there)
bowl_sounds = {
	Gloop: snd_slm_confused, //"Huh?"
}
click_sounds = {
}
bowl_under = noone //The bowl he's standing on
bowl_time = 0 //Steps he's been standing on it

/// True once he's been standing on this bowl long enough to react to it
reacting_to = function(bowl)
{
	return bowl<>noone and bowl=bowl_under and bowl_time>=react_time
}

/// The face he's making for the bowl he's on, or -1
bowl_face = function()
{
	if bowl_under<>noone and bowl_time>=react_time and variable_struct_exists(bowl_faces, bowl_under.fish_name)
	{
		var face = bowl_faces[$ bowl_under.fish_name]
		//A list of faces: takes turns
		if is_array(face)
			return face[((bowl_time-react_time) div face_cycle_time) mod array_length(face)];
		return face;
	}
	return -1;
}

var room_ctrl = instance_find(obj_trophy_room, 0)
shelf_ys = room_ctrl.shelf_ys
shelf_left = room_ctrl.shelf_left
shelf_right = room_ctrl.shelf_right

play_jump = function()
{
	var snd = audio_play_sound(snd_slime_move, 1, false)
	audio_sound_pitch(snd, random_range(0.9, 1.15))
}

/// Jumps in an arc that comes down on (tx, ty).  rise is how far above the higher end the arc goes
jump_to = function(tx, ty, rise)
{
	var arc_top = min(y, ty) - rise
	vy = -sqrt(2*grav*(y-arc_top))
	var time_up = -vy/grav
	var time_down = sqrt(2*(ty-arc_top)/grav)
	vx = (tx-x)/(time_up+time_down)
	target_y = ty
	state = "air"
	if abs(vx)>0.2
		facing = sign(vx)
	play_jump()
}

/// Jumps toward a spot that isn't a shelf: the higher the click, the higher the jump.  Lands on whatever shelf
jump_toward = function(px, py)
{
	vx = clamp((px-x)/35, -max_side_speed, max_side_speed)
	vy = -clamp(6 + (y-py)/25, 4, 13)
	target_y = -1
	state = "air"
	if abs(vx)>0.2
		facing = sign(vx)
	play_jump()
}

/// Jumps off the map, out the left (side -1) or right (side 1) of the room
leave = function(side)
{
	leaving = true
	target_y = -1
	state = "air"
	vx = side*9
	vy = -9
	facing = side
	play_jump()
}
