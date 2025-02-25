extern vec4 targetColor;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 texcolor = Texel(texture, texture_coords);

    if (texcolor.r > 0.0 || texcolor.g > 0.0 || texcolor.b > 0.0) {
        return targetColor * color; // Non-black pixels to target color
    } else {
        return texcolor * color; // Keep black pixels unchanged
    }
}
