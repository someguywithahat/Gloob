depth=-200000

//Storage variables
xx = 1200
yy = 60


//storage toggles
clicked_left=-1
clicked_right=-1
clicked_up=-1
clicked_down=-1


sprite_to_place=noone
sprite_frame_to_place=0


storage = array_create(10,noone)
storage_index=0

//----------------testing code, will need to load later
sprite_to_place=Spr_Obs_1x1
sprite_to_place_index=2
sprite_to_place_type=0 //0 = object, 1 = gloop.


storage = [
    { sprite_to_place: Spr_Obs_1x1, sprite_to_place_index: 2},
    { sprite_to_place: Spr_Obs_1x1, sprite_to_place_index: 3},
    { sprite_to_place: Spr_Obs_1x1, sprite_to_place_index: 1},
    { sprite_to_place: Spr_House_Mushroom, sprite_to_place_index: 4},
    { sprite_to_place: Spr_Obs_2x1, sprite_to_place_index: 1},
    { sprite_to_place: Spr_Obs_2x1, sprite_to_place_index: 2},
    { sprite_to_place: Spr_Obs_2x1, sprite_to_place_index: 3},
    { sprite_to_place: Spr_Obs_2x1, sprite_to_place_index: 4},
    { sprite_to_place: Spr_Obs_1x2, sprite_to_place_index: 2},
    { sprite_to_place: Spr_Obs_1x2, sprite_to_place_index: 1}
];

/*
	**object variables needed**
sprite
sprite index
type - decoration, gloop, weather
status - in storage or on board

gloop:
	color(s)
	accessories
	
*/