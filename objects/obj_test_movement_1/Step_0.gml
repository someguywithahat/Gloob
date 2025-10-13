// Move toward the target point

if (moving_to_b) {
    move_towards_point(x2, y2, speed_val);
    if (point_distance(x, y, x2, y2) < speed_val) {
        moving_to_b = false; // switch direction
    }
} else {
    move_towards_point(x1, y1, speed_val);
    if (point_distance(x, y, x1, y1) < speed_val) {
        moving_to_b = true; // switch back
    }
}