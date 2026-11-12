/*
	Dewdrop, the blue slime, on the beach in the rainy fishing room (rm_fishingLeft).
	Sail the boat up close and click him: the rain gets heavier (obj_fishroom_rain), he opens his mouth to drink it
	(Spr_Slm_Sleep frames 0-8, holding 8 while he drinks) and grows to 3 times his size.  Then the rain eases off,
	and he stays big, idling happily.
	The instance's x, y is the top left of his normal 32x32 size.  He grows up from his feet.
*/

//---- Settings ----
color_index = global.BLUE
near_distance = 120     //The boat has to be this close (middle to middle) for a click to wake him
wake_frames = 40        //Awake for a moment before he opens his mouth to the rain
open_last_frame = 8     //Spr_Slm_Sleep frames 0 to this: opening his mouth
drink_frames = 300      //Drinking the rain and growing (5 seconds)
grow_to = 3             //Times his size when he's done
close_frames = 50       //A moment after he's full, before he starts idling happily
gulp_every = 36         //A little squish this often while he drinks
mouth_drops_every = 3   //Extra raindrops falling right into his mouth, one this often
full_face = 17          //Once he's full: the fat face (Slm_All_Base_Expressions frame)

//---- State ----
image_speed = 0 //Animated by hand
state = "sleep" //"sleep", "wake", "open", "drink", "close", "happy"
state_time = 0
anim = 20 //Already asleep: starts in the snoring part of the sleep animation
size = 1   //1 normal, grow_to when he's done
glow = 0   //0-1
squish = 0 //A little bounce on each gulp

feet_x = x+16 //He grows up from here
feet_y = y+32

set_state = function(new_state)
{
	state = new_state
	state_time = 0
	anim = 0
}

/// Where his mouth is right now (rain falls in here while he drinks)
mouth_x = function() { return feet_x }
mouth_y = function() { return feet_y - 10*size }

/// Makes the rain heavier (1) or back to normal (0)
set_rain = function(amount)
{
	with(obj_fishroom_rain)
		boost_target = amount
}
