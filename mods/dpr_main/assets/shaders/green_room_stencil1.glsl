vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 sampled = Texel(tex, texture_coords);
    if (sampled.r == 1.0)
        return vec4(1.0);
    discard;
}