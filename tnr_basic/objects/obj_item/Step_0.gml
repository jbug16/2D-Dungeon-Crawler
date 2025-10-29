if is_undefined(itemData) then {
	itemData = obj_stats.inventory.GetItemsData(itemId);	
}//end if


image_index = itemData.iconSprite;
