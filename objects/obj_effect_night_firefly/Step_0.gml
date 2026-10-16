var center_x = x+half_size
var center_y = y+half_size

if home_delay>0
{
	//Bursting out of the slime and fluttering
	home_delay--
	speed*=burst_slowdown
	direction+=random_range(-8,8)
}
else
{
	//Swoop toward the counter, turning a little more sharply each step
	var target_dir = point_direction(center_x, center_y, target_x, target_y)
	direction += angle_difference(target_dir, direction)*turn_rate
	turn_rate = min(turn_rate+0.01, 1)
	home_speed = min(home_speed+home_acceleration, home_max_speed)
	speed = home_speed

	if point_distance(center_x, center_y, target_x, target_y)<10
	{
		//Delivered: one less point needed today
		global.controller.season_goal--
		if instance_exists(owner)
			owner.gloop_score_obj.gloop_score++
		instance_destroy()
		exit
	}
}

//Flutter side to side
wiggle+=15
x+=lengthdir_x(0.6*dsin(wiggle), direction+90)
y+=lengthdir_y(0.6*dsin(wiggle), direction+90)
