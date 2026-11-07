global.controller = id;
global.weather=0
global.fnt_Gloop = font_add_sprite(spr_gloopFontOutline, ord("!"), true, 5);
global.fnt_Gloop_small = font_add_sprite(spr_gloopFont_Tiny, ord("!"), true, 2);
scr_set_GLOBAL_values()
scr_load_fishing_tickets()
scr_load_fish_caught()

//Music is in its own audio group so it can have its own volume.  It loads in the background
audio_group_load(audiogroup_music)
music_group_ready=false

//var high_score ={
//	gname: "GLP",
//	gscore: 123,
//	gindex: 1,
//	gcolor: 2
//}
//global.high_scores = array_create(10,high_score)
global.high_scores = [
    { gname: "JEX", gscore: 250, gindex: 1, gcolor: 2 },
    { gname: "VI ", gscore: 225, gindex: 2, gcolor: 4 },
    { gname: "KAY", gscore: 201, gindex: 0, gcolor: 3 },
    { gname: "BAG", gscore: 200, gindex: 4, gcolor: 5 },
    { gname: "AZR", gscore: 175, gindex: 4, gcolor: 1 },
    { gname: "RNT", gscore: 150, gindex: 0, gcolor: 6 },
    { gname: "ARK", gscore: 125, gindex: 4, gcolor: 7 },
    { gname: "KRA", gscore: 100, gindex: 2, gcolor: 0 },
    { gname: "HAT", gscore: 75,  gindex: 0, gcolor: 1 },
    { gname: "SLM", gscore: 1,   gindex: 3, gcolor: 2 }
];
global.running_score_total=0
//scr_save_high_score()
scr_load_high_score()

randomize();

slime_speed=2
MINSPEED = .5
MAXSPEED = 4

//Saved volumes and default speed from the pause menu
scr_load_options()
scr_apply_audio()

// Size of grid
cols = 26;
rows = 26;
grid_size=(cols-2)*(rows-2)


season_goal_percentage=global.controller_default_season_goal_percentage
season_goal = round(grid_size*season_goal_percentage)

//Pause menu (Escape).  See scr_pause_menu
isPaused=0
pause_snapshot=-1 //Picture of the game taken when pausing.  Drawn behind the menu
pause_dragging="" //Name of the slider being dragged
pause_music_frame=0 //Spr_Slm_music animation on the pause menu
pauseMenuY=-750
pauseMenuyMax=134
pauseMenuyMin=-750

// Starting position
start_x = 256;
start_y = -32;
spacing = 32;

//score_xx=1220
//score_yy=20

number_of_players = 1
starting_number_of_players = 1 //Players at the start of the game, before any crown slimes
current_player=0
total_score=0
persistent=true
depth=-20000
//layer_create(-20001, "AboveEverything");

//Starting track.  audiogroup_music is still loading here, so the Step event starts it once it's ready
music_playing = 3;
global.music_current=noone
start_music=snd_track2


target_obj=noone

player_color = array_create(100,-1)
player_accessory = array_create(100,0)

grid_refs = noone
game_over_status=0
disable_game_inputs=0
game_over_object=noone
isNight=0
isNightShader=0

//clicked values are set to 0 when the option is hovered over, and 1 when clicked
clicked_quickstart = -1
clicked_character_select = -1
clicked_debugRoom = -1
clicked_debugRoom2 = -1
clicked_scoreRoom = -1
clicked_restart=-1
clicked_main_menu=-1
clicked_exitGame=-1
clicked_characterSelect = -1 //remake of character select
title_start_x = 688 //Title screen: middle of the "Start Game" text, on the sign in the room's Signs layer (x 560-816, y 472-568)
title_start_y = 520
clicked_title_start = 0 //Set when "Start Game" is clicked.  Step goes to rm_characterSelect
//Title screen: the OPTIONS and VILLAGE words (Letters layer) on their little signs (Signs layer).  Click areas: [left, top, right, bottom]
title_options_box = [120, 600, 200, 632]
title_village_box = [1048, 616, 1128, 648]
clicked_title_options = 0 //Step opens the pause menu
clicked_title_village = 0 //Step goes to rm_town
clicked_title_lake = 0 //Step goes to rm_fishingCenter, same as the fishing sign (obj_fishing_ticket_counter)
title_lake_sprite = Spr_Obs_3x3 //The pond in the bottom right (Assets_1 layer).  Click it to go fishing
title_lake_hover_color = c_white //Its tint while the mouse is over it
title_lake_inset = 12 //Click area is this many pixels inside the pond's edges (its corners are rounded)

