event_inherited();

var dead     = (stats.status & STATUS_KO) > 0
var reading  = instance_exists(obj_textbox) or obj_stats.menuOpen;
var fighting = obj_stats.attackQueue.IsEmpty() == false;

if not (reading or dead or fighting) then {
	PlayerAction();
	PlayerMovement();
}//end if

PlayerAnimate();