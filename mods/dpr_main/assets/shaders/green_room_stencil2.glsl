vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    if (Texel(tex, texture_coords).b == 1) {
        return vec4(1.0);
    }
    discard;
}