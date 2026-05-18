#define TRANSPARENT vec4(0.0, 0.0, 0.0, 0.0)
#define TOLERANCE 0.004
uniform Image palette_tex;
uniform vec2 pixel_size;
uniform float palette_id;

vec4 find_alt_color(vec4 in_color)
{
    if (in_color.a == 0.0) return TRANSPARENT;
    
    float dist;
    vec2 test_pos;
    vec4 left_color;
    for (float i = 0.0; i < 1.0; i += pixel_size.y) {
		test_pos = vec2(0.0, i);
		left_color = Texel(palette_tex, test_pos);
        
		dist = distance(left_color, in_color);

		if (dist < TOLERANCE) {
			test_pos = vec2(0.0 + pixel_size.x * floor(palette_id + 1.0), i);
			return mix(Texel(palette_tex, vec2(test_pos.x - pixel_size.x, test_pos.y)), Texel(palette_tex, test_pos), fract(palette_id));
		}
    }
    return in_color;
}

vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {
    vec4 pixel = Texel(image, uvs);
    if (pixel.a == 0.0) {
        discard;
    }
    pixel = find_alt_color(pixel);
    return pixel*color;
}