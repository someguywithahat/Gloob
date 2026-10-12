//One line of bushes per direction
if is_undefined(lines)
{
	lines = []
	var directions = [[0,-1], [0,1], [-1,0], [1,0]]
	for (var i = 0; i < array_length(directions); i++)
	{
		array_push(lines, {
			dir_x: directions[i][0],
			dir_y: directions[i][1],
			distance: 0,     //Spaces out from the slime
			done: false,     //Reached the edge of the board
			bushes: []       //Bushes showing: {x, y, frame}
		})
	}
}

step_timer++
if step_timer<step_delay
	exit
step_timer=0

var still_going = false
for (var i = 0; i < array_length(lines); i++)
{
	var line = lines[i]

	//Grow the next bush
	if !line.done
	{
		line.distance++
		var space = scr_get_grid_id(origin_grid_x + line.dir_x*line.distance, origin_grid_y + line.dir_y*line.distance)
		if space=noone or space.wall=1
			line.done = true
		else
		{
			//Each bush in the line uses the next frame
			array_push(line.bushes, {
				x: space.x,
				y: space.y,
				frame: (line.distance-1) mod sprite_get_number(sprite_index)
			})
			scr_grass_regrow_space(space)
		}
	}

	//Remove the oldest bush when the line is too long, or one at a time once it's done
	if array_length(line.bushes)>max_bushes or (line.done and array_length(line.bushes)>0)
		array_delete(line.bushes, 0, 1)

	if !line.done or array_length(line.bushes)>0
		still_going = true
}

if !still_going
	instance_destroy()
