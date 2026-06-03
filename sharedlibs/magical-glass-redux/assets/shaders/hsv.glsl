uniform float hue_shift;   // Degrees (-360 to 360)
uniform float saturation;  // -1.0 to 1.0
uniform float value;       // -1.0 to 1.0

// RGB -> HSV
vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz),
                 vec4(c.gb, K.xy),
                 step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r),
                 vec4(c.r, p.yzx),
                 step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 0.00001;

    return vec3(
        abs(q.z + (q.w - q.y) / (6.0 * d + e)),
        d / (q.x + e),
        q.x
    );
}

// HSV -> RGB
vec3 hsv2rgb(vec3 c)
{
    vec3 p = abs(fract(c.xxx + vec3(0.0, 2.0/3.0, 1.0/3.0)) * 6.0 - 3.0);
    return c.z * mix(vec3(1.0), clamp(p - 1.0, 0.0, 1.0), c.y);
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 texColor = Texel(texture, texture_coords);

    // Convert to HSV
    vec3 hsv = rgb2hsv(texColor.rgb);

    // Adjust hue (convert degrees to 0–1 range)
    hsv.x = fract(hsv.x + hue_shift / 360.0);

    // Adjust saturation
    hsv.y = clamp(hsv.y + saturation, 0.0, 1.0);

    // Adjust value (brightness)
    hsv.z = clamp(hsv.z + value, 0.0, 1.0);

    // Convert back to RGB
    texColor.rgb = hsv2rgb(hsv);

    return texColor * color;
}