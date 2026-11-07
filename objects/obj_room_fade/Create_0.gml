/*
	Fades the screen to black and back between rooms.  Persistent, so it carries over to the next room.
	Change rooms with scr_room_goto(room) to fade out first.  It also fades in when the game starts.
*/

//---- Settings ----
fade_out_frames = 24  //How long the screen takes to go black
fade_hold_frames = 8  //Stays black this long in the new room (rooms can stutter for a moment while loading)
fade_in_frames = 30   //How long the new room takes to appear
fade_color = c_black

//---- State ----
fade_alpha = 1 //Starts black, so the first room fades in
fade_state = "hold" //"out" going to black, "hold" staying black, "in" coming back, "" nothing
fade_timer = fade_hold_frames*2 //Longer at startup, while the window goes fullscreen
fade_target = noone //Room to go to once it's black
show_debug_message("[fade] created, fading in")
