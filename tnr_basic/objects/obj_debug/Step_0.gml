if keyboard_check_pressed(ord("1")) then {

}//end if

if keyboard_check_pressed(ord("2")) then {
	room_goto(room_test_dungeon);
}//end if

if keyboard_check(ord("3")) then {

}//end if

if keyboard_check(ord("B")) then {

}//end if

if keyboard_check(ord("4")) then {

}//end if

if keyboard_check(ord("5")) then {

}//end if

if keyboard_check(ord("6")) then {

}//end if

if keyboard_check_pressed(ord("G")) then {

}//end if

if keyboard_check_pressed(ord("R")) then {
	game_restart();	
}//end if

if keyboard_check_pressed(ord("O")) then {
	obj_camera.FadeOut(20, c_black);
}//end if

if keyboard_check_pressed(ord("W")) then {
	obj_player.stats.hp = 1;
	obj_player.stats.mp = 1;
	obj_player.stats.fp = 1;
}//end if


if keyboard_check_pressed(ord("I")) then {
	obj_camera.FadeIn(20, c_black);
}//end if

if keyboard_check_pressed(ord("D")) then {
	for (var yp = 0; yp < room_height div 8; ++yp) {
	    for (var xp = 0; xp < room_width div 8; ++xp) {
		    tilemap_set(obj_stats.fog_tilemap, 6, xp,yp)// code here
		}
	}
}//end if

if keyboard_check_pressed(ord("F")) then {
	obj_camera.DefogRoom(obj_player.x,obj_player.y);
}//end if

if keyboard_check_pressed(ord("T")) then {
	obj_stats.inventory.AddItem(ITEM_IRON_SWORD);
	obj_stats.inventory.AddItem(ITEM_BRONZE_SPEAR);
	obj_stats.inventory.AddItem(ITEM_BRONZE_AXE);
	obj_stats.inventory.AddItem(ITEM_BRONZE_KATANA);
	obj_stats.inventory.AddItem(ITEM_BRONZE_STAFF);
	obj_stats.inventory.AddItem(ITEM_BRONZE_BOW);
	obj_stats.inventory.AddItem(ITEM_BRONZE_CLAW);
	obj_stats.inventory.AddItem(ITEM_BRONZE_WHIP);
	obj_stats.inventory.AddItem(ITEM_BRONZE_CROSSBOW); 
	obj_stats.inventory.AddItem(ITEM_BRONZE_HAMMER);
	obj_stats.inventory.AddItem(ITEM_BRONZE_ROD);
	obj_stats.inventory.AddItem(ITEM_BRONZE_SCYTHE);
	obj_stats.inventory.AddItem(ITEM_ICE1_SPELL);
	obj_stats.inventory.AddItem(ITEM_ICE1_SPELL);
	obj_stats.inventory.AddItem(ITEM_ICE1_SPELL);
	obj_stats.inventory.AddItem(ITEM_FIRE1_SPELL);
	obj_stats.inventory.AddItem(ITEM_FIRE1_SPELL);
	obj_stats.inventory.AddItem(ITEM_FIRE1_SPELL);
	
}//end if