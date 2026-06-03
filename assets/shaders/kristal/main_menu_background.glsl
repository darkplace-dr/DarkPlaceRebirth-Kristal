uniform float bg_sine;
uniform float bg_mag;
uniform float wave_height;
uniform float sine_mul;
uniform vec2 texsize;
vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    float i = texture_coords.y * texsize.y;
    float bg_minus = ((bg_mag * (i / wave_height)) * 1.3);
    float wave_mag = max(0.0, bg_mag - bg_minus);
    vec2 coords = vec2(max(0.0, min(1.0, texture_coords.x + (sine_mul * sin((i / 8.0) + (bg_sine / 30.0)) * wave_mag) / texsize.x)), max(0.0, min(1.0, texture_coords.y + 0.0)));
    return Texel(texture, coords) * color;
}
