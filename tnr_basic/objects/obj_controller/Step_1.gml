///EXIT IF IDLE
//if not (keyboard_check(vk_anykey) or keyboard_check_released(vk_anykey)) and State = 0 then exit;



axis_lv         = gamepad_axis_value(controller_index, gp_axislv);
axis_lh         = gamepad_axis_value(controller_index, gp_axislh);
		    
axis_up         = axis_lv <= -.5;
axis_dn         = axis_lv >=  .5;
axis_lf         = axis_lh <= -.5;
axis_rt         = axis_lh >=  .5;




		    
dpad_up         = gamepad_button_check(controller_index, gp_padu);
dpad_dn         = gamepad_button_check(controller_index, gp_padd);
dpad_lf         = gamepad_button_check(controller_index, gp_padl);
dpad_rt         = gamepad_button_check(controller_index, gp_padr);
			
button_b	    = gamepad_button_check(controller_index, gp_face1)     
button_a	    = gamepad_button_check(controller_index, gp_face2)     
button_x	    = gamepad_button_check(controller_index, gp_face3)     
button_y	    = gamepad_button_check(controller_index, gp_face4)     
button_l	    = gamepad_button_check(controller_index, gp_shoulderl) 
button_r	    = gamepad_button_check(controller_index, gp_shoulderr) 	    
button_select   = gamepad_button_check(controller_index, 6)    
button_start    = gamepad_button_check(controller_index, 7)     
	    
kboard_up       = keyboard_check(KeyUp   );
kboard_dn       = keyboard_check(KeyDown );
kboard_lf       = keyboard_check(KeyLeft );
kboard_rt       = keyboard_check(KeyRight);
		  	
kboard_b	    = keyboard_check(KeyB);	
kboard_a	    = keyboard_check(KeyA);	
kboard_x	    = keyboard_check(KeyX);	
kboard_y	    = keyboard_check(KeyY);	
kboard_l	    = keyboard_check(KeyL);
kboard_r	    = keyboard_check(KeyR);		  	
kboard_select   = keyboard_check(KeySelect);
kboard_start    = keyboard_check(KeyStart );

#region pressed axis	
	if axis_p_up == 0 then {
		if axis_lv <= -.5 then axis_p_up = 1;
	}else{
		if axis_p_up == 1 then {
			axis_p_up = -1;
		}else{
			if axis_lv >= -.5 then axis_p_up = 0;	
		}//end if
	}//end if
	
	if axis_p_dn == 0 then {
		if axis_lv >= .5 then axis_p_dn = 1;
	}else{
		if axis_p_dn == 1 then {
			axis_p_dn = -1;
		}else{
			if axis_lv <= .5 then axis_p_dn = 0;			 
		}//end if
	}//end if	

	if axis_p_lf == 0 then {
		if axis_lh <= -.5 axis_p_lf = 1;
	}else{
		if axis_p_lf == 1 then {
			axis_p_lf = -1;
		}else{
			if axis_lh >= -.5 then axis_p_lf = 0;			 
		}//end if
	}//end if

	if axis_p_rt == 0 then {
		if axis_lh >= .5 then axis_p_rt = 1;
	}else{
		if axis_p_rt == 1 then {
			axis_p_rt = -1;
		}else{
			if axis_lh <= .5 then axis_p_rt = 0;
		}//end if
	}//end if	
#endregion


dpad_p_up       = gamepad_button_check_pressed(controller_index, gp_padu);
dpad_p_dn       = gamepad_button_check_pressed(controller_index, gp_padd);
dpad_p_lf       = gamepad_button_check_pressed(controller_index, gp_padl);
dpad_p_rt       = gamepad_button_check_pressed(controller_index, gp_padr);
	
button_p_b	    = gamepad_button_check_pressed(controller_index, gp_face1)      
button_p_a	    = gamepad_button_check_pressed(controller_index, gp_face2)      
button_p_x	    = gamepad_button_check_pressed(controller_index, gp_face3)      
button_p_y	    = gamepad_button_check_pressed(controller_index, gp_face4)      
button_p_l	    = gamepad_button_check_pressed(controller_index, gp_shoulderl)  
button_p_r	    = gamepad_button_check_pressed(controller_index, gp_shoulderr)  
button_p_select = gamepad_button_check_pressed(controller_index, 6);//gp_select)     
button_p_start  = gamepad_button_check_pressed(controller_index, 7);//gp_start)      

kboard_p_up     = keyboard_check_pressed(KeyUp   );
kboard_p_dn     = keyboard_check_pressed(KeyDown );
kboard_p_lf     = keyboard_check_pressed(KeyLeft );
kboard_p_rt     = keyboard_check_pressed(KeyRight);

kboard_p_b	    = keyboard_check_pressed(KeyB);	
kboard_p_a	    = keyboard_check_pressed(KeyA);	
kboard_p_x	    = keyboard_check_pressed(KeyX);	
kboard_p_y	    = keyboard_check_pressed(KeyY);	
kboard_p_l	    = keyboard_check_pressed(KeyL);
kboard_p_r	    = keyboard_check_pressed(KeyR);
kboard_p_select = keyboard_check_pressed(KeySelect);
kboard_p_start  = keyboard_check_pressed(KeyStart );

State  = 0x0;

