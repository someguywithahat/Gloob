

//


if (mouse_check_button_pressed(mb_left) and ismoving=0) { // left mouse click
    var mx = mouse_x;  // mouse X position
    var my = mouse_y;  // mouse Y position

    var dx = mx - x;   // horizontal distance from object to mouse
    var dy = my - y;   // vertical distance from object to mouse
	
	var derX=0
	var derY=0
	
	var checkx = x
	var checky = y

    // Calculate the angle from object to mouse in degrees
    var angle_deg = point_direction(x+16, y+16, mx, my);

    // Determine the direction.  
	//Remove checkx and checky
    var direct;
    if (angle_deg >= 337.5 || angle_deg < 22.5) {
        direct = "Right";
		derX=1;
		derY=0;
		checkx=x+32;
		checky=y;
    } else if (angle_deg >= 22.5 && angle_deg < 67.5) {
        direct = "Up-Right";
		derX=1;
		derY=-1;
		
		checkx=x+32;
		checky=y-32;
    } else if (angle_deg >= 67.5 && angle_deg < 112.5) {
        direct = "Up";
		derX=0;
		derY=-1;
		checkx=x;
		checky=y-32;
    } else if (angle_deg >= 112.5 && angle_deg < 157.5) {
        direct = "Up-Left";
		derX=-1;
		derY=-1;
		checkx=x-32;
		checky=y-32;
    } else if (angle_deg >= 157.5 && angle_deg < 202.5) {
        direct = "Left";
		derX=-1;
		derY=0;
		checkx=x-32;
		checky=y;		
    } else if (angle_deg >= 202.5 && angle_deg < 247.5) {
        direct = "Down-Left";		
		derX=-1;
		derY=+1;
		checkx=x-32;
		checky=y+32;
    } else if (angle_deg >= 247.5 && angle_deg < 292.5) {
        direct = "Down";
		derX=0;
		derY=1;
		checkx=x;
		checky=y+32;
    } else if (angle_deg >= 292.5 && angle_deg < 337.5) {
        direct = "Down-Right";
		derX=1;
		derY=1;
		checkx=x+32;
		checky=y+32;
    }
	
	//var check_grid_inst = instance_place(checkx, checky, obj_gridNumber);
	var check_grid_inst = instance_place(x+(32*derX), y+(32*derY), obj_gridNumber);
	
	
	if (check_grid_inst != noone) {
	    var c = check_grid_inst.my_number;  // read the variable
	    
		target_x = x + (32*derX*c);	
		target_y = y + (32*derY*c);	
		ismoving=1;
		pickup_target=c;
		pickup_counter=0;
	}
	show_debug_message(string((32*derX*c)) + " " + string((32*derY*c)))
	show_debug_message(string(x) + " " + string(y))
	show_debug_message("test " + string(target_x) + " y " + string(target_y));

    show_debug_message("Mouse direction relative to object: " + direct + ". Next space: " +string(c));
}




if ismoving=1{
	
	var grid_inst = instance_position(x+16, y+16, obj_gridNumber);
	
	if (grid_inst != noone) and pickup_target>pickup_counter {
	    with (grid_inst) {
	        instance_destroy();
	    }
		pickup_counter+=1;
	}

	// Move X toward target
	if (x < target_x) {
	    x += move_speed;
	    if (x > target_x) x = target_x; // prevent overshoot
	}
	if (x > target_x) {
	    x -= move_speed;
	    if (x < target_x) x = target_x;
	}

	// Move Y toward target
	if (y < target_y) {
	    y += move_speed;
	    if (y > target_y) y = target_y;
	}
	if (y > target_y) {
	    y -= move_speed;
	    if (y < target_y) y = target_y;
	}
	
	if x==target_x and y==target_y{
		ismoving=0	
		grid_inst = instance_position(x+16, y+16, obj_gridNumber);
	
		if (grid_inst != noone) {
		    with (grid_inst) {
		        instance_destroy();
		    }
		}
	}	
}




