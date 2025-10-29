function tile_set(tileIndex, flipX = false, flipY = false, rotate = false){
	tileIndex = tile_set_rotate(tileIndex,rotate);
	tileIndex = tile_set_flip(tileIndex,flipY);
	tileIndex = tile_set_mirror(tileIndex,flipX);
	return tileIndex;
}//end function

function print(argument0) {
	show_debug_message(argument0)
}	
	
function string_roman(value) {
	    var roman;
	    if ((value < 1) || (value > 4999)) return "";
	    roman  = string_copy("    M   MM  MMM MMMM",4*(value div 1000)+1,4);
	    roman += string_copy("    C   CC  CCC CD  D   DC  DCC DCCCCM  ",4*((value mod 1000) div 100)+1,4);
	    roman += string_copy("    X   XX  XXX XL  L   LX  LXX LXXXXC  ",4*((value mod 100) div 10)+1,4);
	    roman += string_copy("    I   II  III IV  V   VI  VII VIIIIX  ",4*(value mod 10)+1,4);
	    roman  = string_replace_all(roman," ","");
	    return roman;
}

function string_is_numeric(str) {
	var index = 1;
	var code = 0;

	repeat string_length(str) {
		code = string_ord_at(str,index);
		if code < 48 || code > 57 return false;
		index += 1;
	}//end if

	return true


}

function string_split(str, delimiter){
	var l_num=0;
	var l_arr=array_create(string_count(delimiter,str)+1);
	
	for(var l_pos=string_pos(delimiter,str);l_pos>0;l_pos=string_pos(delimiter,str)){
		l_arr[@l_num]=string_copy(str,1,l_pos-1);
		l_num++;
		str = string_delete(str,1,l_pos);
	}//end for
	
	l_arr[@l_num] = str;
	return l_arr;
}//end function

function array_shuffle(array) {
	if not is_array(array) then show_error("argument not array", true);
		
	var lst_array = ds_list_create();
		
	for (var i = 0; i < array_length(array); ++i) {
		lst_array[| i] = array[i];
	}//end for
		
	ds_list_shuffle(lst_array);

	for (var i = 0; i < array_length(array); ++i) {
		array[i] = lst_array[| i];
	}//end for
		
	ds_list_destroy(lst_array);
		
	return array;	
}//end functon

function draw_menu_box(x,y,width,height, bg_color, border_color, title, show_bg){
	
	if show_bg then {
		draw_rect_filled(x,y,width, height,bg_color);
	}else{
		draw_rect(x,y,width, height,bg_color);			
	}
	draw_rect(x + 2,y + 3,width - 4, height - 6,border_color);	
	draw_rect(x + 3,y + 4,width - 6, height - 8,border_color);
	
	if not is_undefined(title) then {
		draw_rect_filled(x+8,y,string_width(title), 8,bg_color);	
		draw_text_hue(x + 9, y, title, border_color)
	}//end if
}//end function

function draw_healthbar_box(StartX , StartY , EndX , BackCol, ForeCol, Percent) {
	var Width  = ((EndX - StartX) div 8) - 2;

	draw_healthbar(StartX + 2, StartY + 1, EndX - 2,StartY + 6,Percent,BackCol,ForeCol,ForeCol,0,true,false);

	//DRAW LEFT SIDE
	draw_sprite(spr_menu_border,2 ,StartX,StartY);

	//DRAW MIDDLE 
	draw_sprite_ext(spr_menu_border, 3 , StartX + 8, StartY,Width,1,0,c_white,1);

	//DRAW RIGHT SIDE
	draw_sprite_ext(spr_menu_border,2 ,EndX,StartY,-1,1,0,c_white,1);
}

function string_bin(dec){
     var bin;

     if (dec) then {
		 bin = ""
	 }else{
		 bin = "0";
	 }//end if
	 
     while (dec) {
         bin = string_char_at("01",(dec & 1) + 1) + bin;
         dec = dec >> 1;
     }//end while
     
     return bin;
}

function string_lpad(str, len, pad_char) {
	str = string(str);
	var padsize = string_length(pad_char);
	var padding = max(0,len - string_length(str));
	var out  = string_repeat(pad_char,padding div padsize);
	out += string_copy(pad_char,1,padding mod padsize);
	out += str;
	out  = string_copy(out,1,len);
	return out;
}//end function

function draw_text_hue(_x,_y,_string,_hue) {
	draw_text_color(_x,_y,_string,_hue,_hue,_hue,_hue,1);
}

