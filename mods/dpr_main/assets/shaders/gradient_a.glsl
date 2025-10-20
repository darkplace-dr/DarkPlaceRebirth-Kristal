extern vec3 from;
extern vec3 to;
extern number scale;
vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
{
    vec4 froma = vec4(from.r, from.g, from.b, 1);
    vec4 toa = vec4(to.r, to.g, to.b, 0);
    return Texel(tex, texture_coords) * (froma + (toa - froma) * mod(texture_coords.y / scale, 1.0)) * color;
}