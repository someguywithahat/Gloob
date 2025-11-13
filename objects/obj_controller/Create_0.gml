global.controller = id;
global.weather=0
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
total_score=0
persistent=true
depth=-20000
layer_create(-20001, "AboveEverything");

music_playing = false;

target_obj=noone

player_color = array_create(10,-1)

grid_refs = noone
game_over_status=0
disable_game_inputs=0
game_over_object=noone

//clicked values are set to 0 when the option is hovered over, and 1 when clicked
clicked_quickstart = -1
clicked_character_select = -1
clicked_debugRoom = -1
clicked_scoreRoom = -1
clicked_restart=-1
clicked_main_menu=-1

window_set_fullscreen(true);

settings_NumberOfPowerUps=4
settings_MaxNumberOfPowerUps=3
settings_obstacles=0

global.fnt_Gloop = font_add_sprite(spr_gloopFontOutline, ord("!"), true, 5);

PU_SPRITES = array_create(10,noone)
PU_SPRITES[0]=Spr_PU_Hat
PU_SPRITES[1]=Spr_Pu_Tel


global.FALL = 3
global.WINTER = 1
global.SPRING = 2
global.SUMMER = 0
