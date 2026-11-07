/*
	A lilypad floating in the fishing rooms.  Place them in the room editor.
	The boat (obj_gloopFishing) pushes them aside, and they drift back to where they were placed.
	Push one too far from that spot and it breaks loose, then floats free wherever it's pushed.
	Lilypads also bump each other and the shore (obj_gloopFishingWall).

	Spr_Lilly_Pads has a top left origin, so the physics works from the middle of the pad (pad_x, pad_y).
	Instance creation code can override any setting below.
	Frame 0 is the lily pad (the default).  For a flower instead, set the instance's frame to 1 in the room editor,
	or put image_index = 1 in its creation code.
*/

//---- Settings ----
pad_radius = 13          //Size of the pad for bumping (the drawn pad is about 26 pixels across)
spring = 0.004           //How strongly an attached pad drifts back home
water_drag = 0.95        //Speed kept each step (lower stops sooner)
detach_distance = 84     //Pushed this far from home, the pad breaks loose for good
push_strength = 1.15     //How fast the boat shoves a pad, compared to the boat's own speed
push_carry = 0.25        //How much of the boat's sideways speed drags the pad along
boat_drag = 0.985        //The boat keeps this much speed each step it's pushing a pad
pad_bump = 0.06          //How hard two overlapping pads push apart
spin_from_hit = 0.6      //How much an off-centre hit spins the pad
spin_drag = 0.94         //Spin kept each step
sway_amount = 2          //Gentle idle rocking, in degrees

//---- State ----
var half = sprite_get_width(sprite_index)/2
pad_x = x+half //Middle of the pad
pad_y = y+half
home_x = pad_x //Where it was placed.  It drifts back here while attached
home_y = pad_y
attached = true
vx = 0
vy = 0
turn = random(360) //Drawn rotation.  (Not image_angle, which would swing the mask around the top left corner)
spin = 0
sway_time = random(1000)
ripples = [] //{ x, y, age } rings spreading out from bumps
ripple_cooldown = 0
image_speed = 0 //Keeps whichever frame it was given (0 pad, 1 flower)

//Under the boat, which is on the Instances layer
var boat_layer = layer_get_id("Instances")
if boat_layer<>-1
	depth = layer_get_depth(boat_layer)+1

/// A small ring on the water where the pad was bumped
add_ripple = function(rx, ry)
{
	if ripple_cooldown>0
		return;
	array_push(ripples, { x: rx, y: ry, age: 0 })
	ripple_cooldown = 12
}