State += 0x1      * (axis_up       or dpad_up or kboard_up );   
State += 0x2      * (axis_dn       or dpad_dn or kboard_dn ); 
State += 0x4      * (axis_lf       or dpad_lf or kboard_lf ); 
State += 0x8      * (axis_rt       or dpad_rt or kboard_rt );
State += 0x10     * (button_b      or kboard_b            );
State += 0x20     * (button_a      or kboard_a            );
State += 0x40     * (button_x      or kboard_x            );
State += 0x80     * (button_y      or kboard_y            );
State += 0x100    * (button_l      or kboard_l            );      
State += 0x200    * (button_r      or kboard_r            );    
State += 0x400    * (button_select or kboard_select       );
State += 0x800    * (button_start  or kboard_start        ); 

State += 0x1000   * (axis_p_up       or dpad_p_up or kboard_p_up );
State += 0x2000   * (axis_p_dn       or dpad_p_dn or kboard_p_dn );
State += 0x4000   * (axis_p_lf       or dpad_p_lf or kboard_p_lf );
State += 0x8000   * (axis_p_rt       or dpad_p_rt or kboard_p_rt );    
State += 0x10000  * (button_p_b      or kboard_p_b              );
State += 0x20000  * (button_p_a      or kboard_p_a              );
State += 0x40000  * (button_p_x      or kboard_p_x              );
State += 0x80000  * (button_p_y      or kboard_p_y              );
State += 0x100000 * (button_p_l      or kboard_p_l              );      
State += 0x200000 * (button_p_r      or kboard_p_r              );    
State += 0x400000 * (button_p_select or kboard_p_select         );
State += 0x800000 * (button_p_start  or kboard_p_start          ); 

if ((State & 0x1  ) > 0) then {TimerUp      += 1; RepeatUp      = (((TimerUp     mod (repeat_timer div repeat_speed)) == 0) and (TimerUp     > repeat_timer)) or (State & 0x1000   > 0);}else{TimerUp     = 0; RepeatUp     = false;}//end if
if ((State & 0x2  ) > 0) then {TimerDown    += 1; RepeatDown    = (((TimerDown   mod (repeat_timer div repeat_speed)) == 0) and (TimerDown   > repeat_timer)) or (State & 0x2000   > 0);}else{TimerDown   = 0; RepeatDown   = false;}//end if
if ((State & 0x4  ) > 0) then {TimerLeft    += 1; RepeatLeft    = (((TimerLeft   mod (repeat_timer div repeat_speed)) == 0) and (TimerLeft   > repeat_timer)) or (State & 0x4000   > 0);}else{TimerLeft   = 0; RepeatLeft   = false;}//end if
if ((State & 0x8  ) > 0) then {TimerRight   += 1; RepeatRight   = (((TimerRight  mod (repeat_timer div repeat_speed)) == 0) and (TimerRight  > repeat_timer)) or (State & 0x8000   > 0);}else{TimerRight  = 0; RepeatRight  = false;}//end if
if ((State & 0x10 ) > 0) then {TimerB       += 1; RepeatB       = (((TimerB      mod (repeat_timer div repeat_speed)) == 0) and (TimerB      > repeat_timer)) or (State & 0x10000  > 0);}else{TimerB      = 0; RepeatB      = false;}//end if
if ((State & 0x20 ) > 0) then {TimerA       += 1; RepeatA       = (((TimerA      mod (repeat_timer div repeat_speed)) == 0) and (TimerA      > repeat_timer)) or (State & 0x20000  > 0);}else{TimerA      = 0; RepeatA      = false;}//end if
if ((State & 0x40 ) > 0) then {TimerX       += 1; RepeatX       = (((TimerX      mod (repeat_timer div repeat_speed)) == 0) and (TimerX      > repeat_timer)) or (State & 0x40000  > 0);}else{TimerX      = 0; RepeatX      = false;}//end if
if ((State & 0x80 ) > 0) then {TimerY       += 1; RepeatY       = (((TimerY      mod (repeat_timer div repeat_speed)) == 0) and (TimerY      > repeat_timer)) or (State & 0x80000  > 0);}else{TimerY      = 0; RepeatY      = false;}//end if
if ((State & 0x100) > 0) then {TimerL       += 1; RepeatL       = (((TimerL      mod (repeat_timer div repeat_speed)) == 0) and (TimerL      > repeat_timer)) or (State & 0x100000 > 0);}else{TimerL      = 0; RepeatL      = false;}//end if
if ((State & 0x200) > 0) then {TimerR       += 1; RepeatR       = (((TimerR      mod (repeat_timer div repeat_speed)) == 0) and (TimerR      > repeat_timer)) or (State & 0x200000 > 0);}else{TimerR      = 0; RepeatR      = false;}//end if
if ((State & 0x400) > 0) then {TimerSelect  += 1; RepeatSelect  = (((TimerSelect mod (repeat_timer div repeat_speed)) == 0) and (TimerSelect > repeat_timer)) or (State & 0x400000 > 0);}else{TimerSelect = 0; RepeatSelect = false;}//end if
if ((State & 0x800) > 0) then {TimerStart   += 1; RepeatStart   = (((TimerStart  mod (repeat_timer div repeat_speed)) == 0) and (TimerStart  > repeat_timer)) or (State & 0x800000 > 0);}else{TimerStart  = 0; RepeatStart  = false;}//end if
	
State += 0x1000000   * RepeatUp   ;   
State += 0x2000000   * RepeatDown ;
State += 0x4000000   * RepeatLeft ; 
State += 0x8000000   * RepeatRight;
State += 0x10000000  * RepeatB    ;    
State += 0x20000000  * RepeatA    ;    
State += 0x40000000  * RepeatY    ;    
State += 0x80000000  * RepeatX    ;    
State += 0x100000000 * RepeatL    ;    
State += 0x200000000 * RepeatR    ; 
State += 0x400000000 * RepeatSelect;    
State += 0x800000000 * RepeatStart; 