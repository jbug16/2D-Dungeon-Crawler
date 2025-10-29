event_inherited();



function Interacted(){
	if image_index == 0 then {
		image_index = 1;
		obj_stats.inventory.AddItem(self.itemId);
		var damId = instance_create_depth(x + 8,y,depth-1,obj_damage);
		var itemData = obj_stats.inventory.GetItemsData(itemId);
		damId.value = itemData.name;
		damId.sprite_index = spr_items
		damId.image_index = itemData.iconSprite;
	}//end if
}//end if
