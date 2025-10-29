image_speed = 0;
oneTime     = false;
blocking    = false;
xOffset     = 0;
yOffset     = 0;
itemId      = 0

function Setup(){
	blocking =  object_index != obj_stairs_up and object_index != obj_stairs_down;
}//end 

function Interacted(){
		
	if not instance_exists(obj_textbox) then {
		//var textId = instance_create_depth(0,0,-room_height,obj_textbox);
		var textId = instance_create_layer(0,0,"lay_hud",obj_textbox);
		textId.text = msg;
	}//end if
}



function DestroyPot(full, contentsArray) {	
	if full then {
		var iid = instance_create_depth(x,y,depth,obj_item);
		iid.itemId = obj_stats.inventory.GetItemsData(choose_array(contentsArray)).id;
	}//end if
}//end if
