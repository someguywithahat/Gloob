function scr_draw_score(xx,yy,gloop_score){
	var digit_width_mod=-12
	var txt = string(gloop_score);
	var len = string_length(txt);
	var digit_width = sprite_get_width(Numbers)+digit_width_mod;
	var x_pos = xx; // starting position
	var y_pos = yy;

	for (var i = 1; i <= len; i++) {
	    var ch = real(string_char_at(txt, i)); // convert char to number
		if ch=0
			ch=9
		else ch--
	    draw_sprite(Numbers, ch, x_pos + (i - 1) * digit_width, y_pos);
		
	}
}

//function scr_draw_overall_score(xx,yy,gloop_score, max_score){
//	var txt = string(gloop_score);
//	var len = string_length(txt);
//	var digit_width = sprite_get_width(Numbers)+digit_width_mod;
//	var x_pos = xx; // starting position
//	var y_pos = yy;

//	for (var i = 1; i <= len; i++) {
//	    var ch = real(string_char_at(txt, i)); // convert char to number
//		if ch=0
//			ch=9
//		else ch--
//	    draw_sprite(Numbers, ch, x_pos + (i - 1) * digit_width, y_pos);		
//	}
//}