function draw_text_ext_hue(_x,_y,_string,_sep,_w,_hue) {
	draw_text_ext_color(_x,_y,_string,_sep,_w,_hue,_hue,_hue,_hue,1);
}

function sound_play(_sound, _loop) {
	audio_play_sound(_sound, 0, _loop);
}

function sound_stop(_sound) {
	audio_stop_sound(_sound)
}

function sound_play_pitch(_sound, _loop, _pitch) {
	var sid = audio_play_sound(_sound,0, _loop);
	audio_sound_pitch(_sound, _pitch);
}
	
function set_background_tile_quad(cellX, cellY, tileIndexArray){
	tilemap_set(obj_stats.background_tilemap,tileIndexArray[0],cellX + 0,cellY + 0);//tl
	tilemap_set(obj_stats.background_tilemap,tileIndexArray[1],cellX + 1,cellY + 0);//tr
	tilemap_set(obj_stats.background_tilemap,tileIndexArray[2],cellX + 0,cellY + 1);//bl
	tilemap_set(obj_stats.background_tilemap,tileIndexArray[3],cellX + 1,cellY + 1);//br
}

function middle_y() {
	var obj = id;
	if argument_count == 1 then obj = argument[0];

	var bbox_height = obj.bbox_bottom - obj.bbox_top;
	return obj.bbox_top + bbox_height div 2;
}

function middle_x() {
	var obj = id;
	if argument_count == 1 then obj = argument[0];

	var bbox_width = obj.bbox_right - obj.bbox_left;
	return obj.bbox_left + bbox_width div 2;
}

function collision_tile(x,y) {
	//array_get()
	var tileIndex = tilemap_get_at_pixel(obj_stats.collision_tilemap,x , y)
	return tileIndex = 1;
}//end if

function collision_tile_index(x,y) {
	return tilemap_get_at_pixel(obj_stats.collision_tilemap,x , y);
}//end if

function draw_rect(x, y, width, height, color){
	draw_sprite_ext(spr_pixel,0,x,y,width - 1,1,0,color,1);	
	draw_sprite_ext(spr_pixel,0,x + width - 1,y,1,height ,0,color,1);	
	draw_sprite_ext(spr_pixel,0,x+width,y+height-1,-width,1,0,color,1);	
	draw_sprite_ext(spr_pixel,0,x,y+height,1,-height,0,color,1);	
}

function draw_rect_filled(x, y, width, height, color){
	draw_sprite_ext(spr_pixel,0,x,y,width,height,0,color,1);		
}

function array_min_index(_array){
	var minimum = _array[0];	
	var minimumIndex = 0;	
	var count = array_length(_array);
	
	for (var index = 1; index < count; index += 1) {
	    if _array[index] < minimum then {
			minimum = _array[index];
			minimumIndex = index;
		}//end if
	}//end for
	
	return minimumIndex;
}

function snap(value, snapValue) {
	return value div snapValue * snapValue;	
}

function choose_array(array){
	return array[irandom(array_length(array) - 1)];
}//end function

function generate_sprite_from_map(tile_data) {

	var col_arr = TILE_COLOR;
	var map_width  = tile_data.width;
	var map_height = tile_data.height;

	var surf = surface_create(map_width,map_height);

	surface_set_target(surf);
		draw_clear_alpha(c_black,0);

		for(var tile_x = 0; tile_x < map_width; tile_x++) {
			for(var tile_y = 0; tile_y < map_height; tile_y++){
				var col = col_arr[tile_data.data[tile_x][tile_y]];
				var r = color_get_red(col);
				var g = color_get_green(col);
				var b = color_get_blue(col);
				col = make_color_rgb(b, g, r);
				draw_point_color(tile_x,tile_y,col)
			}
		}
	surface_reset_target();

	var spr = sprite_create_from_surface(surf,0,0,map_width,map_height,0,0,0,0);
	surface_free(surf);
	return spr;
}
		
	
function perlin1D(seed, output_size, octaves) {
	//setup
		random_set_seed(seed);
		noise_seed   = [];
		perlin_noise = [];
	
	//build seed array
		for (var i = 0; i < output_size; ++i) {
			noise_seed[i] = random(1)
		}//end for
			
	//make noise
		for (var i = 0; i < output_size; i++) {
			var noise = 0.0;
			var scale = 1;
			var scale_accumulate = 0.0;
		
			for (var o = 0; o < octaves; o++) {
				var pitch = max(output_size >> o, 1);
				var sample_1 = (i div pitch) * pitch;
				var sample_2 = (sample_1 + pitch) mod output_size; 
				var blend   = (i - sample_1) / pitch;
				var sample = (1 - blend) * noise_seed[sample_1] + blend * noise_seed[sample_2];
				noise += sample * scale;
				scale_accumulate += scale;
				scale = scale / 2;
			}//end for
		
			perlin_noise[i] = noise / scale_accumulate;
		}//end for
	
	return perlin_noise;
}//end function
	
