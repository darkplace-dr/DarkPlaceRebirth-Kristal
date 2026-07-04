uniform vec4 shadowCol;
uniform vec2 pixelw;

vec4 effect(vec4 color, Image img, vec2 texture_coords, vec2 pixel_coords) {
    vec4 col = Texel(img, texture_coords);
	float _px = texture_coords.x - (pixelw.x*6.0);
	if (_px < pixelw.y)
	{
		col.rgb = shadowCol.rgb;
		if (col.a > 0.0) col.a = min(shadowCol.a, col.a);
	}
	if (Texel(img, vec2(_px, texture_coords.y)).a <= 0.0)
	{
		col.rgb = shadowCol.rgb;
		if (col.a > 0.0) col.a = min(shadowCol.a, col.a);
	}
    return color * col;
}