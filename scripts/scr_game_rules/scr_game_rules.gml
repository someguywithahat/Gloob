/*
	Rules for the next game (global.game_rules).  A normal game uses the standard rules.
	A custom game (the Custom sign on the character select screen) sets its own:
		pu_weights           -- how often each power up shows up, 0-4 each, indexed by power up (global.BLACK ... global.RAINBOW)
		obstacle_points      -- obstacle points added at the start of each new season (see scr_obstacle_types)
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

/// Back to the standard rules (every power up equally likely, 6 points of obstacles and 2 power ups each season)
function scr_game_rules_reset()
{
	global.game_rules = {
		custom: false,
		pu_weights: array_create(9, 2),
		obstacle_points: 6,
		pu_per_season: 2,
		starting_pu: -1,
	}
}

/// Custom rules.  weights is 9 numbers (0-4).  The game starts with twice the power ups per season.
/// obstacles is the slider (0-4): each season gets 3 times that many obstacle points
function scr_game_rules_custom(weights, obstacles, pu_per_season)
{
	global.game_rules = {
		custom: true,
		pu_weights: array_create(9, 0),
		obstacle_points: obstacles*3,
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

/// The season obstacles.  Each sprite has 4 frames, one per season (see scr_obstacle_season_frame).
/// w and h are how many grid spaces it covers.  points is what it costs out of the season's obstacle points
function scr_obstacle_types()
{
	static types = [
		{ spr: Spr_Obs_1x1_Bush,        w: 1, h: 1, points: 2 },
		{ spr: Spr_Obs_1x1_Rock,        w: 1, h: 1, points: 2 },
		{ spr: Spr_Obs_1x1_Rock_Double, w: 1, h: 1, points: 2 },
		{ spr: Spr_Obs_1x1_Stump,       w: 1, h: 1, points: 2 },
		{ spr: Spr_Obs_1x1_Stump_tall,  w: 1, h: 1, points: 2 },
		{ spr: Spr_Obs_1x2_Gnome,       w: 1, h: 2, points: 3 },
		{ spr: Spr_Obs_1x2_Trellis,     w: 1, h: 2, points: 3 },
		{ spr: Spr_Obs_2x1_Log,         w: 2, h: 1, points: 3 },
		{ spr: Spr_Obs_2x2_Skull,       w: 2, h: 2, points: 4 },
		{ spr: Spr_Obs_2x4_Tree,        w: 2, h: 4, points: 6 },
		{ spr: Spr_Obs_3x3_Pond,        w: 3, h: 3, points: 6 },
	]
	return types;
}

/// Which frame of a season obstacle to show.  The sprites go summer, fall, winter, spring
function scr_obstacle_season_frame()
{
	if global.weather=global.FALL
		return 1;
	if global.weather=global.WINTER
		return 2;
	if global.weather=global.SPRING
		return 3;
	return 0;
}

/// Places one random season obstacle worth exactly `points`.  Returns false if none fit on the board
function scr_add_obstacle_worth(points)
{
	var types = scr_obstacle_types()
	var picks = []
	for (var i = 0; i < array_length(types); i++)
		if types[i].points=points
			array_push(picks, types[i])
	if array_length(picks)=0
		return false;
	var t = picks[irandom(array_length(picks)-1)]
	return scr_setup_add_obstacle(global.controller.grid_refs, t.w, t.h, t.spr);
}

/// Adds random season obstacles adding up to `points` (or as close as the board allows).
/// Each pick is a random point value (2, 3, 4 or 6) that still fits, so there's a mix of sizes
function scr_add_season_obstacles(points)
{
	var values = [2, 3, 4, 6]
	var full = [] //Point values that didn't fit on the board this time
	var left = points
	while left>=2
	{
		//Values that fit, without leaving 1 point over (nothing costs 1)
		var fits = []
		for (var i = 0; i < array_length(values); i++)
		{
			var v = values[i]
			if v<=left and left-v<>1 and !array_contains(full, v)
				array_push(fits, v)
		}
		//Board too full for an exact fit: take whatever still fits
		if array_length(fits)=0
			for (var i = 0; i < array_length(values); i++)
				if values[i]<=left and !array_contains(full, values[i])
					array_push(fits, values[i])
		if array_length(fits)=0
			break
		var pick = fits[irandom(array_length(fits)-1)]
		if scr_add_obstacle_worth(pick)
			left -= pick
		else
			array_push(full, pick)
	}
	show_debug_message("[obstacles] added " + string(points-left) + " of " + string(points) + " points")
}

/// One random season obstacle (the debug Add Obstacle button)
function scr_add_random_obstacle()
{
	scr_add_obstacle_worth(choose(2, 3, 4, 6))
}