function shuffle_array_1d(array) {
	if not is_array(array) then show_error("argument not array", true);
		
	var lst_array = ds_list_create();
		
	for (var i = 0; i < array_length(array); ++i) {
		lst_array[| i] = array[i];
	}//end for
		
	ds_list_shuffle(lst_array);

	for (var i = 0; i < array_length(array); ++i) {
		array[i] = lst_array[| i];
	}//end for
		
	ds_list_destroy(lst_array);
		
	return array;	
}//end functon




function random_name(max_name_length) {
	
	//return random_name_2(max_name_length);
		
	function vowel_cluster(current_name, max_name_length) {
		var vowels             = [ "a", "e", "i", "o", "u", "y" ];
			
		var vowels_clusters    = [  "ar", "ist", "ust", "ate","al", "ette","ul", "an", "en", "er", "el", "on" ,"out", "ong" ,"era" , "erl", "ail", "ow", "igh", "ick", "ack", "oo","ee","ai","ure", "ae", "ie", "ea", "oa", "oi", "io", "ou", "ia", "ay","oy", "ure", "oil", "en", "oth", "ot", "ent", "ust"  ];
		vowels            	   = shuffle_array_1d(vowels);          
		vowels_clusters        = shuffle_array_1d(vowels_clusters);
			
		var new_part        = "";
		var new_part_length = 0;
		var current_name_length = string_length(current_name);
		var done = false;
			
		if (current_name_length < max_name_length) {		
			while not done {		
				if (irandom(100) < 75 ) {
				    new_part = vowels[irandom(array_length_1d(vowels) - 1)];
				}else{
				    new_part = vowels_clusters[irandom(array_length_1d(vowels_clusters) - 1)];
				}//end if	
				new_part_length = string_length(new_part);	
					
				done = new_part_length + current_name_length <= max_name_length;
			}//end while
		}//end if
			
		return new_part;					
	}//end function
	
	function conosnant_cluster(current_name, max_name_length) {
		var consonants         = ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "l", "n", "r", "s", "t", "v", "w", "x", "z"];
		var consonant_clusters = ["gg","ll","bul","bol","bal","be","ber","bl","br","ch","cl","cr","dr","dw","fl","fr","gl","gr","kn","la","lo","lou","na","ph","pl","pr","qu","ra","re","ri","ro","ru","sa","sh","sl","sm","sn","sp","st","sw","ter","th","tr","tw","zh"];
		consonants        	   = shuffle_array_1d(consonants);        
		consonant_clusters	   = shuffle_array_1d(consonant_clusters);
			
		var new_part        = "";
		var new_part_length = 0;
		var current_name_length = string_length(current_name);
		var done = false;
			
		if (current_name_length < max_name_length) {			
			while not done {				
				if (irandom(100) < 75) {
					new_part = consonants[irandom(array_length_1d(consonants) - 1)];
				}else{
					new_part = consonant_clusters[irandom(array_length_1d(consonant_clusters) - 1)];
				}//end if
				new_part_length = string_length(new_part);
					
				done = new_part_length + current_name_length <= max_name_length
			}//end while
		}//end if
		
		return new_part;		
	}//end function	
		
	var return_name = "";
	var name_length = 0;
	vowel = choose(true, false);
	
	while (name_length < max_name_length) {			
		if vowel then {
			return_name += vowel_cluster(return_name,max_name_length);	
				
			if choose(true,false,false) {
				//return_name += vowel_cluster(return_name,max_name_length);	
			}//end if 

		}else{
			return_name += conosnant_cluster(return_name,max_name_length);				
		}//end if
		vowel = not vowel;
		name_length = string_length(return_name);
	}//end while

	var first_letter = string_char_at(return_name,1);
	return_name = string_delete(return_name,1,1);
	return string_upper(first_letter) + return_name;
}//end function


