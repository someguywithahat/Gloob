if player_count=1{
	clicked_coop = scr_draw_menu_item(600,440,"Single Player Game",clicked_coop)	
	//clicked_vs = scr_draw_menu_item(600,490,"VS Game",clicked_vs)
	clicked_save_defaults = scr_draw_menu_item(600,540,"Save Defaults",clicked_save_defaults)
}


if player_count>1{
	clicked_coop = scr_draw_menu_item(600,440,"COOP Game",clicked_coop)	
	clicked_vs = scr_draw_menu_item(600,490,"VS Game",clicked_vs)
	clicked_save_defaults = scr_draw_menu_item(600,540,"Save Defaults",clicked_save_defaults)
}
