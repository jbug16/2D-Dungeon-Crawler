depth = -255
State            = $0;
LastRoomState    = $0;
controller_index = 0;


#region BUTTON VARS
	axis_p_up = 0;
	axis_p_dn = 0;
	axis_p_lf = 0;
	axis_p_rt = 0;

	axis_lv         = false; 
	axis_lh         = false; 
	axis_up         = false; 
	axis_dn         = false; 
	axis_lf         = false; 
	axis_rt         = false; 

	dpad_up         = false; 
	dpad_dn         = false; 
	dpad_lf         = false; 
	dpad_rt         = false; 
	button_a	    = false; 
	button_b	    = false; 
	button_x	    = false; 
	button_y	    = false; 
	button_l	    = false; 
	button_r	    = false; 
	button_select   = false; 
	button_start    = false; 
	kboard_up       = false; 
	kboard_dn       = false; 
	kboard_lf       = false; 
	kboard_rt       = false; 
	kboard_a	    = false; 
	kboard_b	    = false; 
	kboard_x	    = false; 
	kboard_y	    = false; 
	kboard_l	    = false; 
	kboard_r	    = false; 
	kboard_select   = false; 
	kboard_start    = false; 
	dpad_p_up       = false; 
	dpad_p_dn       = false; 
	dpad_p_lf       = false; 
	dpad_p_rt       = false; 
	button_p_a	    = false; 
	button_p_b	    = false; 
	button_p_x	    = false; 
	button_p_y	    = false; 
	button_p_l	    = false; 
	button_p_r	    = false; 
	button_p_select = false; 
	button_p_start  = false; 
	kboard_p_up     = false; 
	kboard_p_dn     = false; 
	kboard_p_lf     = false; 
	kboard_p_rt     = false; 
	kboard_p_a	    = false; 
	kboard_p_b	    = false; 
	kboard_p_x	    = false; 
	kboard_p_y	    = false; 
	kboard_p_l	    = false; 
	kboard_p_r	    = false; 
	kboard_p_select = false; 
	kboard_p_start  = false; 

	RepeatUp     = false;
	RepeatDown   = false;
	RepeatLeft   = false;
	RepeatRight  = false;
	RepeatA      = false;
	RepeatB      = false;
	RepeatX      = false;
	RepeatY      = false;
	RepeatL      = false;
	RepeatR      = false;
	RepeatSelect = false;
	RepeatStart  = false;

	repeat_timer = 30;
	repeat_speed = 4;
	TimerUp      = 0;
	TimerDown    = 0;
	TimerLeft    = 0;
	TimerRight   = 0;
	TimerA       = 0;
	TimerB       = 0;
	TimerX       = 0;
	TimerY       = 0;
	TimerL       = 0;
	TimerR       = 0;
	TimerSelect  = 0;
	TimerStart   = 0;
#endregion

#region KEYBOARD MAPPINGS
	KeyUp       = vk_up;
	KeyDown     = vk_down;
	KeyLeft     = vk_left;
	KeyRight    = vk_right;
	KeyA        = ord("X");
	KeyB        = ord("Z");
	KeyX        = ord("A");
	KeyY        = ord("S");
	KeyL        = ord("D");
	KeyR        = ord("C");
	KeySelect   = vk_tab;
	KeyStart    = vk_enter;
#endregion

#region CONTROLLER STATES
	#macro K_UP     0x1    
	#macro K_DOWN   0x2    
	#macro K_LEFT   0x4    
	#macro K_RIGHT  0x8    
	#macro K_B      0x10   
	#macro K_A      0x20   
	#macro K_X      0x40   
	#macro K_Y      0x80   
	#macro K_L      0x100  
	#macro K_R      0x200  
	#macro K_SELECT 0x400
	#macro K_START  0x800
         
	#macro K_PUP     0x1000  
	#macro K_PDOWN   0x2000 
	#macro K_PLEFT   0x4000 
	#macro K_PRIGHT  0x8000 
	#macro K_PB      0x10000 
	#macro K_PA      0x20000 
	#macro K_PY      0x40000
	#macro K_PX      0x80000
	#macro K_PL      0x100000
	#macro K_PR      0x200000
	#macro K_PSELECT 0x400000
	#macro K_PSTART  0x800000

	#macro K_RUP     0x1000000   
	#macro K_RDOWN   0x2000000   
	#macro K_RLEFT   0x4000000   
	#macro K_RRIGHT  0x8000000   
	#macro K_RB      0x10000000  
	#macro K_RA      0x20000000  
	#macro K_RY      0x40000000  
	#macro K_RX      0x80000000  
	#macro K_RL      0x100000000 
	#macro K_RR      0x200000000 
	#macro K_RSELECT 0x400000000
	#macro K_RSTART  0x800000000	
#endregion


function CheckButton(buttonConstant) {
	return (State & buttonConstant) > 0;
}//end function

function CheckButtonThenClear(buttonConstant) {
	var pressed = (State & buttonConstant) > 0;
	if pressed then State = State & ~buttonConstant
	return pressed;
}//end function

function ClearButtons() {
	State = 0;
}//end function

function CheckButtonLeftRight() {
	return CheckButton(K_RRIGHT) - CheckButton(K_RLEFT);
}//end function

function CheckButtonDownUp() {
	return CheckButton(K_RDOWN) - CheckButton(K_RUP);
}//end function