global.controller = id;
global.weather=0
global.fnt_Gloop = font_add_sprite(spr_gloopFontOutline, ord("!"), true, 5);
global.fnt_Gloop_small = font_add_sprite(spr_gloopFont_Tiny, ord("!"), true, 2);
scr_set_GLOBAL_values()
scr_load_fishing_tickets()

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
clicked_end_day=-1

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

