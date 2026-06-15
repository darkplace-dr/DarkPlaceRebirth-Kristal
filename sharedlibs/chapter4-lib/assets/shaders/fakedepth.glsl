uniform vec2 iExtents;
uniform float iCenterX;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
	float uvadjust = clamp((texture_coords.x-iCenterX) * 1.05, -iExtents.x, iExtents.y);
	vec2 adjustedUV = vec2(uvadjust + iCenterX, texture_coords.y);
    float ds = Texel(tex, adjustedUV).a;
	ds = mix(0.0, ds, 1.0-sign(abs(texture_coords.x-iCenterX)-(iExtents.y)));
    vec4 col2 = color * Texel(tex, texture_coords);
	float dist = abs(adjustedUV.x-texture_coords.x);
    vec4 col = color * Texel(tex, texture_coords);
    col.rgb = mix(vec3(ds * (0.08-2.0*dist)), col2.rgb, col2.a);
	col.a = mix(0.0, 1.0, max(ds - 2.0 * dist, 0.0) + col2.a);
	return col;
}