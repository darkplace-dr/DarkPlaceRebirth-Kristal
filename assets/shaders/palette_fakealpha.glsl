#define TOLERANCE 0.004
uniform Image palette_tex;
uniform vec4 palette_uvs;
uniform float palette_id;
uniform vec2 pixel_size;
uniform float final_alpha;

vec3 find_alt_color(vec3 in_color, vec2 corner)
{
    float dist;
    vec2 test_pos;
    vec3 left_color;
    for (float i = corner.y; i < palette_uvs.w; i += pixel_size.y) {
		test_pos = vec2(corner.x, i);
		left_color = Texel(palette_tex, test_pos).rgb;
        
		dist = distance(left_color, in_color);

		if (dist < TOLERANCE) {
			test_pos = vec2(corner.x + pixel_size.x * floor(palette_id + 1.0), i);
			return mix(Texel(palette_tex, vec2(test_pos.x - pixel_size.x, test_pos.y)).rgb, Texel(palette_tex, test_pos).rgb, fract(palette_id));
		}
    }
    return in_color;
}

vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {
    vec4 pixel = Texel(image, uvs);
    if (pixel.a == 0.0) {
        discard;
    }
	vec4 final_pixel = vec4(find_alt_color(pixel.rgb, palette_uvs.xy), 1.0);
    pixel = vec4(final_pixel.rgb, final_alpha);
    return pixel*color;
}