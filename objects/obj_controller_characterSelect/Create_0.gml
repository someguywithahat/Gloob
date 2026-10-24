xx = 320
yy = 300
spacer = 75

//label_menu1="START COOP GAME";
//xx_menu1=200
//yy_menu1=500

//label_menu2="START VS GAME";
//xx_menu2=860
//yy_menu2=500

clicked_coop = -1
clicked_vs = -1
clicked_save_defaults = -1

player_count = 0


var xspace = 135
var yspace = 160
slime1 = instance_create_layer(472, 185,"Instances", obj_gloopCharacterSelect);
slime2 = instance_create_layer(472 +(xspace*1), 185,"Instances", obj_gloopCharacterSelect);
slime3 = instance_create_layer(472 +(xspace*2), 185,"Instances", obj_gloopCharacterSelect);
slime4 = instance_create_layer(472 +(xspace*3), 185,"Instances", obj_gloopCharacterSelect);
//slime3 = instance_create_layer(xx+(spacer*3), yy,"Instances", obj_gloopCharacterSelect);
//slime4 = instance_create_layer(xx+(spacer*4), yy,"Instances", obj_gloopCharacterSelect);

slime5 = instance_create_layer(472, 185+(yspace*1),"Instances", obj_gloopCharacterSelect);
slime6 = instance_create_layer(472 +(xspace*1), 185+(yspace*1),"Instances", obj_gloopCharacterSelect);
slime7 = instance_create_layer(472 +(xspace*2), 185+(yspace*1),"Instances", obj_gloopCharacterSelect);
slime8 = instance_create_layer(472 +(xspace*3), 185+(yspace*1),"Instances", obj_gloopCharacterSelect);


slime1.gloop_color=global.GREEN
slime1.gloop_name=global.strGloopGreen
slime1.image_index = 20;

slime2.gloop_color=global.BLUE
slime2.gloop_name=global.strGloopBlue
slime2.image_index = 20;

slime3.gloop_color=global.PURPLE
slime3.gloop_name=global.strGloopPurple
slime3.image_index = 20;

slime4.gloop_color=global.BLACK
slime4.gloop_name=global.strGloopBlack
slime4.image_index = 20;

slime5.gloop_color=global.RED
slime5.gloop_name=global.strGloopRed
slime5.image_index = 20;

slime6.gloop_color=global.ORANGE
slime6.gloop_name=global.strGloopOrange
slime6.image_index = 20;

slime7.gloop_color=global.YELLOW
slime7.gloop_name=global.strGloopYellow
slime7.image_index = 20;

slime8.gloop_color=global.WHITE
slime8.gloop_name=global.strGloopWhite
slime8.image_index = 20;

//---- Character bio panel (left side) ----
slimes = [slime1, slime2, slime3, slime4, slime5, slime6, slime7, slime8]
was_selected = array_create(8, 0) //Last step's selected states, to spot a new selection
last_selected = noone //Most recently selected slime
bio_gloop = noone //Slime whose bio is showing
bio_scroll = 0 //0 top to 1 bottom

bio_x = 40 //Panel position, and size in 16 pixel grass sign tiles (Signage): x 40-424, y 120-568
bio_y = 120
bio_x_tiles = 23
bio_y_tiles = 27
bio_padding = 24 //Space between the border and the text
bio_text_scale = 2 //Body text uses global.fnt_Gloop_small (8 pixel letters) drawn this much bigger
bio_line_gap = 20 //Pixels between lines of body text, after scaling

/// True if the mouse is over a character select slime
mouse_over_slime = function(slime)
{
	return mouse_x > slime.x - slime.sprite_xoffset && mouse_x < slime.x - slime.sprite_xoffset + slime.sprite_width
		&& mouse_y > slime.y - slime.sprite_yoffset && mouse_y < slime.y - slime.sprite_yoffset + slime.sprite_height
}

//---- Team stumps: a copy of each selected slime stands on the stumps along the bottom (Assets_Stumps layer) ----
max_selected = 4 //Most slimes that can be picked at once
stump_offset_x = 14 //Where a slime copy stands on a stump, from the stump's position in the room editor
stump_offset_y = -8
stump_order = [] //Selected slimes in stump order, left to right.  This is also player order (stump 1 = player 1)
stump_frame = 0 //Idle animation for the copies

//The stumps, left to right
stumps = []
var stump_layer = layer_get_id("Assets_Stumps")
if layer_exists(stump_layer)
{
	var elements = layer_get_all_elements(stump_layer)
	for (var i = 0; i < array_length(elements); i++)
		if layer_get_element_type(elements[i])=layerelementtype_sprite
			array_push(stumps, { x: layer_sprite_get_x(elements[i]), y: layer_sprite_get_y(elements[i]) })
	array_sort(stumps, function(a, b) { return a.x - b.x })
}

//---- Start sign (right side), with a smaller "Custom" sign hanging under it ----
start_sign_x = 1080
start_sign_y = 300
start_sign_scale = 2
start_sign_w = 160 //Size passed to scr_draw_sign (it rounds to whole tiles)
start_sign_h = 64
start_text = "Start"

custom_sign_scale = 1
custom_sign_w = 112
custom_sign_h = 32
custom_sign_gap = 20 //Space between the two signs.  The Custom sign's chains bridge it
custom_text = "Custom"

/// Where scr_draw_sign actually puts a sign: [x, y, width, height].  It rounds the size to whole tiles
sign_box = function(sx, sy, w, h, scale)
{
	var tile = sprite_get_width(Signage)*scale
	return [sx, sy, (round(w/tile)+1)*tile, (round(h/tile)+1)*tile]
}

/// Custom mode (not designed yet).  Called when the Custom sign is clicked
start_custom = function()
{
	//TODO: custom game mode
	audio_play_sound(snd_menu_chime, 1, false)
}

/// Starts the game with the slimes on the stumps, in stump order (leftmost is player 1)
start_game = function()
{
	var controller = global.controller
	var team_size = array_length(stump_order)
	controller.number_of_players = team_size
	for (var i = 0; i < 10; i++)
	{
		if i<team_size
		{
			controller.player_color[i] = stump_order[i].gloop_color
			controller.player_accessory[i] = stump_order[i].has_accessory
		}
		else
		{
			controller.player_color[i] = -1 //Nobody in this slot
			controller.player_accessory[i] = 0
		}
	}
	room_goto(rm_gameScreen)
}
