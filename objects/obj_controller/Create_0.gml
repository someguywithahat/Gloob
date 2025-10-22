global.controller = id;
randomize();

slime_speed=2
MINSPEED = .5
MAXSPEED = 4

// Size of grid
cols = 26;
rows = 26;
grid_size=(cols-2)*(rows-2)
remaining_grid=grid_size


// Starting position
start_x = 256;
start_y = -32;
spacing = 32;

score_xx=1120
score_yy=20

number_of_players = 1
current_player=0
persistent=true

music_playing = false;

target_obj=noone

player_color = array_create(8,-1)

grid_refs = noone


clicked_quickstart = 0
clicked_character_select = 0

window_set_fullscreen(true);