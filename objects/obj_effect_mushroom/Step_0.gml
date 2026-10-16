if !instance_exists(parent_gloop)
{
	instance_destroy()
	exit
}
var gloop = parent_gloop

//One buddy per mushroom the slime still has.  Extras (the mushroom was used or replaced) go away
var mushrooms_held = (gloop.powerUp1=global.RED) + (gloop.powerUp2=global.RED) + (gloop.powerUp3=global.RED)
var my_rank = 0 //How many of this slime's buddies came before me
with(obj_effect_mushroom)
	if parent_gloop=gloop and id<other.id
		my_rank++
if my_rank>=mushrooms_held
{
	instance_destroy()
	exit
}


//---- Where does it want to be? ----
var controller = global.controller
var slime_center_x = gloop.x + controller.spacing/2
var slime_center_y = gloop.y + controller.spacing/2
var goal_x = slime_center_x + rest_offset_x
var goal_y = slime_center_y + rest_offset_y
var hurry = false

//Chase from behind while the slime is moving
if gloop.ismoving=1 and (gloop.derX<>0 or gloop.derY<>0)
{
	goal_x = slime_center_x - gloop.derX*behind_distance + rest_offset_x*0.3
	goal_y = slime_center_y - gloop.derY*behind_distance + rest_offset_y*0.3
}

//The first buddy hops over to the space a mushroom hop would jump to, when the player hovers it
if my_rank=0 and gloop.ismoving=0 and gloop.alive=1 and controller.current_player=gloop.player_number
{
	var hover_x = floor((mouse_x - controller.start_x) / controller.spacing)
	var hover_y = floor((mouse_y - controller.start_y) / controller.spacing)
	var dx = hover_x - gloop.grid_x
	var dy = hover_y - gloop.grid_y
	//Exactly 2 away, straight or diagonal: same as the hop targets in obj_gloop's Step
	var is_hop_target = (abs(dx)=2 or dx=0) and (abs(dy)=2 or dy=0) and !(dx=0 and dy=0)
	if is_hop_target
	{
		var space = scr_get_grid_id(hover_x, hover_y)
		if space<>noone and space.wall=0 and space.activeNumber=1
		{
			goal_x = space.x + controller.spacing/2
			goal_y = space.y + controller.spacing/2
			hurry = true
		}
	}
}


//---- Hop toward it ----
if hop_t<0
{
	//Standing still
	hop_wait--
	var dist = point_distance(ground_x, ground_y, goal_x, goal_y)
	if dist>close_enough and (hop_wait<=0 or hurry or dist>max_hop)
	{
		//Start a hop.  Further behind = bigger, quicker hops
		var hop_length = min(dist, clamp(dist*0.6, min_hop, max_hop))
		var dir = point_direction(ground_x, ground_y, goal_x, goal_y)
		hop_from_x = ground_x
		hop_from_y = ground_y
		hop_to_x = ground_x + lengthdir_x(hop_length, dir)
		hop_to_y = ground_y + lengthdir_y(hop_length, dir)
		hop_steps = dist>60 ? 8 : 12
		hop_height = 4 + hop_length*0.15
		hop_t = 0
		if abs(goal_x-ground_x)>1
			facing = sign(goal_x-ground_x)
	}
	else if dist<=close_enough and gloop.ismoving=0 and random(1)<wander_chance
		pick_rest_spot()
}
else
{
	//Mid hop
	hop_t += 1/hop_steps
	if hop_t>=1
	{
		hop_t = -1
		ground_x = hop_to_x
		ground_y = hop_to_y
		height = 0
		hop_wait = hurry ? 0 : irandom_range(hop_wait_min, hop_wait_max)
	}
	else
	{
		ground_x = lerp(hop_from_x, hop_to_x, hop_t)
		ground_y = lerp(hop_from_y, hop_to_y, hop_t)
		height = sin(hop_t*pi)*hop_height
	}
}

//Sprite is 16x16 with a top left origin
x = ground_x - sprite_width/2
y = ground_y - sprite_height/2
