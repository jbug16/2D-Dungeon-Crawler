



if showGrassTileData then {
	var mapData = obj_stats._data;
	var width = array_length(mapData);
	var height = array_length(mapData[0]);

	for (var row = 1; row < height - 1; row += 1) {
		for (var col = 1; col < width - 1; col += 1) {
			var wallData   = mapData[ col + 0, row + 0] == TownTile.Grass or mapData[ col + 0, row + 0] == TownTile.Wall;
			var wallDataNW = mapData[ col - 1, row - 1] == TownTile.Grass or mapData[ col - 1, row - 1] == TownTile.Wall;
			var wallDataN  = mapData[ col - 1, row + 0] == TownTile.Grass or mapData[ col - 1, row + 0] == TownTile.Wall;
			var wallDataNE = mapData[ col - 1, row + 1] == TownTile.Grass or mapData[ col - 1, row + 1] == TownTile.Wall;
			var wallDataE  = mapData[ col + 0, row + 1] == TownTile.Grass or mapData[ col + 0, row + 1] == TownTile.Wall;
			var wallDataSE = mapData[ col + 1, row + 1] == TownTile.Grass or mapData[ col + 1, row + 1] == TownTile.Wall;
			var wallDataS  = mapData[ col + 1, row + 0] == TownTile.Grass or mapData[ col + 1, row + 0] == TownTile.Wall;
			var wallDataSW = mapData[ col + 1, row - 1] == TownTile.Grass or mapData[ col + 1, row - 1] == TownTile.Wall;
			var wallDataW  = mapData[ col + 0, row - 1] == TownTile.Grass or mapData[ col + 0, row - 1] == TownTile.Wall;
		
			var tileValue = 0;
		
			tileValue += wallData   * 0x001;
			tileValue += wallDataNW * 0x002;
			tileValue += wallDataN  * 0x004;
			tileValue += wallDataNE * 0x008;
			tileValue += wallDataE  * 0x010;
			tileValue += wallDataSE * 0x020;
			tileValue += wallDataS  * 0x040;
			tileValue += wallDataSW * 0x080;
			tileValue += wallDataW  * 0x100;
		
			draw_set_font(global.fnt_short_numbers);
				draw_text_hue(col * TILE_SIZE, row * TILE_SIZE, string(tileValue), c_frost);
				//draw_text_hue(col * TILE_SIZE, row * TILE_SIZE + 8, string(mapData[ col + 0, row + 0] == TownTile.Grass), c_ruby);
			draw_set_font(global.fnt_8bit);
			
		}//end for
	}//end for
}//end if



	
	if keyboard_check(ord("T")) then {
		var lay_id = layer_get_id("lay_collision");
		var map_id = layer_tilemap_get_id(lay_id);
		var width  = tilemap_get_width(map_id);
		var height = tilemap_get_height(map_id);

		for (var row = 0; row < height; row += 1) {
			for (var col = 0; col < width; col += 1) {
			
			
				if keyboard_check(ord("Y")) then {
					var wallData   = tilemap_get(map_id, clamp(col + 0,0,width - 1), clamp(row + 0, 0, height - 1)) == 1;
					var wallDataNW = tilemap_get(map_id, clamp(col - 1,0,width - 1), clamp(row - 1, 0, height - 1)) == 1;
					var wallDataN  = tilemap_get(map_id, clamp(col - 1,0,width - 1), clamp(row + 0, 0, height - 1)) == 1;
					var wallDataNE = tilemap_get(map_id, clamp(col - 1,0,width - 1), clamp(row + 1, 0, height - 1)) == 1;
					var wallDataE  = tilemap_get(map_id, clamp(col + 0,0,width - 1), clamp(row + 1, 0, height - 1)) == 1;
					var wallDataSE = tilemap_get(map_id, clamp(col + 1,0,width - 1), clamp(row + 1, 0, height - 1)) == 1;
					var wallDataS  = tilemap_get(map_id, clamp(col + 1,0,width - 1), clamp(row + 0, 0, height - 1)) == 1;
					var wallDataSW = tilemap_get(map_id, clamp(col + 1,0,width - 1), clamp(row - 1, 0, height - 1)) == 1;
					var wallDataW  = tilemap_get(map_id, clamp(col + 0,0,width - 1), clamp(row - 1, 0, height - 1)) == 1;
					
				}else{
					var wallData   = tilemap_get(map_id, col + 0, row + 0) == 1;
					var wallDataNW = tilemap_get(map_id, col - 1, row - 1) == 1;
					var wallDataN  = tilemap_get(map_id, col - 1, row + 0) == 1;
					var wallDataNE = tilemap_get(map_id, col - 1, row + 1) == 1;
					var wallDataE  = tilemap_get(map_id, col + 0, row + 1) == 1;
					var wallDataSE = tilemap_get(map_id, col + 1, row + 1) == 1;
					var wallDataS  = tilemap_get(map_id, col + 1, row + 0) == 1;
					var wallDataSW = tilemap_get(map_id, col + 1, row - 1) == 1;
					var wallDataW  = tilemap_get(map_id, col + 0, row - 1) == 1;
				}
		
				var tileValue = 0;
		
				tileValue += wallData   * 0x001;
				tileValue += wallDataNW * 0x002;
				tileValue += wallDataN  * 0x004;
				tileValue += wallDataNE * 0x008;
				tileValue += wallDataE  * 0x010;
				tileValue += wallDataSE * 0x020;
				tileValue += wallDataS  * 0x040;
				tileValue += wallDataSW * 0x080;
				tileValue += wallDataW  * 0x100;
		
				draw_set_font(global.fnt_short_numbers);
					draw_text_hue(col * TILE_SIZE, row * TILE_SIZE, string(tileValue), c_grass);
				draw_set_font(global.fnt_8bit);
			
			}//end for
		}//end for
	}//end if	
