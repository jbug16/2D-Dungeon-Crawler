if layer_exists("lay_collision") then {
	collision_tilemap = layer_tilemap_get_id("lay_collision");
}//end if

if layer_exists("lay_background") then {
	background_tilemap = layer_tilemap_get_id("lay_background");
}//end if

if layer_exists("lay_fog") then {
	fog_tilemap = layer_tilemap_get_id("lay_fog");
	
	depth = layer_get_depth("lay_fog") - 1;	
	
	for (var ty = 0; ty < tilemap_get_height(fog_tilemap); ty += 1) {
		for (var tx = 0; tx < tilemap_get_width(fog_tilemap); tx += 1) {
			tilemap_set(fog_tilemap, 6, tx, ty);			
		}//end for
	}//end for

}//end if

//depth = - room_height;

//randomize();






function SetHouseTiles(width,height,roomData) {
	_data = roomData.map;
	
	var lay_id = layer_get_id("lay_collision");
	var map_id = layer_tilemap_get_id(lay_id);

	var lay_bg_id = layer_get_id("lay_background");
	var map_bg_id = layer_tilemap_get_id(lay_bg_id);
	
	var lay_fg_id = layer_get_id("lay_foreground");
	var map_fg_id = layer_tilemap_get_id(lay_fg_id);

	
	//BUILD WALL COLLISION
		for (var row = 0; row < height; row += 1) {
			for (var col = 0; col < width; col += 1) {
				var tileData = roomData.map[col, row];

				if tileData == HouseTile.Wall {
					tilemap_set(map_id, HouseTile.Wall, col, row);
				}//end if

				if tileData == HouseTile.Floor {
					tilemap_set(map_id, HouseTile.Floor, col, row);
				}//end if
				
				if tileData == HouseTile.Door {
					obj_player.MoveTo(col * 16, row * 16);
					instance_create_layer(col * 16,(row  + 1) * 16,"lay_instances",obj_warp_back);
				}//end if
			}//end for
		}//end for
	
	//DRAW FLOORS
		for (var row = 0; row < height; row += 1) {
			for (var col = 0; col < width; col += 1) {
				var tileData = roomData.map[col, row];
				var cellX = col * 2;
				var cellY = row * 2;
				
				//if tileData == HouseTile.Floor then {				
					var tl = tile_set(09, false, false, false);
					var tr = tile_set(10, false, false, false);
					var bl = tile_set(21, false, false, false);
					var br = tile_set(22, false, false, false);
				
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR
				//}//end if
				
				if tileData == HouseTile.Door then {				
					var tl = tile_set(49, false, false, false);
					var tr = tile_set(50, false, false, false);
					var bl = tile_set(49, false, false, false);
					var br = tile_set(50, false, false, false);
				
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR
				}//end if
	
			}//end for
		}//end for
	
	//DRAW WALLS
		for (var row = 0; row < height; row += 1) {
			for (var col = 0; col < width; col += 1) {
				
				var wallData   = tilemap_get(map_id, clamp(col + 0,0,width - 1), clamp(row + 0, 0, height - 1)) == 1;
				var wallDataNW = tilemap_get(map_id, clamp(col - 1,0,width - 1), clamp(row - 1, 0, height - 1)) == 1;
				var wallDataN  = tilemap_get(map_id, clamp(col - 1,0,width - 1), clamp(row + 0, 0, height - 1)) == 1;
				var wallDataNE = tilemap_get(map_id, clamp(col - 1,0,width - 1), clamp(row + 1, 0, height - 1)) == 1;
				var wallDataE  = tilemap_get(map_id, clamp(col + 0,0,width - 1), clamp(row + 1, 0, height - 1)) == 1;
				var wallDataSE = tilemap_get(map_id, clamp(col + 1,0,width - 1), clamp(row + 1, 0, height - 1)) == 1;
				var wallDataS  = tilemap_get(map_id, clamp(col + 1,0,width - 1), clamp(row + 0, 0, height - 1)) == 1;
				var wallDataSW = tilemap_get(map_id, clamp(col + 1,0,width - 1), clamp(row - 1, 0, height - 1)) == 1;
				var wallDataW  = tilemap_get(map_id, clamp(col + 0,0,width - 1), clamp(row - 1, 0, height - 1)) == 1;
				
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
				
				
				var cellX = col * 2;
				var cellY = row * 2;
				
				
				if array_contains([511],tileValue) then {				
					var tl = tile_set(40, false, false, false);
					var tr = tile_set(40, false, false, false);
					var bl = tile_set(40, false, false, false);
					var br = tile_set(40, false, false, false);
				
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR
				}//end if				
				
				if array_contains([383],tileValue) then {				
					var tl = tile_set(40, false, false, false);
					var tr = tile_set(39, false, true, false);
					var bl = tile_set(40, false, false, false);
					var br = tile_set(40, false, false, false);
				
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR
				}//end if
				
				if array_contains([509],tileValue) then {				
					var tl = tile_set(39, true, true, false);
					var tr = tile_set(40, false, false, false);
					var bl = tile_set(40, false, false, false);
					var br = tile_set(40, false, false, false);
				
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR
				}//end if
				
				
				if array_contains([29],tileValue) then {				
					var tl = tile_set(51, false, true, false);
					var tr = tile_set(52, false, true, false);
					var bl = tile_set(40, false, false, false);
					var br = tile_set(51, false, true, true);
				
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR
				}//end if
				
				if array_contains([113],tileValue) then {				
					var tl = tile_set(52, true, true, false);
					var tr = tile_set(51, false, true, false);
					var bl = tile_set(51, false, false, true);
					var br = tile_set(40, false, false, false);
				
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR
				}//end if

							
				if array_contains([479,415,287,319],tileValue) then {				
					var tl = tile_set(40, false, false, false);
					var tr = tile_set(51, false, true, true);
					var bl = tile_set(40, false, false, false);
					var br = tile_set(51, false, true, true);
				
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR
				}//end if	
							
				if array_contains([503,499,497,505],tileValue) then {				
					var tl = tile_set(51, false, false, true);
					var tr = tile_set(40, false, false, false);
					var bl = tile_set(51, false, false, true);
					var br = tile_set(40, false, false, false);
				
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR
				}//end if	
							
				if array_contains([127,125,253],tileValue) then {				
					var tl = tile_set(51, false, true, false);
					var tr = tile_set(51, false, true, false);
					var bl = tile_set(40, false, false, false);
					var br = tile_set(40, false, false, false);
				
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR
				}//end if	
							
				
				if array_contains([273,403,471],tileValue) then {				
					var tl = tile_set(51, false, false, true);
					var tr = tile_set(51, false, true, true);
					var bl = tile_set(51, false, false, true);
					var br = tile_set(51, false, true, true);
				
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR
				}//end if
				
				//SPECIAL CASES LAZY :)
				if array_contains([257],tileValue) then {	
					var al = tile_set(52, true, false, false);
					var ar = tile_set(52, false, false, false);
					
					var tl = tile_set(12, false, false, false);
					var tr = tile_set(14, false, false, false);
					var bl = tile_set(36, false, false, false);
					var br = tile_set(38, false, false, false);
				
					tilemap_set(map_bg_id,al,cellX + 0,cellY - 1);//AL
					tilemap_set(map_bg_id,ar,cellX + 1,cellY - 1);//AR
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR
				}//end if				
	
	
				if array_contains([463,487,455, 495],tileValue) then {	
					var al = tile_set(51, false, false, false);
					var ar = tile_set(51, false, false, false);
					
					var tl = tile_set(13, false, false, false);
					var tr = tile_set(13, false, false, false);
					var bl = tile_set(37, false, false, false);
					var br = tile_set(37, false, false, false);

					tilemap_set(map_bg_id,al,cellX + 0,cellY - 1);//AL
					tilemap_set(map_bg_id,ar,cellX + 1,cellY - 1);//AR
					
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR
				}//end if
				
				if array_contains([471],tileValue) then {	
					var al = tile_set(39, true, false, false);
					var ar = tile_set(39, false, false, false);
					
					tilemap_set(map_bg_id,al,cellX + 0,cellY - 1);//AL
					tilemap_set(map_bg_id,ar,cellX + 1,cellY - 1);//AR
				}//end if				
				
				if array_contains([479],tileValue) then {	
					var ar = tile_set(39, false, false, false);
					tilemap_set(map_bg_id,ar,cellX + 1,cellY - 1);//AR 
				}//end if	
				
				if array_contains([503],tileValue) then {	
					var al = tile_set(39, true, false, false);					
					tilemap_set(map_bg_id,al,cellX + 0,cellY - 1);//AL
				}//end if	
	
			}//end for
		}//end for
	
	//WALLS
		for (var row = 0; row < height; row += 1) {
			for (var col = 0; col < width; col += 1) {
				var wallData   = tilemap_get(map_id, col + 0, row + 0) == TownTile.Wall;
				var wallDataN  = tilemap_get(map_id, col + 0, row - 1) == TownTile.Wall;
				var wallDataS  = tilemap_get(map_id, col + 0, row + 1) == TownTile.Wall;
			
				var cellX = col * 2;
				var cellY = row * 2;
						
				//WALL FRONTS
				if wallData then {
					//var tl = tile_set(52, false, false, false);
					//var tr = tile_set(53, false, false, false);
					//var bl = tile_set(52, false, false, false);
					//var br = tile_set(53, false, false, false);
					//
					//tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					//tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					//tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					//tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR
					//
					//if not wallDataN then {
					//	var tl = tile_set(52, false, false, false);
					//	var tr = tile_set(53, false, false, false);
					//	var bl = tile_set(64, false, false, false);
					//	var br = tile_set(65, false, false, false);
					//
					//	tilemap_set(map_fg_id,tl,cellX + 0,cellY - 1);//TL
					//	tilemap_set(map_fg_id,tr,cellX + 1,cellY - 1);//TR
					//
					//}				
					//
					//if not wallDataS then {
					//	var tl = tile_set(64, false, false, false);
					//	var tr = tile_set(65, false, false, false);
					//	var bl = tile_set(64, false, false, false);
					//	var br = tile_set(65, false, false, false);
					//
					//	tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					//	tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					//	tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					//	tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR					
					//}
				}//end if
			}//end for
		}//end for

	//FURNISHINGS
		for (var row = 0; row < height; row += 1) {
			for (var col = 0; col < width; col += 1) {
				var tileData = roomData.map[col, row];
				var cellX = col * 2;
				var cellY = row * 2;
				
				
				//COLLISION
				if array_contains([HouseTile.Table,HouseTile.Bed],tileData) {
					tilemap_set(map_id, 1, col, row);
				}//end if
								
				
				if tileData == HouseTile.Bed then {				
					var al = tile_set(03, false, false, false);
					var ar = tile_set(04, false, false, false);
					var tl = tile_set(15, false, false, false);
					var tr = tile_set(16, false, false, false);
					var bl = tile_set(27, false, false, false);
					var br = tile_set(28, false, false, false);
				
					tilemap_set(map_fg_id,al,cellX + 0,cellY - 1);//AL
					tilemap_set(map_fg_id,ar,cellX + 1,cellY - 1);//AR				
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR
				}//end if
				
				if tileData == HouseTile.Chair then {				
					var tl = tile_set(01, true, false, false);
					var tr = tile_set(01, false, false, false);
					var bl = tile_set(02, true, false, false);
					var br = tile_set(02, false, false, false);
				
		
					tilemap_set(map_fg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_fg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_fg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_fg_id,br,cellX + 1,cellY + 1);//BR
				}//end if
				
				if tileData == HouseTile.Table then {				
					var tl = tile_set(05, false, false, false);
					var tr = tile_set(05, true, false, false);
					var bl = tile_set(17, false, false, false);
					var br = tile_set(17, true, false, false);
				
		
					tilemap_set(map_fg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_fg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_fg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_fg_id,br,cellX + 1,cellY + 1);//BR
				}//end if
				
				if tileData == HouseTile.Bookshelf then {				
					var tl = tile_set(31, false, false, false);
					var tr = tile_set(32, false, false, false);
					var bl = tile_set(43, false, false, false);
					var br = tile_set(44, false, false, false);
				
		
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0 - 1);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0 - 1);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1 - 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1 - 1);//BR
				}//end if
				
				if tileData == HouseTile.BookshelfTall then {				
					var al = tile_set(31, false, false, false);
					var ar = tile_set(32, false, false, false);
					var tl = tile_set(43, false, false, false);
					var tr = tile_set(44, false, false, false);
					var bl = tile_set(43, false, false, false);
					var br = tile_set(44, false, false, false);
				
					tilemap_set(map_fg_id,al,cellX + 0,cellY - 1 - 1);//AL
					tilemap_set(map_fg_id,ar,cellX + 1,cellY - 1 - 1);//AR				
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0 - 1);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0 - 1);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1 - 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1 - 1);//BR
				}//end if


				if tileData == HouseTile.Drawer then {				
					var tl = tile_set(33, false, false, false);
					var tr = tile_set(34, false, false, false);
					var bl = tile_set(45, false, false, false);
					var br = tile_set(46, false, false, false);
				
		
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0 - 1);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0 - 1);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1 - 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1 - 1);//BR
				}//end if
				
				
				if tileData == HouseTile.DrawerTall then {				
					var al = tile_set(33, false, false, false);
					var ar = tile_set(34, false, false, false);
					var tl = tile_set(45, false, false, false);
					var tr = tile_set(46, false, false, false);
					var bl = tile_set(45, false, false, false);
					var br = tile_set(46, false, false, false);
				
					tilemap_set(map_fg_id,al,cellX + 0,cellY - 1 - 1);//AL
					tilemap_set(map_fg_id,ar,cellX + 1,cellY - 1 - 1);//AR				
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0 - 1);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0 - 1);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1 - 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1 - 1);//BR
				}//end if
				
				if tileData == HouseTile.Stove then {				
					var tl = tile_set(61, false, false, false);
					var tr = tile_set(62, false, false, false);
					var bl = tile_set(73, false, false, false);
					var br = tile_set(74, false, false, false);
				
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0 - 1);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0 - 1);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1 - 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1 - 1);//BR
					
					tl = tile_set(07, false, false, false);
					tr = tile_set(08, false, false, false);
					bl = tile_set(19, false, false, false);
					br = tile_set(20, false, false, false);
				
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 2 - 1);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 2 - 1);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 3 - 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 3 - 1);//BR
				}//end if
	
			}//end for
		}//end for	
		
	//ADD NPC'S
		//USE BED COUNT
			
}//end function
