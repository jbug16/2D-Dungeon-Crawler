
target = collision_point(x,y,mas_actor,false,true);

if target != parent and instance_exists(target) then {
	instance_destroy();	
}//end if

wallCollide = collision_tile(x,y);
doorCollide = collision_point(x,y,obj_door,false,true);

if wallCollide or doorCollide then {
	instance_destroy();
}//end if

if obj_stats.menuOpen then { 
	speed = 0;
}else{
	speed = 2
}//ebd if

if attackType == ATTACK_TYPE_MAGIC {
	timer += 1;

	if timer = 8 then {
		seqID = layer_sequence_create("lay_instances", x + hspeed, y + vspeed , spellData.travelSequence);
		timer = 0;
	}//end if
	
	sprite_index = spr_fire_ball;
	image_speed = .25;	
}//end if

if attackType == ATTACK_TYPE_THROW {
	sprite_index = thrownItemData.weaponSprite;
	image_index = 0;
	image_speed = 0;
	image_angle = direction;
}//end if