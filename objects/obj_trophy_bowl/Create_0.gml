/*
	A fish bowl on the trophy room shelves (rm_fishingTrophy).  Each one belongs to one fish.
	It's empty until that fish has been caught, then shows the fish swimming in its bowl (Spr_Bowl_<fish name>),
	like the trophy clams in the fishing rooms.  Catches are saved (scr_fish_mark_caught).

	The object's sprite is the empty bowl, so it looks the same in the room editor as in the game.
	Size it with the instance's scale (the shelves use 2x).

	Set in the instance's creation code:
		fish_name -- the fish's name, as in scr_fish_data (and the end of its Spr_Bowl_ sprite)
*/

//---- Settings ----
empty_drop = 6   //Spr_Empty_Bowl's base sits this many pixels higher than the fish bowls' (sprite pixels), so the fish bowl is drawn this much higher

fish_name = "" //Set in creation code
bowl_sprite = -1 //Looked up on the first step, after creation code has run
caught = false
frame = random(100) //Starts somewhere random in the animation, so the fish don't all swim in sync (the frame wraps around)
depth = 100 //Same as the room's Planning layer, where the bowls used to be.  Gloop hops in front of them
