/*
	Rules for the next game (global.game_rules).  A normal game uses the standard rules.
	A custom game (the Custom sign on the character select screen) sets its own:
		pu_weights           -- how often each power up shows up, 0-4 each, indexed by power up (global.BLACK ... global.RAINBOW)
		obstacles_per_season -- obstacles added at the start of each new season
		pu_per_season        -- power ups added at the start of each new season
		starting_pu          -- power ups on the board when the game starts (-1: use obj_controller's settings_NumberOfPowerUps)
*/

/// Power up names and icons, indexed by power up (global.BLACK 0 ... global.RAINBOW 8)
function scr_powerup_names()
{
	return ["Night", "Teleport", "Grass", "Fish", "Crown", "Shroom", "Bubble", "Hard Hat", "Rainbow"]
}
function scr_powerup_icons()
{
	return [Spr_Pu_Night, Spr_Pu_Tel, Spr_Pu_Grass, Spr_Pu_Fish, Spr_PU_Crown, Spr_Pu_Shroom, Spr_Pu_Bubble, Spr_PU_Hat, Spr_Pu_RB__sm]
}

/// Back to the standard rules (every power up equally likely, 3 obstacles and 2 power ups each season)
function scr_game_rules_reset()
{
	global.game_rules = {
		custom: false,
		pu_weights: array_create(9, 2),
		obstacles_per_season: 3,
		pu_per_season: 2,
		starting_pu: -1,
	}
}

/// Custom rules.  weights is 9 numbers (0-4).  The game starts with twice the power ups per season
function scr_game_rules_custom(weights, obstacles_per_season, pu_per_season)
{
	global.game_rules = {
		custom: true,
		pu_weights: array_create(9, 0),
		obstacles_per_season: obstacles_per_season,
		pu_per_season: pu_per_season,
		starting_pu: pu_per_season*2,
	}
	array_copy(global.game_rules.pu_weights, 0, weights, 0, 9)
}

/// The current rules (the standard ones if nothing has set them yet)
function scr_game_rules()
{
	if !variable_global_exists("game_rules")
		scr_game_rules_reset()
	return global.game_rules;
}

/// A random power up using the rules' weights.  -1 if every power up is turned off
function scr_pick_powerup()
{
	var weights = scr_game_rules().pu_weights
	var total = 0
	for (var i = 0; i < array_length(weights); i++)
		total += weights[i]
	if total<=0
		return -1;
	var roll = random(total)
	for (var i = 0; i < array_length(weights); i++)
	{
		roll -= weights[i]
		if roll<0 and weights[i]>0
			return i;
	}
	//Rounding: the last power up that's turned on
	for (var i = array_length(weights)-1; i >= 0; i--)
		if weights[i]>0
			return i;
	return -1;
}

/// One random obstacle, sized like the season obstacles always have been
function scr_add_random_obstacle()
{
	var grid = global.controller.grid_refs
	var roll = irandom_range(1,100)
	if roll>95
		scr_setup_add_obstacle(grid,3,3)
	else if roll>=75
		scr_setup_add_obstacle(grid,2,2)
	else if roll>=55
		scr_setup_add_obstacle(grid,1,2)
	else if roll>=35
		scr_setup_add_obstacle(grid,2,1)
	else
		scr_setup_add_obstacle(grid,1,1)
}
