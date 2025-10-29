// Inherit the parent event
event_inherited();
UpdateAnimations();

stats.lvl = 1;


stats.equipment.leftHand  = obj_stats.inventory.GetItemsData(ITEM_EMPTY);
stats.equipment.rightHand = obj_stats.inventory.GetItemsData(ITEM_EMPTY);
stats.equipment.head      = obj_stats.inventory.GetItemsData(ITEM_EMPTY);
stats.equipment.body      = obj_stats.inventory.GetItemsData(ITEM_EMPTY);
stats.equipment.acc       = obj_stats.inventory.GetItemsData(ITEM_EMPTY);

stats.RecalculateBaseStats();
stats.att = 10;



