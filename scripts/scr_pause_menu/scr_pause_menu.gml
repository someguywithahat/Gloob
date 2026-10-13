/*
	Pause menu.  Escape opens and closes it.  These all run inside obj_controller.

	Pausing takes a picture of the screen, then deactivates every other instance so the
	game freezes exactly where it is.  The picture is drawn behind the menu while paused.
*/

#macro PAUSE_SIGN_X 383
#macro PAUSE_SIGN_W 600
#macro PAUSE_SIGN_H 500
#macro PAUSE_SPEED_STEP 0.5 //Default speed snaps to steps of this size, same as the S/F keys


function scr_pause_open(){
	if isPaused
		return;

	pause_snapshot = sprite_create_from_surface(application_surface, 0, 0,
		surface_get_width(application_surface), surface_get_height(application_surface), false, false, 0, 0)
	instance_deactivate_all(true)

	isPaused=1
	pause_dragging=""
	pauseMenuY=pauseMenuyMin
}


function scr_pause_close(){
	if !isPaused
		return;

	instance_activate_all()
	if sprite_exists(pause_snapshot)
		sprite_delete(pause_snapshot)
	pause_snapshot=-1

	isPaused=0
	pause_dragging=""
}


/// Draws the paused game and the menu, and handles clicks.  Call from obj_controller's Draw event
function scr_pause_draw(){
	//Frozen game, dimmed
	if sprite_exists(pause_snapshot)
		draw_sprite_stretched(pause_snapshot, 0, 0, 0, room_width, room_height)
	draw_set_color(c_black)
	draw_set_alpha(0.4)
	draw_rectangle(0, 0, room_width, room_height, false)
	draw_set_alpha(1)

	//Sign slides down from the top
	if pauseMenuY<pauseMenuyMax
		pauseMenuY=min(pauseMenuY+50, pauseMenuyMax)
	var sx = PAUSE_SIGN_X
	var sy = pauseMenuY
	scr_draw_sign(sx, sy, PAUSE_SIGN_W, PAUSE_SIGN_H, 3, 10, 0, 4)

	//Only take input once the sign has landed
	var ready = pauseMenuY>=pauseMenuyMax
	var center_x = sx + PAUSE_SIGN_W/2

	draw_set_font(global.fnt_Gloop)
	draw_set_color(c_white)
	scr_menu_text_centered("Paused", center_x, sy+40)

	//Sliders
	var label_x = sx+50
	var slider_x = sx+330
	var slider_w = 160
	var value_x = sx+510

	global.master_volume = scr_menu_slider_row("Master Volume", "master", global.master_volume,
		label_x, slider_x, slider_w, value_x, sy+110, ready)
	global.music_volume = scr_menu_slider_row("Music Volume", "music", global.music_volume,
		label_x, slider_x, slider_w, value_x, sy+170, ready)
	global.sfx_volume = scr_menu_slider_row("SFX Volume", "sfx", global.sfx_volume,
		label_x, slider_x, slider_w, value_x, sy+230, ready)

	//Speed slider works in 0-1 like the others, then maps to MINSPEED-MAXSPEED
	var speed_range = MAXSPEED-MINSPEED
	var speed_t = scr_menu_slider_row("Default Speed", "speed", (slime_speed-MINSPEED)/speed_range,
		label_x, slider_x, slider_w, -1, sy+290, ready)
	slime_speed = MINSPEED + round(speed_t*speed_range/PAUSE_SPEED_STEP)*PAUSE_SPEED_STEP
	draw_text(value_x, sy+290-string_height("0")/2, string_format(slime_speed, 1, 1))

	if pause_dragging<>""
	{
		scr_apply_audio()
		//Let go of a slider: save, and play a sound so you can hear the new volume
		if !mouse_check_button(mb_left)
		{
			if pause_dragging<>"speed"
				audio_play_sound(snd_slime_move, 1, false)
			pause_dragging=""
			scr_save_options()
		}
	}

	//Dancing slime in the corner of the sign
	scr_menu_music_slime(sx+PAUSE_SIGN_W-120, sy+380, 2)

	//Buttons
	if scr_menu_button("Resume", center_x, sy+370, ready)
	{
		scr_pause_close()
		return;
	}
	if room<>rm_titleScreen and scr_menu_button("Main Menu", center_x, sy+415, ready)
	{
		scr_pause_close()
		clicked_main_menu=1 //obj_controller's Step handles going to the title screen
		return;
	}
	if scr_menu_button("Exit Game", center_x, sy+460, ready)
		game_end()
}


