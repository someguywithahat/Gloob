/*
	All the fish for the fishing minigame, in one place.

	5 groups of 8 fish.  Each fish:
		name      -- shown when you catch it
		sprite    -- 24x24 swimming animation
		accel     -- how quickly it speeds up (pixels per step, per step)
		decel     -- how quickly it slows down
		max_speed -- top speed in pixels per step (the player's circle tops out at 4)
		move      -- how it swims.  One of FISH_MOVE below
		start_bar -- how full the catch bar starts, 0-1 (0.3 = 30%)
		bar_grow  -- how fast the bar fills while the fish is caught, in bars per second (0.25 = a quarter of the bar each second)
		bar_shrink-- how fast the bar drains while it isn't, in bars per second

	To change a fish, edit its row.  To add a movement type, add it to FISH_MOVE and give it a swim
	function in obj_fishing_minigame's Create event.
*/

enum FISH_MOVE {
	CONSTANT,   //Moving constantly: always swimming toward a random spot, picking a new one every so often
	DASH_WAIT,  //Dash and wait: dashes to a spot, stops for a moment, dashes again
	WALKING,    //Walking: only moves left and right along the bottom of the pond
	FLOAT_UP,   //Floats up to the top of the pond and stays there
	ZIGZAG_UP_DOWN,    //Darts rapidly up and down while slowly drifting left and right
	ZIGZAG_LEFT_RIGHT, //Darts rapidly left and right while slowly drifting up and down
	WOBBLE,     //Moves constantly, rocking back and forth in rapid mini rotations
	FLY_TOP,    //Flies back and forth across the top like a bird, bobbing as it flaps
	ORBIT,      //Circles around the middle of the pond
	GOLF,       //Sinks to the bottom, then shoots up and bounces off the walls like a hit golf ball
	FLEE,       //Runs away from the player's circle when it gets close
	CHARGE,     //Winds up, then rushes straight at the circle and overshoots right through it
	FAKE_OUT,   //Heads somewhere, stops halfway and doubles back
	GRID_HOP,   //Hops 1-3 grid spaces at a time, straight or diagonal, like a slime on the game board
	HOLE_HOP,   //Dives into a hole and pops out somewhere else.  The bar doesn't change while it's hidden
	MIRROR,     //Moves opposite to the circle.  Slips away if the circle sits in the middle
	WIND,       //Dashes and waits, and its gusts push the player's circle around
	PONG,       //Bounced left and right between two paddles, like Pong
	STICK_TO_CIRCLE, //Chases the middle of the player's circle.  Backwards catch: the bar fills while it's OUTSIDE the circle
	BOWLING,    //Bowls up the pond through a rack of pins and off the top, then comes back at the bottom.  The bar holds while it's gone
	GROW,       //Switches between tiny and fat.  Fat is drawn twice as big and swims at half speed.  Uses the sprite's fat (0, 5) and tiny (2, 3) frames
	WRAP        //Swims off one side of the pond and comes back in the opposite side
}

/// One fish row
function fish_def(name, sprite, accel, decel, max_speed, move, start_bar, bar_grow, bar_shrink){
	return { name: name, sprite: sprite, accel: accel, decel: decel, max_speed: max_speed, move: move, start_bar: start_bar, bar_grow: bar_grow, bar_shrink: bar_shrink }
}

