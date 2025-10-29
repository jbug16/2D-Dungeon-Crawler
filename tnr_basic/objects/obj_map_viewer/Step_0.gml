poiIndex += obj_controller.CheckButtonDownUp() ;
poiIndex += obj_controller.CheckButtonLeftRight() ;


if poiIndex >= array_length(poiData) then {
	poiIndex = 0;
}//end if

if poiIndex < 0 then {
	poiIndex = array_length(poiData) - 1;
}//end if