if is_undefined(lines)
	exit

for (var i = 0; i < array_length(lines); i++)
{
	var bushes = lines[i].bushes
	for (var b = 0; b < array_length(bushes); b++)
		draw_sprite(sprite_index, bushes[b].frame, bushes[b].x, bushes[b].y)
}