function scr_fish_data(){
	//                name         sprite              accel decel speed  move                       start_bar  grow  shrink
	global.FISH_GROUPS = [
		//Group 0
		[
			fish_def("Gold",      Spr_Fish_Gold,      0.3,  0.3,  2.5,   FISH_MOVE.CONSTANT,             0.3,      0.25, 0.2),
			fish_def("Golden",    Spr_Fish_Golden,    0.3,  0.3,  2.5,   FISH_MOVE.CONSTANT,             0.3,      0.25, 0.2),
			fish_def("Goal",      Spr_Fish_Goal,      0.3,  0.3,  4.0,   FISH_MOVE.PONG,                 0.3,      0.25, 0.2),
			fish_def("Marigold",  Spr_Fish_Marigold,  0.3,  0.3,  2.5,   FISH_MOVE.CONSTANT,             0.3,      0.25, 0.2),
			fish_def("Fools",     Spr_Fish_Fools,     0.3,  0.3,  3.5,   FISH_MOVE.FAKE_OUT,             0.3,      0.25, 0.2),
			fish_def("Sold",      Spr_Fish_Sold,      0.3,  0.3,  2.5,   FISH_MOVE.CONSTANT,             0.3,      0.25, 0.2),
			fish_def("Stoled",    Spr_Fish_Stoled,    0.3,  0.3,  2.5,   FISH_MOVE.FLEE,                 0.3,      0.25, 0.2),
			fish_def("Guilded",   Spr_Fish_Guilded,   0.15,  0.15,  100,   FISH_MOVE.CONSTANT,             0.3,      0.25, 0.2)
		],
		//Group 1
		[
			fish_def("Bold",      Spr_Fish_Bold,      0.4,  0.4,  3.5,   FISH_MOVE.CHARGE,               0.3,      0.25, 0.2),
			fish_def("LoLed",     Spr_Fish_LoLed,     0.4,  0.4,  2.5,   FISH_MOVE.STICK_TO_CIRCLE,      0.9,      0.25, 0.2),
			fish_def("Hold",      Spr_Fish_Hold,      0.4,  0.4,  3.5,   FISH_MOVE.CONSTANT,             0.3,      0.25, 0.2),
			fish_def("Holed",     Spr_Fish_Holed,     0.4,  0.4,  3.5,   FISH_MOVE.HOLE_HOP,             0.3,      0.25, 0.2),
			fish_def("Wholed",    Spr_Fish_Wholed,    0.4,  0.4,  3.0,   FISH_MOVE.WRAP    ,             0.3,      0.25, 0.15),
			fish_def("Fold",      Spr_Fish_Fold,      0.4,  0.4,  3.5,   FISH_MOVE.ZIGZAG_LEFT_RIGHT,    0.3,      0.25, 0.2),
			fish_def("Rolled",    Spr_Fish_Rolled,    0.4,  0.4,  3.5,   FISH_MOVE.ZIGZAG_UP_DOWN,       0.3,      0.25, 0.2),
			fish_def("Grow",      Spr_Fish_Grow,      0.4,  0.4,  3.5,   FISH_MOVE.GROW,                 0.1,      0.25, 0.2)
		],
		//Group 2
		[
			fish_def("Bowed",     Spr_Fish_Bowed,     0.4,  0.4,  3.5,   FISH_MOVE.CONSTANT,             0.3,      0.25, 0.2),
			fish_def("Mold",      Spr_Fish_Mold,      0.4,  0.4,  3.5,   FISH_MOVE.CONSTANT,             0.3,      0.25, 0.2),
			fish_def("Go",        Spr_Fish_Go,        3.0,  3.0,  8.0,   FISH_MOVE.DASH_WAIT,            0.3,      0.25, 0.2),
			fish_def("Slow",      Spr_Fish_Slow,      0.1,  0.1,  1.5,   FISH_MOVE.CONSTANT,             0.3,      0.25, 0.2),
			fish_def("Halt",      Spr_Fish_Halt,      0.4,  0.4,  3.5,   FISH_MOVE.DASH_WAIT,            0.3,      0.25, 0.2),
			fish_def("Poled",     Spr_Fish_Poled,     0.4,  0.4,  3.5,   FISH_MOVE.CONSTANT,             0.3,      0.25, 0.2),
			fish_def("Golf",      Spr_Fish_Golf,      0.4,  0.4,  3.5,   FISH_MOVE.GOLF,                 0.3,      0.25, 0.2),
			fish_def("Bowled",    Spr_Fish_Bowled,    0.4,  0.4,  3.5,   FISH_MOVE.BOWLING,              0.3,      0.25, 0.2)
		],
		//Group 3
		[
			fish_def("Goat",      Spr_Fish_Goat,      0.4,  0.4,  3.5,   FISH_MOVE.CONSTANT,             0.3,      0.25, 0.2),
			fish_def("Colt",      Spr_Fish_Colt,      0.1,  0.1,  3.5,   FISH_MOVE.WALKING,              0.3,      0.25, 0.2),
			fish_def("Old",       Spr_Fish_Old,       1.0,  1.0,  1.0,   FISH_MOVE.CONSTANT,             0.3,      0.25, 0.2),
			fish_def("Finch",     Spr_Fish_Finch,     0.4,  0.4,  3.5,   FISH_MOVE.FLY_TOP,              0.3,      0.25, 0.2),
			fish_def("Gloop",     Spr_Fish_Gloop,     0.4,  0.4,  3.5,   FISH_MOVE.GRID_HOP,             0.3,      0.25, 0.2),
			fish_def("Ghoul",     Spr_Fish_Ghoul,     0.4,  0.4,  3.5,   FISH_MOVE.FLOAT_UP,             0.3,      0.25, 0.2),
			fish_def("Soul",      Spr_Fish_Soul,      0.4,  0.4,  3.5,   FISH_MOVE.CONSTANT,             0.3,      0.25, 0.2),
			fish_def("God",       Spr_Fish_God,       0.4,  0.4,  3.5,   FISH_MOVE.MIRROR,               0.3,      0.25, 0.2)
		],
		//Group 4
		[
			fish_def("Coal",      Spr_Fish_Coal,      0.5,  0.4,  4.5,   FISH_MOVE.DASH_WAIT,            0.3,      0.25, 0.2),
			fish_def("Scalled",   Spr_Fish_Scalled,   0.6,  0.4,  4.5,   FISH_MOVE.DASH_WAIT,            0.3,      0.25, 0.2),
			fish_def("Cold",      Spr_Fish_Cold,      0.7,  0.4,  4.5,   FISH_MOVE.DASH_WAIT,            0.3,      0.25, 0.2),
			fish_def("Bowl",      Spr_Fish_Bowl,      0.8,  0.4,  4.5,   FISH_MOVE.DASH_WAIT,            0.3,      0.25, 0.2),
			fish_def("Volt",      Spr_Fish_Volt,      0.9,  0.4,  4.5,   FISH_MOVE.DASH_WAIT,            0.3,      0.25, 0.2),
			fish_def("Gail",      Spr_Fish_Gail,      0.9,  0.1,  5.5,   FISH_MOVE.WIND,                 0.3,      0.25, 0.2),
			fish_def("Glow",      Spr_Fish_Glow,      0.9,  0.4,  4.5,   FISH_MOVE.DASH_WAIT,            0.3,      0.25, 0.2),
			fish_def("Globe",     Spr_Fish_Globe,     0.9,  0.4,  4.5,   FISH_MOVE.ORBIT,                0.3,      0.25, 0.2)
		]
	]
}

/// A random fish from one group
function scr_fish_random(group){
	var fish_list = global.FISH_GROUPS[group]
	return fish_list[irandom(array_length(fish_list)-1)]
}

/// A random fish from any group
function scr_fish_random_any(){
	return scr_fish_random(irandom(array_length(global.FISH_GROUPS)-1))
}
