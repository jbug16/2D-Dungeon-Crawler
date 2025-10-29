draw_set_halign(fa_center);
draw_text_hue(floor(x),floor(y),value,color);
draw_set_halign(fa_left);

if sprite_exists(sprite_index) then {
	draw_sprite(sprite_index,image_index, middle_x(id) - sprite_get_width(sprite_index),y + 8);
}
	