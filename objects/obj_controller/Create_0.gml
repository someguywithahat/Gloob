	global.controller = id;

// Size of grid
cols = 26;
rows = 26;

// Starting position
start_x = 256;
start_y = -32;
spacing = 32;


number_of_players = 10
current_player=0

music_playing = false;

target_obj = instance_create_layer(1, 1, "Instances", obj_targeting);





grid_refs = scr_setup_grid(rows, cols, spacing, start_x, start_y, number_of_players)

