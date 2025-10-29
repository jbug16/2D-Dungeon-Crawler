function RenderPlanet(xPos, yPos, radius, rotateSpeed = 1, tilt = 0) constructor {
	_xPos        = xPos;
	_yPos        = yPos;
	_radius      = radius;
	_rotateSpeed = rotateSpeed;
	_tilt        = tilt;
	
	_sprite      = undefined;	
	_overSprite  = undefined;
	_drawColors  = []
	
	
	
	SetupPlanetColors = function (){
		_drawColors = TILE_COLOR;
	}//end if
		
	function SetSprite(sprite){
		_sprite  = sprite;	
	}//end function
		
	function Draw() {
		var diameter = _radius * 2
		var scl      = diameter / sprite_get_width(spr_pixel);
		var spd      = current_time / _rotateSpeed;
		
		//draw_text_hue(8,8, "sprite used 25%", c_gold);
		//draw_sprite_ext(spr_temp_planet,0,_xPos - _radius,_yPos - _radius - 16,1,1,0,c_white,1);
		//draw_text_hue(_xPos - _radius,_yPos - _radius, "no\nplanet\nhere", c_gold);
		
		
		
		shader_set(shd_planet)
			shader_set_uniform_f(shader_get_uniform(shd_planet,"time"),current_time/10000);
			texture_set_stage(shader_get_sampler_index(shd_planet,"map_tex"),sprite_get_texture(_sprite,0));
			draw_sprite_ext(spr_pixel,0,_xPos - _radius,_yPos - _radius,scl,scl,_tilt,c_white,1);
		
			if not is_undefined(_overSprite) then {
				shader_set_uniform_f(shader_get_uniform(shd_planet,"time"),current_time/20000);
				texture_set_stage(shader_get_sampler_index(shd_planet,"map_tex"),sprite_get_texture(_overSprite,0));
				draw_sprite_ext(spr_pixel,0,_xPos - _radius,_yPos - _radius,scl,scl,_tilt,c_white,1);
			}//end if
			
		shader_reset();
	}//end method

	function LoadPlanetData(tileTypeArray, width, height) {
		var surf = surface_create(width,height);
		var tileData = tileTypeArray.data;
		
		surface_set_target(surf);	
			draw_clear_alpha(c_black,0);
	
			for(var tileY = 0; tileY < width; tileY++){
				for(var tileX = 0; tileX < height; tileX++){
					var tileValue = tileData[tileX,tileY];
					var tileCol   = _drawColors[tileValue];
					var r         = color_get_red(tileCol);
					var g         = color_get_green(tileCol);
					var b         = color_get_blue(tileCol)		
					var col       = make_color_rgb(b,g,r);
			
					draw_point_color(tileX,tileY,col);
				}//end for
			}//end for
		surface_reset_target();
	
		var spr = sprite_create_from_surface(surf,0,0,width,height,false,false,0,0);
		surface_free(surf);
	
		_sprite = spr;
	}//end method

	SetupPlanetColors();
}//end class