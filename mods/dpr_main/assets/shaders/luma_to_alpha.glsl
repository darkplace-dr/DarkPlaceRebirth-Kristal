vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
{
    vec4 outputcolor = Texel(tex, texture_coords) * color;
	float alphamult = color.a;
	vec4 col = Texel(tex, texture_coords);
    outputcolor.rgba = vec4(0, 0, 0, (1-((col.r+col.g+col.b)/3))*alphamult);
    return outputcolor;
}