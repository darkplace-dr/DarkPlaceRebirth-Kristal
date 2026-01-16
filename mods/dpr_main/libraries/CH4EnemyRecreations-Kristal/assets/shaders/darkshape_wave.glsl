extern number wave_mag;
extern number wave_timer;
extern vec2 texsize;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    number i = texture_coords.y * texsize.y;
    vec2 coords = vec2(max(0.0, min(1.0, texture_coords.x + ((sin(i + wave_timer) * wave_mag) / 2) / texsize.x)), max(0.0, min(1.0, texture_coords.y + 0.0)));
    return Texel(texture, coords) * color;
}