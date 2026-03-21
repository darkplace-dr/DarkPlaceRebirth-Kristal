uniform Image sampler_1;
uniform Image sampler_2;
uniform float time;
uniform float opacity;
uniform float camx;
uniform float camy;
uniform vec3 col;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
	float time2 = -time * 0.5;
	//vec3 _col = vec3(0.2588,0.8157,1.0);
	vec2 _xy = vec2(mod(screen_coords.x/2.0 + time - camx,256.0)/256.0, mod(screen_coords.y/2.0 + time - camy,256.0)/256.0);
	vec2 _xy2 = vec2(mod(screen_coords.x/2.0 + time2 - camx,256.0)/256.0, mod(screen_coords.y/2.0 + time2 - camy,256.0)/256.0);
    vec4 pixel = color * Texel(tex, texture_coords);
	pixel.rgb = Texel(sampler_1, _xy ).rgb;
	//pixel.rgb = pixel.rgb + (0.2 * Texel(sampler_1, _xy2 ).rgb);
	pixel.rgb = col * (pixel.rgb + (Texel(sampler_2, _xy ).rgb * (0.4 * (1.0+sin(time*0.1)))));
	pixel.a = pixel.a * opacity;
	return pixel;
}