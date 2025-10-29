image_speed = 0;
yOffset = 0;
itemData = undefined;


function Interacted(){
	var itemData = obj_stats.inventory.GetItemsData(itemId);
	var freeSlot = obj_stats.FindFreeSetSlot();
	var usable   = itemData.IsClass(ITEM_CLASS_USE | ITEM_CLASS_SPELL);				
							
	//if freeSlot > -1 and usable then {	
	//	obj_stats.setItems[freeSlot] = itemData;
	//}else{
	//	obj_stats.inventory.AddItem(itemData.id);
	//}//end if
				
	obj_stats.inventory.AddItem(itemData.id);

	var damId = instance_create_depth(x + 8,y,depth-1,obj_damage);

	damId.value = itemData.name;
	instance_destroy();
}//end if