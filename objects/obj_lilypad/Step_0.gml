var half = sprite_get_width(sprite_index)/2
var shove_x = 0 //Pushed out of something this step (moved along with the speed, so it stops at the shore)
var shove_y = 0
if ripple_cooldown>0
	ripple_cooldown--

//---- The boat pushes the pad aside ----
var boat = instance_find(obj_gloopFishing, 0)
if boat<>noone
{
	//Closest point on the boat to the middle of the pad
	var near_x = clamp(pad_x, boat.bbox_left, boat.bbox_right)
	var near_y = clamp(pad_y, boat.bbox_top, boat.bbox_bottom)
	var dx = pad_x-near_x
	var dy = pad_y-near_y
	var dist = point_distance(0, 0, dx, dy)
	var overlap = pad_radius-dist
	if dist<0.5
	{
		//Middle of the pad is under the boat: push out away from the boat's middle
		dx = pad_x-boat.center_x()
		dy = pad_y-boat.center_y()
		dist = max(0.5, point_distance(0, 0, dx, dy))
		overlap = pad_radius
	}
	if overlap>0
	{
		var nx = dx/dist
		var ny = dy/dist
		shove_x += nx*overlap
		shove_y += ny*overlap

		//Speed the pad up to (a bit more than) the boat's speed in the push direction
		var boat_along = boat.xx*nx + boat.yy*ny
		var pad_along = vx*nx + vy*ny
		var want = max(0, boat_along)*push_strength
		if pad_along<want
		{
			vx += nx*(want-pad_along)
			vy += ny*(want-pad_along)
		}
		//Dragged a little sideways too
		var side_x = boat.xx - nx*boat_along
		var side_y = boat.yy - ny*boat_along
		vx += (side_x-vx)*push_carry*0.1
		vy += (side_y-vy)*push_carry*0.1

		//An off-centre hit spins it
		spin += (nx*boat.yy - ny*boat.xx)*spin_from_hit

		//Pushing pads slows the boat a little
		boat.xx *= boat_drag
		boat.yy *= boat_drag

		if abs(boat_along)>0.6
			add_ripple(pad_x, pad_y)
	}
}

//---- Pads bump each other ----
var me = id
with(obj_lilypad)
{
	if id=me
		continue
	var bx = other.pad_x-pad_x
	var by = other.pad_y-pad_y
	var gap = point_distance(0, 0, bx, by)
	var overlap = other.pad_radius+pad_radius-gap
	if overlap>0
	{
		if gap<0.5
		{
			bx = random_range(-1, 1)
			by = random_range(-1, 1)
			gap = max(0.5, point_distance(0, 0, bx, by))
		}
		//Each pad moves itself half the way out
		shove_x += bx/gap*overlap*0.5
		shove_y += by/gap*overlap*0.5
		other.vx += bx/gap*overlap*other.pad_bump
		other.vy += by/gap*overlap*other.pad_bump
	}
}

//---- Drift home, or float free ----
if attached
{
	vx += (home_x-pad_x)*spring
	vy += (home_y-pad_y)*spring
	if point_distance(pad_x, pad_y, home_x, home_y)>detach_distance
	{
		attached = false
		ripple_cooldown = 0
		add_ripple(pad_x, pad_y)
	}
}
vx *= water_drag
vy *= water_drag
if abs(vx)<0.01
	vx = 0
if abs(vy)<0.01
	vy = 0

//---- Move, stopping at the shore ----
var move_x = vx+shove_x
var move_y = vy+shove_y
x = pad_x-half
y = pad_y-half
if place_meeting(x+move_x, y, obj_gloopFishingWall)
{
	move_x = 0
	vx *= -0.4
}
if place_meeting(x, y+move_y, obj_gloopFishingWall)
{
	move_y = 0
	vy *= -0.4
}
pad_x += move_x
pad_y += move_y

//Stay in the room
pad_x = clamp(pad_x, half, room_width-half)
pad_y = clamp(pad_y, half, room_height-half)
x = pad_x-half
y = pad_y-half

//---- Spin and ripples ----
spin = clamp(spin, -12, 12)*spin_drag
turn += spin
sway_time++

for (var i = array_length(ripples)-1; i >= 0; i--)
{
	ripples[i].age++
	if ripples[i].age>40
		array_delete(ripples, i, 1)
}
