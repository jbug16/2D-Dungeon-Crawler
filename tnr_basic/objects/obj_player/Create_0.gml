event_inherited();
UpdateAnimations();
stats.class = ACTOR_CLASS_PLAYER;
stats.sex = SEX_FEMALE;
stats.lvl = 2;

stats.equipment.leftHand  = obj_stats.inventory.GetItemsData(0);
stats.equipment.rightHand = obj_stats.inventory.GetItemsData(0);
stats.equipment.head      = obj_stats.inventory.GetItemsData(0);
stats.equipment.body      = obj_stats.inventory.GetItemsData(0);
stats.equipment.acc       = obj_stats.inventory.GetItemsData(0);

stats.RecalculateBaseStats();