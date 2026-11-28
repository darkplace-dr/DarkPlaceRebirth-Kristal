uniform float saturation;
uniform float brightness;
uniform float tone_factor;
uniform vec3 tone_dark;
uniform vec3 tone_light;

vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {
    vec4 col = Texel(image, uvs);
    float lum = dot(col.rgb, vec3(0.3, 0.59, 0.11));
	
	vec3 final_col = mix(vec3(lum),col.rgb,saturation); //determine base color
	
	vec3 tone_col = mix(tone_dark,tone_light,lum); //determine tone color based on lum
	final_col *= mix(vec3(1.0),tone_col,tone_factor); //add tone
	
	final_col *= brightness; //set brightness
    return vec4(final_col.rgb, col.a);
}