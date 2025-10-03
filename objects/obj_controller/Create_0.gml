// Size of grid
var cols = 24;
var rows = 24;

// Starting position
var start_x = 288;
var start_y = 32;

// Spacing between objects (assuming each object is 32x32 pixels)
var spacing = 32;


// Loop through rows and columns
for (var xx = 0; xx < cols; xx++) {
    for (var yy = 0; yy < rows; yy++) {
        instance_create_layer(
            start_x + xx * spacing,
            start_y + yy * spacing,
            "Instances",   // layer name (make sure this matches your room layer!)
            obj_gridNumber      // object to place
        );
    }
}



//// Loop through every slime in the room
//with (obj_gloop) {
//    // Check if there's food at (x+16, y+16) for this slime
//    var number_inst = instance_position(x + 16, y + 16, obj_gridNumber);

//    if (number_inst != noone) {
//        // Do something with the food
//        with (number_inst) {
//            instance_destroy(); // example: remove the food
//        }

//        // Optional: give slime a point or grow
//        score += 1;   // if you have a score variable
//    }
//}