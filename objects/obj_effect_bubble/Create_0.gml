/*
	Bubble powerup.  Floats around the grid bouncing off the edges.
	Click it (while no slime is busy) to pop it.  Every free number within pop_radius spaces
	gets covered in slime and scores for the slime that made the bubble.
	Bouncing into a corner makes it bigger and adds 1 to the pop radius.

	x/y is the CENTER of the bubble.  Set owner right after creating this.
*/
owner=noone //The obj_gloop that made the bubble.  Gets the points

controller = global.controller
depth=-1999 //Above the numbers and trails, below the slimes

//Movement
xx = irandom_range(0,1)
if xx=0 then xx=-3 else xx=3
yy = random_range(-2,2)

//Size
bubble_scale=1
bubble_radius=8 //Pixels, at scale 1.  Used for bouncing and clicking
pop_radius=2 //Spaces covered when popped
corner_distance=7 //Pixels from a grid corner that counts as hitting the corner
corner_scale_up=0.5 //How much bigger each corner hit makes it
corner_cooldown=0 //Stops one corner from counting twice

//Animation (Spr_Pu_Bubble: 0-7 appear, 8-34 float, 35-47 pop)
enum BUBBLE_PHASE {
	APPEAR,
	FLOAT,
	POP
}
phase=BUBBLE_PHASE.APPEAR
frame=0
just_popped=false //True for the step it was popped on
anim_speed = sprite_get_speed(Spr_Pu_Bubble) / game_get_speed(gamespeed_fps)

//Play area: the inside of the grid (walls are the outer ring of spaces)
var grid = controller.grid_refs
var cols = array_length(grid)
var rows = array_length(grid[0])
grid_left = grid[1][1].x
grid_top = grid[1][1].y
grid_right = grid[cols-2][rows-2].x + controller.spacing
grid_bottom = grid[cols-2][rows-2].y + controller.spacing


/// Radius in pixels at the current size
current_radius = function()
{
	return bubble_radius*bubble_scale
}

/// True if the mouse is over the bubble and it can be popped right now
can_pop_at_mouse = function()
{
	if phase<>BUBBLE_PHASE.FLOAT
		return false
	if point_distance(mouse_x, mouse_y, x, y) > current_radius()+2
		return false

	//Wait while any slime is moving or using a power
	var busy = instance_exists(obj_effect_grass_burst)
	with(obj_gloop)
		if ismoving=1 or isteleporting<>0
			busy = true
	return !busy
}

/// True if a click at the mouse is meant for this bubble, so slimes should ignore it.
/// Covers both orders the Step events can run in: before the pop (floating) and right after it (just_popped)
blocks_click = function()
{
	if phase<>BUBBLE_PHASE.FLOAT and !just_popped
		return false
	return point_distance(mouse_x, mouse_y, x, y) <= current_radius()+2
}

/// Pop: cover every free number within pop_radius spaces with the owner's slime
pop = function()
{
	phase=BUBBLE_PHASE.POP
	frame=35
	just_popped=true

	var spacing = controller.spacing
	var center_x = floor((x - controller.start_x) / spacing)
	var center_y = floor((y - controller.start_y) / spacing)
	var color = instance_exists(owner) ? owner.gloop_color_index : 5

	//+0.5 rounds the edge so the covered area looks like a circle
	var reach = sqr(pop_radius + 0.5)
	for (var dx = -pop_radius; dx <= pop_radius; dx++)
	{
		for (var dy = -pop_radius; dy <= pop_radius; dy++)
		{
			if dx*dx + dy*dy > reach
				continue
			var space = scr_get_grid_id(center_x+dx, center_y+dy)
			if space=noone
				continue
			//Only free numbers.  Powerups stay so they can still be collected
			if space.wall<>0 or space.obs<>0 or space.activeNumber<>1 or space.has_powerUP<>-1
				continue

			space.activeNumber=0
			space.gloop_color_index=color
			space.sprite_index=scr_get_slime_trail(0)
			space.image_speed=1
			space.trail_custom=0
			scr_spawn_flower(space.x, space.y, color)

			controller.season_goal--
			if instance_exists(owner)
				owner.gloop_score_obj.gloop_score++
		}
	}
}
