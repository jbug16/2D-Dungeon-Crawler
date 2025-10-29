//if (live_call()) return live_result;

var xShift = 8;
if direction != 0 or direction != 180 then xShift = 4;

draw_sprite_ext(spr_shadow, 0, x - xShift , y - 8, .5, 1, 0, c_black, 1);

if sprite_index != spr_shadow then {
	xShift = 0;
	if direction == 000 then xShift = -8;
	if direction == 180 then xShift =  8;
	
	draw_sprite_ext(sprite_index, image_index, x + xShift, y, 1, 1, image_angle, c_white, 1);
}//end if
