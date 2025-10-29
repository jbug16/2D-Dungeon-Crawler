function MusicData(_bgmId,_loopStart,_loopEnd, _looping) constructor {
	bgmId	  = _bgmId;
	loopStart = _loopStart;
	loopEnd	  = _loopEnd;
	looping	  = _looping;
	musicId   = undefined;
	
	function Play(playbackRate = 1) {	
		 audio_sound_loop_start(bgmId, loopStart);
		 audio_sound_loop_end(bgmId, loopEnd);
		 musicId = audio_play_sound(bgmId, 255, looping);
		 audio_sound_pitch(bgmId, playbackRate);
	}//end function
	
	function Stop() {	
		 if is_undefined(musicId) then exit;
		 audio_stop_sound(musicId);
		 musicId = undefined;
	}//end function
	
}//end struct