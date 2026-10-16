/*
	Mushroom powerup buddy.  Hops after its slime like it's alive, one per mushroom the slime is holding.
	When the player hovers a space the mushroom hop would jump to, it hops over to that space
	to show it's about to be used.  Goes away when the slime uses up (or loses) the mushroom.

	Set parent_gloop right after creating this.
*/
parent_gloop = noone
depth=-2001 //Above the slime

//Position of the mushroom's feet (center of the sprite on the ground).  x/y are worked out from this
ground_x = x+16
ground_y = y+16

//Hopping
hop_t = -1 //0 to 1 through a hop.  -1 when standing still
hop_from_x = 0
hop_from_y = 0
hop_to_x = 0
hop_to_y = 0
hop_steps = 12 //How many steps a hop takes
hop_height = 6 //How high the current hop goes
hop_wait = 0 //Steps to wait before the next hop
height = 0 //How far off the ground right now
facing = 1 //1 right, -1 left

//Tuning
min_hop = 6 //Shortest hop in pixels
max_hop = 36 //Longest hop.  Hops get longer the further behind it is
hop_wait_min = 4 //Pause between hops, so it lags behind like it's chasing
hop_wait_max = 20
close_enough = 3 //Pixels from where it wants to be that counts as there
rest_radius_min = 14 //Where it hangs out around a resting slime
rest_radius_max = 22
behind_distance = 20 //How far behind a moving slime it chases
wander_chance = 0.005 //Chance per step to wander to a new spot near a resting slime

rest_offset_x = 0
rest_offset_y = 0

/// Pick a random spot around the slime to hang out at
pick_rest_spot = function()
{
	var angle = random(360)
	var dist = random_range(rest_radius_min, rest_radius_max)
	rest_offset_x = lengthdir_x(dist, angle)
	rest_offset_y = lengthdir_y(dist, angle)
}
pick_rest_spot()
