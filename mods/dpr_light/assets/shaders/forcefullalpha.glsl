vec4 effect(vec4 color, Image img, vec2 texture_coords, vec2 pixel_coords) {
    vec4 col = Texel(img, texture_coords);
	if (col.a > 0.0) col.a = 1.0;
    return color * col;
}