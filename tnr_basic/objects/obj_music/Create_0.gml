#macro BGM_EXPLORE 0

musicData = [];
currentMusic = undefined;
musicData[BGM_EXPLORE] = new MusicData(bgm_explore,15.483,46,451,true);

function Play(BGM_ID, pitch = 1) {
	if is_undefined(currentMusic) then {
		currentMusic = musicData[BGM_ID];
	}//end if
	
	currentMusic.Stop();
	currentMusic = musicData[BGM_ID];
	currentMusic.Play(pitch);

}//end function