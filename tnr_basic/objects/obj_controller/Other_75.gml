var system_event_data = async_load;

var discovered_gamepad = system_event_data[? "event_type"] == "gamepad discovered";

if discovered_gamepad then {
	controller_index = system_event_data[? "pad_index"];	
}//end if

