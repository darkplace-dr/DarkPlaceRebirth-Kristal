vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 pixel = Texel(texture, texture_coords); // get pixel color
    pixel.rgb = vec3(1.0) - pixel.rgb; // invert RGB
    return pixel * color; // multiply by input color (usually white)
}
