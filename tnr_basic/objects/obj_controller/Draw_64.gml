exit;
//draw_text_color(x + 0,y + 000,"Con. " + string(controller_index) + " detected."  ,c_yellow,c_yellow,c_red,c_red,1);
//draw_text_color(x + 0,y + 008,"Con. " + string(controller_index) + " connected : " + string(gamepad_is_connected(controller_index))  ,c_yellow,c_yellow,c_red,c_red,1);
var state_string = string_lpad(string_bin(State),36,"0");
//draw_text_hue(0,0,state_string);
draw_text_hue(0,0,string_copy(state_string,00,18),c_gold);
draw_text_hue(0,8,string_copy(state_string,19,18),c_gold);

for (var i = 0; i < gamepad_button_count(controller_index); i += 1)
{     
	if gamepad_button_check(controller_index, i) then {
      draw_text(0, 16, string(i))
	}
}


//draw_sprite(SprController,1,x + 64, y + 64);


//or(var index = 0; index < 5; index += 1) {
//	if device_mouse_check_button(index, mb_left) {
//		draw_text_hue(x+16,y+16 + 8 * index, "touch " + string(index));
//	}//end if
////end for

//draw_text_hue(x + 00,y + 008,chr(KeyUp    ),c_red);
//draw_text_hue(x + 00,y + 016,chr(KeyDown  ),c_red);
//draw_text_hue(x + 00,y + 024,chr(KeyLeft  ),c_red);
//draw_text_hue(x + 00,y + 032,chr(KeyRight ),c_red);
//draw_text_hue(x + 00,y + 040,chr(KeyA     ),c_red);
//draw_text_hue(x + 00,y + 048,chr(KeyB     ),c_red);
//draw_text_hue(x + 00,y + 056,chr(KeyX     ),c_red);
//draw_text_hue(x + 00,y + 064,chr(KeyY     ),c_red);
//draw_text_hue(x + 00,y + 072,chr(KeyL     ),c_red);
//draw_text_hue(x + 00,y + 080,chr(KeyR     ),c_red);
//draw_text_hue(x + 00,y + 088,chr(KeySelect),c_red);
//draw_text_hue(x + 00,y + 096,chr(KeyStart ),c_red);

//
