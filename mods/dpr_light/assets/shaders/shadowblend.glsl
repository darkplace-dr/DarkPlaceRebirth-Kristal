uniform vec4 shadowCol;

vec4 effect(vec4 color, Image img, vec2 texture_coords, vec2 pixel_coords) {
    vec4 col = Texel(img, texture_coords);
	col.rgb = shadowCol.rgb;
	if (col.a > 0.0) col.a = min(shadowCol.a, col.a);
    return color * col;
}