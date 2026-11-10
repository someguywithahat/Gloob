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

//---- Name plaque (caught fish only): on the front of the shelf under the bowl ----
plaque_red = make_colour_rgb(120, 14, 30)       //Deep royal red
plaque_red_dark = make_colour_rgb(84, 8, 20)    //Shadow under the top trim
plaque_gold = make_colour_rgb(214, 168, 52)     //Trim
plaque_gold_light = make_colour_rgb(250, 214, 110) //Trim highlight (top and left) and the lettering
plaque_gold_dark = make_colour_rgb(150, 102, 24)   //Trim shadow (bottom and right)
plaque_pad = 3   //Room each side of the name, inside the trim
plaque_pad_v = 2 //Room above and below the name, inside the trim (the plaque is 8 + this*2 + 2 tall)
plaque_drop = 12 //From the bowl's base (the shelf top) down to the plaque, so it sits on the shelf's front edge (16 tall)
//The tiny game font, letters 1 pixel apart instead of 2, so the longest names fit between the bowls
if !variable_global_exists("fnt_plaque")
	global.fnt_plaque = font_add_sprite(spr_gloopFont_Tiny, ord("!"), true, 1)
fish_title = "" //Looked up with the bowl sprite

fish_name = "" //Set in creation code
bowl_sprite = -1 //Looked up on the first step, after creation code has run
caught = false
frame = random(100) //Starts somewhere random in the animation, so the fish don't all swim in sync (the frame wraps around)
depth = 100 //Same as the room's Planning layer, where the bowls used to be.  Gloop hops in front of them
