uniform vec3 forceColour;

vec4 effect(vec4 color, Image img, vec2 texture_coords, vec2 pixel_coords) {
    vec4 col = Texel(img, texture_coords);
	col = color * col;
	col.rgb = mix(vec3(0.0,0.0,0.0), forceColour, col.a);
    return col;
}