/// Title screen: is the mouse over the pond?  Tints it while hovered
title_lake_hovered = function()
{
	var assets_layer = layer_get_id("Assets_1")
	if assets_layer=-1
		return false;
	var elements = layer_get_all_elements(assets_layer)
	for (var i = 0; i < array_length(elements); i++)
	{
		var el = elements[i]
		if layer_get_element_type(el)<>layerelementtype_sprite or layer_sprite_get_sprite(el)<>title_lake_sprite
			continue
		//Its tint from the room editor, remembered the first time
		if !variable_instance_exists(id, "title_lake_blend") or title_lake_blend_room<>room
		{
			title_lake_blend = layer_sprite_get_blend(el)
			title_lake_blend_room = room
		}
		var spr = title_lake_sprite
		var sx = layer_sprite_get_xscale(el)
		var sy = layer_sprite_get_yscale(el)
		var left = layer_sprite_get_x(el) + (sprite_get_bbox_left(spr)-sprite_get_xoffset(spr))*sx + title_lake_inset
		var top = layer_sprite_get_y(el) + (sprite_get_bbox_top(spr)-sprite_get_yoffset(spr))*sy + title_lake_inset
		var right = layer_sprite_get_x(el) + (sprite_get_bbox_right(spr)+1-sprite_get_xoffset(spr))*sx - title_lake_inset
		var bottom = layer_sprite_get_y(el) + (sprite_get_bbox_bottom(spr)+1-sprite_get_yoffset(spr))*sy - title_lake_inset
		var hovered = point_in_rectangle(mouse_x, mouse_y, left, top, right, bottom)
		layer_sprite_blend(el, hovered ? title_lake_hover_color : title_lake_blend)
		return hovered;
	}
	return false;
}

/// Title screen: is the mouse over this click area?  Fades the Letters layer letters inside it while hovered
title_word_hovered = function(box)
{
	var hovered = point_in_rectangle(mouse_x, mouse_y, box[0], box[1], box[2], box[3])
	var letters_layer = layer_get_id("Letters")
	if letters_layer=-1
		return hovered;
	var elements = layer_get_all_elements(letters_layer)
	for (var i = 0; i < array_length(elements); i++)
	{
		if layer_get_element_type(elements[i])<>layerelementtype_sprite
			continue
		var lx = layer_sprite_get_x(elements[i])
		var ly = layer_sprite_get_y(elements[i])
		if point_in_rectangle(lx, ly, box[0], box[1], box[2], box[3])
			layer_sprite_alpha(elements[i], hovered ? 0.6 : 1)
	}
	return hovered;
}

//---- Title screen: hanging signs sway gently, with their letters ----
//The signs slide side to side and stay level (no turning, so the pixel art stays crisp).  Their chains lean to follow:
//each chain piece moves part of the way, more the further down it is.
//Each sign: the Signs/Letters layer pieces whose top left is inside box [left, top, right, bottom].  pivot_y is where the chains hang from.
//amount is how many pixels it swings each way, period is steps for one full swing, skip_frames are Signage frames to leave still.
//riders are other layers whose sprites in the box ride along (the white and black slimes sitting on top of the Welcome sign, in Assets_1)
title_sway_signs = [
	{ name: "welcome", box: [470, -24, 900, 110], pivot_y: -40, amount: 5, period: 260, phase: 0, skip_frames: [], riders: ["Assets_1"] },
]
title_kite_chance = 1/2400 //Title screen: chance each step a slime blows across hanging from a kite (obj_title_kite_flyer).  About every 40 seconds
title_sway_chain_frames = [6, 7, 8] //Signage frames that hang between the pivot and the sign: chains, and the vines growing on them
title_sway_time = 0
title_sway_ready_room = noone //Room the pieces were collected in

