uniform vec2 u_uv;
uniform float u_speed;
uniform float u_time;

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    float pos = (texture_coords.x - u_uv[0]) / (u_uv[1] - u_uv[0]);
    vec3 col = vec3((u_time * u_speed) + pos, 1.0, 1.0);
    float alpha = texture2D(texture, texture_coords).a;

    return color * vec4(hsv2rgb(col), alpha);
}