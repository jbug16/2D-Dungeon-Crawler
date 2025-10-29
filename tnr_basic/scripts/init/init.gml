function init() {
	global.fnt_8bit      = -1;

	var MapString      = "";
	for (var IntChr    = 32; IntChr < 32 + sprite_get_number(spr_font); IntChr += 1){
	        MapString += chr(IntChr);
	}//next IntChr
    
	global.fnt_8bit      = font_add_sprite_ext(spr_font,MapString,false,0);
	global.fnt_small    = font_add_sprite_ext(spr_font_small,MapString,true,1);
	global.fnt_short_numbers = font_add_sprite_ext(spr_small_numbers," 1234567890.",false,0);

	draw_set_font(global.fnt_8bit);

	game_set_speed(60, gamespeed_fps);

	var window_scale   = 4;
	window_set_size(CAMERA_WIDTH * window_scale,CAMERA_HEIGHT * window_scale);
	//window_set_position(1024,1204);
	
}
