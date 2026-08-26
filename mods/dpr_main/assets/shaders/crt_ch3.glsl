uniform vec2 texsize;
uniform float time;
uniform float vignette_scale;
uniform float vignette_intensity;
uniform float chromatic_scale;
uniform float filter_amount;
        
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords){
	vec4 col = Texel(texture, texture_coords);
	
	//RGB filter
	float rgbindex = floor(mod(pixel_coords.x+pixel_coords.y-time,3.));
	vec3 rgbcol = vec3(max(0.,1.-rgbindex),mod(rgbindex,2.0)*0.5,max(0.,rgbindex-1.));
	col.rgb = mix(col.rgb,rgbcol,filter_amount);

	//Chromatic aberration 
	float dist = length(texture_coords - vec2(0.5,0.5));
	dist *= chromatic_scale;
	float signdist = sign(chromatic_scale);
    float shift = texsize.x*(signdist+dist)*0.5;
    col.r = Texel(texture, vec2(texture_coords.x + shift, texture_coords.y)).r;
    col.b = Texel(texture, vec2(texture_coords.x - shift, texture_coords.y)).b;

	//Vignette
	vec2 vuv = texture_coords * (1.0 - texture_coords.yx);
    float vig = vuv.x*vuv.y * vignette_intensity;
    float bri = pow(vig, vignette_scale);
	col.rgb *= bri;
		
	return col * color;
}