text = ""
title = "Info"
ready = false;
timer = 30;
xOffset = 8;
yOffset = 16;

choiceMode  = false;
choices     = [];
choiceIndex = 0;

//depth = -room_height;
layer = layer_get_id("lay_hud");

x = obj_camera.x + xOffset 
y = obj_camera.y + yOffset
width = CAMERA_WIDTH - xOffset * 2;
height = 48;

backColor  = c_azure;
trimColor  = c_frost;
textColor  = c_frost;
titleColor = c_gold;
buttonColor = c_frost;

function Draw() {
	

	draw_rect_filled(x,y,width, height,backColor);	
	draw_rect(x + 2,y + 3,width - 4, height - 6,trimColor);	
	draw_rect(x + 3,y + 4,width - 6, height - 8,trimColor);
	
	if title != "" then {
		draw_rect_filled(x+8,y,string_width(title), 8,backColor);	
		draw_text_hue(x + 8, y, title, titleColor)
	}//end if
	
	draw_text_hue(x + 8, y + 12, text, textColor);

	if choiceMode == true then {
		for (index = 0; index < array_length(choices); index += 1) {
			draw_text_hue(x + 24, y + 12 + (10 * index), choices[index].choiceMessage, textColor);
		}//end for
		
		var shift = cos(((current_time mod 1000) / 1000) * 6.28);
		draw_sprite(spr_menu_cursor, 2, x + 20 + shift , y + 12 + (10 * choiceIndex));
	}//end if
		
	if ready {
		draw_rect_filled(x + width - 17, y + height - 9,10, 8,backColor);	
		draw_sprite_ext(spr_button, (current_time mod 500) > 250,x + width - 16, y + height - 9,1,1,0,buttonColor,1);
	}//end if
	
	//draw_sprite_ext(spr_menu_slice,0,x,y, 16, 16, 0, 0xffffff,1)
}

function Update(){
	if not ready then {
		timer -= 1;
		if timer == 0 then ready = true;
	}else{
		
		if choiceMode == true then {
			choiceIndex += obj_controller.CheckButtonDownUp();
			
			if choiceIndex < 0 then choiceIndex = array_length(choices) - 1;
			if choiceIndex >= array_length(choices) then choiceIndex = 0;
		}//end if		
		
		
		if obj_controller.CheckButton(K_PB) then {
			if choiceMode == false then {
				instance_destroy();
			}else{
			     choices[choiceIndex].choiceFunction();	
				 instance_destroy();
			}//end if
		}//end if
	}//end if
}