/// One row: label, slider, and percentage.  value is 0-1.  Pass value_x=-1 to draw the value yourself
function scr_menu_slider_row(label, slider_name, value, label_x, slider_x, slider_w, value_x, row_y, active){
	var text_y = row_y - string_height(label)/2
	draw_text(label_x, text_y, label)
	value = scr_menu_slider(slider_name, slider_x, row_y, slider_w, value, active)
	if value_x<>-1
		draw_text(value_x, text_y, string(round(value*100)) + "%")
	return value
}


/// Click and drag slider from left (0) to right (1).  Returns the new value
function scr_menu_slider(slider_name, xx, yy, w, value, active){
	if active
	{
		if mouse_check_button_pressed(mb_left) and point_in_rectangle(mouse_x, mouse_y, xx-10, yy-12, xx+w+10, yy+12)
			pause_dragging=slider_name
		if pause_dragging=slider_name and mouse_check_button(mb_left)
			value = clamp((mouse_x-xx)/w, 0, 1)
	}

	//Track
	draw_set_color(c_black)
	draw_set_alpha(0.5)
	draw_rectangle(xx, yy-3, xx+w, yy+3, false)
	draw_set_alpha(1)
	//Filled part
	draw_set_color(c_white)
	draw_rectangle(xx, yy-3, xx+w*value, yy+3, false)
	//Knob
	var knob_x = xx+w*value
	draw_set_color(c_black)
	draw_circle(knob_x, yy, 10, false)
	draw_set_color(pause_dragging=slider_name ? c_lime : c_white)
	draw_circle(knob_x, yy, 8, false)

	draw_set_color(c_white)
	return value
}


/// Centered text button.  Fades when hovered.  Returns true when clicked
function scr_menu_button(text, center_x, yy, active){
	var w = string_width(text)
	var h = string_height(text)
	var xx = center_x - w/2
	var hovered = active and point_in_rectangle(mouse_x, mouse_y, xx-4, yy-4, xx+w+4, yy+h+4)

	draw_set_color(c_white)
	draw_set_alpha(hovered ? 0.6 : 1)
	draw_text(xx, yy, text)
	draw_set_alpha(1)

	if hovered and mouse_check_button_pressed(mb_left)
	{
		var snd = audio_play_sound(snd_slime_move, 1, false)
		audio_sound_pitch(snd, random_range(0.9, 1.2))
		return true
	}
	return false
}


/// Spr_Slm_music: idles (frames 0-7) when the music is basically off, dances (frames 8-18) when you can hear it
function scr_menu_music_slime(xx, yy, scale){
	var music_audible = global.master_volume>=0.05 and global.music_volume>=0.05
	var first_frame = music_audible ? 8 : 0
	var last_frame = music_audible ? 18 : 7

	//Jump to the start of the other animation when the music turns on/off
	if pause_music_frame<first_frame or pause_music_frame>=last_frame+1
		pause_music_frame=first_frame

	draw_sprite_ext(Spr_Slm_music, floor(pause_music_frame), xx, yy, scale, scale, 0, c_white, 1)

	pause_music_frame += sprite_get_speed(Spr_Slm_music) / game_get_speed(gamespeed_fps)
	if pause_music_frame>=last_frame+1
		pause_music_frame=first_frame
}


function scr_menu_text_centered(text, center_x, yy){
	draw_text(center_x - string_width(text)/2, yy, text)
}