/// Finds the pieces of each sign and remembers where they started
title_sway_setup = function()
{
	title_sway_ready_room = room
	for (var s = 0; s < array_length(title_sway_signs); s++)
	{
		title_sway_signs[s].pieces = []
		title_sway_signs[s].sign_top = infinity //Top of the sign itself (not its chains)
	}
	var layer_names = ["Signs", "Letters"]
	for (var l = 0; l < array_length(layer_names); l++)
	{
		var lay = layer_get_id(layer_names[l])
		if lay=-1
			continue
		var elements = layer_get_all_elements(lay)
		for (var i = 0; i < array_length(elements); i++)
		{
			var el = elements[i]
			if layer_get_element_type(el)<>layerelementtype_sprite
				continue
			var ex = layer_sprite_get_x(el)
			var ey = layer_sprite_get_y(el)
			for (var s = 0; s < array_length(title_sway_signs); s++)
			{
				var sw = title_sway_signs[s]
				if !point_in_rectangle(ex, ey, sw.box[0], sw.box[1], sw.box[2], sw.box[3])
					continue
				var is_signage = layer_sprite_get_sprite(el)=Signage
				if is_signage and array_contains(sw.skip_frames, layer_sprite_get_index(el))
					break
				var is_chain = is_signage and array_contains(title_sway_chain_frames, layer_sprite_get_index(el))
				array_push(sw.pieces, { el: el, x: ex, y: ey, chain: is_chain })
				if !is_chain
					sw.sign_top = min(sw.sign_top, ey)
				break
			}
		}
	}

	//Riders: sprites from other layers sitting on a sign.  They move with the sign
	for (var s = 0; s < array_length(title_sway_signs); s++)
	{
		var sw = title_sway_signs[s]
		for (var l = 0; l < array_length(sw.riders); l++)
		{
			var lay = layer_get_id(sw.riders[l])
			if lay=-1
				continue
			var elements = layer_get_all_elements(lay)
			for (var i = 0; i < array_length(elements); i++)
			{
				var el = elements[i]
				if layer_get_element_type(el)<>layerelementtype_sprite
					continue
				var ex = layer_sprite_get_x(el)
				var ey = layer_sprite_get_y(el)
				if point_in_rectangle(ex, ey, sw.box[0], sw.box[1], sw.box[2], sw.box[3])
					array_push(sw.pieces, { el: el, x: ex, y: ey, chain: false })
			}
		}
	}
}

/// How far this sign is swung right now, in pixels (positive is right)
title_sway_offset = function(sw)
{
	return sw.amount*sin(title_sway_time*2*pi/sw.period + sw.phase);
}

/// Swings the signs.  Run every step in the title room
title_sway_update = function()
{
	if title_sway_ready_room<>room
		title_sway_setup()
	title_sway_time++
	for (var s = 0; s < array_length(title_sway_signs); s++)
	{
		var sw = title_sway_signs[s]
		var off = title_sway_offset(sw)
		var chain_len = max(1, sw.sign_top-sw.pivot_y)
		for (var i = 0; i < array_length(sw.pieces); i++)
		{
			var p = sw.pieces[i]
			var move = off
			if p.chain //Chains move less near the top, where they hang from
				move = off*clamp((p.y-sw.pivot_y)/chain_len, 0, 1)
			layer_sprite_x(p.el, p.x+move)
		}
	}
}

/// Draws whatever comes next moved along with the named sign.  Call title_sway_end() after
title_sway_begin = function(sign_name)
{
	if title_sway_ready_room<>room
		return;
	for (var s = 0; s < array_length(title_sway_signs); s++)
	{
		var sw = title_sway_signs[s]
		if sw.name<>sign_name
			continue
		matrix_set(matrix_world, matrix_build(title_sway_offset(sw), 0, 0, 0, 0, 0, 1, 1, 1))
		return;
	}
}

title_sway_end = function()
{
	matrix_set(matrix_world, matrix_build_identity())
}

scr_room_fade_get() //Fades in when the game starts (see obj_room_fade)
clicked_end_day=-1
clicked_reset_fishing=-1 //Testing button in rm_fishingCenter
clicked_add_ticket=-1 //Testing button in rm_fishingCenter

window_set_fullscreen(true);

settings_NumberOfPowerUps=4
settings_MaxNumberOfPowerUps=3
settings_obstacles=0



PU_SPRITES = array_create(10,noone)
PU_SPRITES[global.YELLOW]=Spr_Pu_Hat_Sign
PU_SPRITES[global.BLUE]=Spr_Pu_Tel_Fairy_Sign
PU_SPRITES[global.RAINBOW]=Spr_Pu_RB_SM_Full
PU_SPRITES[global.PURPLE]=Spr_Pu_Crown_Sign
PU_SPRITES[global.RED]=Spr_Pu_Shroom_Sign
PU_SPRITES[global.WHITE]=Spr_Pu_Bubble_Sign
PU_SPRITES[global.ORANGE]=Spr_Pu_Fish_Sign
PU_SPRITES[global.BLACK]=Spr_Pu_Night_Sign
PU_SPRITES[global.GREEN]=Spr_Pu_Grass_Sign




global.achievement1=0

