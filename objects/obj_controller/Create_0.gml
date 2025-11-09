global.controller = id;
global.weather=0
randomize();

slime_speed=2
MINSPEED = .5
MAXSPEED = 4

// Size of grid
cols = 26;
rows = 26;
grid_size=(cols-2)*(rows-2)
remaining_grid=grid_size

isPaused=0
pauseMenuY=-750
pauseMenuyMax=100
pauseMenuyMin=-750

// Starting position
start_x = 256;
start_y = -32;
spacing = 32;

score_xx=1220
score_yy=20

number_of_players = 1
current_player=0
persistent=true
depth=-20000
layer_create(-20001, "AboveEverything");

music_playing = false;

target_obj=noone

player_color = array_create(10,-1)

grid_refs = noone

//clicked values are set to 0 when the option is hovered over, and 1 when clicked
clicked_quickstart = -1
clicked_character_select = -1
clicked_debugRoom = -1

window_set_fullscreen(true);

settings_NumberOfPowerUps=4
settings_MaxNumberOfPowerUps=3
settings_obstacles=0

global.fnt_Gloop = font_add_sprite(spr_gloopFontOutline, ord("!"), true, 5);

PU_SPRITES = array_create(10,noone)
PU_SPRITES[0]=Spr_PU_Hat
PU_SPRITES[1]=Spr_Pu_Tel


scr_save_high_score()
