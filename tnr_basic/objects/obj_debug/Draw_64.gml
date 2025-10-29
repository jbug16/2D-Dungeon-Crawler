if keyboard_check(ord("S")) then {
	
	draw_text_hue(0,00,"u_seed = " + string(obj_universe.universe_seed)  ,c_gold);
	draw_text_hue(0,10,"s_seed = " + string(obj_universe.starsystem_seed),c_gold);
	draw_text_hue(0,20,"p_seed = " + string(obj_universe.planet_seed)    ,c_gold);
	draw_text_hue(0,30,"e_seed = " + string(obj_universe.exploreSeed)    ,c_gold);
	
}//end if

if keyboard_check(ord("Q")) then {
	var drawIndex = 0;
	
	with all {
		draw_text_hue(0,drawIndex * 10, object_get_name(object_index), c_gold);
		drawIndex += 1;
	}//end with
}//end if

if keyboard_check_pressed(ord("Q")) then {
	var drawIndex = 0;
	
	with all {
		print(object_get_name(object_index));
	}//end with
}//end if


//draw_set_font(global.fnt_small);
//draw_text_hue(0,0, obj_stats.attackQueue, c_emerald);
//draw_set_font(global.fnt_8bit);

if mouse_check_button(mb_middle) then {
	var fx = mouse_x div 8 * 8;
	var fy = mouse_y div 8 * 8;
	var temp = string([fx,fy]);
	temp = string_replace_all(temp," ", "")
	draw_text_hue(mouse_x - obj_camera.x,mouse_y - obj_camera.y, temp, c_gold);	
}//end if


draw_text_hue(4,120,string(fps)+ "/60",c_grass);