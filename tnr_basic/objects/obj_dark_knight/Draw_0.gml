DrawSprite(currentAnimation);
//DrawState(x,y-20);

if HasState(ST_ATTACKING) {
	attackTimer += 1;
	if attackTimer > 29 then {
		ChangeState(ST_STANDING);
		attackTimer = 0;
	}//end if
}//end if 


//if x != destX and y != destY then {
	//draw_text_hue(x-32,y,"dx" + string(destX) + "\n" + "dy" + string(destY) ,c_emerald);
	//draw_text_hue(x,y-8,string(id),c_emerald);
//}//end if

//draw_text_hue(x,y,stats.hp,c_emerald);
//DrawDebug(x + 16,y);

//DrawLineOfSight(x,y,stats.target.x,stats.target.y);