function random_name_2(max_length) {
    if (max_length < 4) return "";

    var consonants = ["b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z","ba","be","bi","bo","bu","by","bl","br","bh","bw","ca","ce","ci","co","cu","cy","ch","cl","cr","ck","cm","cn","ct","da","de","di","do","du","dy","dr","dw","dh","dl","ds","dt","fa","fe","fi","fo","fu","fy","fl","fr","ft","fn","fh","ga","ge","gi","go","gu","gy","gl","gr","gh","gn","ha","he","hi","ho","hu","hy","hr","ja","je","ji","jo","ju","jy","ka","ke","ki","ko","ku","ky","kl","kr","kn","la","le","li","ll","lo","lu","ly","lac","lad","lag","lam","lan","lap","lar","las","lat","lav","law","lay","leb","led","leg","lem","len","lep","ler","les","let","lev","lew","lex","lib","lid","lig","lim","lin","lip","lir","lis","lit","liv","lob","lod","log","lom","lon","lop","lor","los","lot","lov","low","lub","luc","lud","lug","lum","lun","lur","lus","lut","lux","lym","lyn","lyr","lyt","ma","me","mi","mo","mu","my","na","ne","ni","no","nu","pa","pe","pi","po","pu","py","pl","pr","ph","ps","qua","que","qui","quo","quy","qul","qun","ra","re","ri","ro","ru","ry","sa","se","si","so","su","sy","sc","sh","sk","sl","sm","sn","sp","sr","st","sw","sph","spl","spr","squ","str","scr","shr","ta","te","ti","to","tu","ty","th","tr","tw","tl","va","ve","vi","vo","vu","vy","vl","vr","wa","we","wi","wo","wu","wy","wh","wr","wl","xa","xe","xi","xo","xu","ya","ye","yi","yo","yu","yy","yl","yr","ys","za","ze","zi","zo","zu","zy","zl"];
    
	var vowels = [
        "a","e","i","o","u","y",
        "aa","ae","ai","ao","au","ay","ea","ee","ei","eo","eu","ey","ia","ie","io","iu","oa","oe","oi","oo","ou","oy","ua","ue","ui","uo","uy",
        "aia","eia","iou","eau","aei","iou","uae","ioe","eoi","aui","oeu","eyo","iya","ayi","eyo","iou"
    ];

    var prefixes = [
        "Al","El","Ka","Lo","Ma","Sha","Tor","Zan","Vor","Ny","Ser","Gal","Fen","Rha","Thal",
        "Ar","Bel","Cal","Dar","Eri","Fael","Gor","Hel","Is","Jen","Kor","Lys","Mor","Nor","Orin",
        "Per","Quel","Rin","Syl","Tan","Ul","Val","Wyn","Xan","Yel","Zor"
    ];

    var suffixes = [
        "en","ar","is","or","an","el","us","ix","on","ir","al","um","as","ur","os",
        "ron","mir","vek","dor","zan","lek","tor","rim","val","sen","lom","dur","zel","rak","tis",
        "ian","ion","iel","eth","ess","ous","ius","ean","ara","ira","ora","yre","ane","iel","uin","ara","ght","all","ill","ull","oll"
    ];

    var prefix = "";
    var suffix = "";

    if (random(1) < 0.5) {
        prefix = prefixes[irandom(array_length(prefixes) - 1)];
    }

    if (random(1) < 0.5) {
        suffix = suffixes[irandom(array_length(suffixes) - 1)];
    }

    var remaining = max_length - string_length(prefix) - string_length(suffix);
    if (remaining < 1) {
        var trimmed = string_copy(prefix + suffix, 1, max_length);
        var first = string_upper(string_char_at(trimmed, 1));
        var rest = string_copy(trimmed, 2, max_length - 1);
        return first + rest;
    }

    var core = "";
    var use_consonant = true;

    while (string_length(core) < remaining) {
        var next = "";
        if (use_consonant) {
            next = consonants[irandom(array_length(consonants) - 1)];
        } else {
            next = vowels[irandom(array_length(vowels) - 1)];
        }

        if (string_length(core) + string_length(next) > remaining) {
            break;
        }

        core += next;
        use_consonant = !use_consonant;
    }

    var name = prefix + core + suffix;
    var first_letter = string_upper(string_char_at(name, 1));
    var rest_of_name = string_copy(name, 2, string_length(name) - 1);
    return first_letter + rest_of_name;
}
