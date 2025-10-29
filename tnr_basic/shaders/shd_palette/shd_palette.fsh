varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform int num;
uniform vec3 palette[100];

void main()
{
	int minimumIndex = 0;
	vec3 fragmentColor = texture2D(gm_BaseTexture, v_vTexcoord).rgb;
	vec3 col2[100];
	float minimumDistance = 1000.0;
	
	for (int index = 0; index < 100; index++) {
		if (index == num) {break;}
		
		col2[index] = palette[index] / 255.0;
		
		float colorDistance = distance(fragmentColor,col2[index]);
		
		if (colorDistance < minimumDistance) {
			minimumIndex = index;
			minimumDistance = colorDistance;
		}
	}
	
    gl_FragColor = vec4(col2[minimumIndex],1.0);
}
