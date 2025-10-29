// get direction from this object to the other
var dir = point_direction(x, y, other.x, other.y);

// move both away from each other 1 pixel
x += lengthdir_x(-1, dir);
y += lengthdir_y(-1, dir);

other.x += lengthdir_x(1, dir);
other.y += lengthdir_y(1, dir);
