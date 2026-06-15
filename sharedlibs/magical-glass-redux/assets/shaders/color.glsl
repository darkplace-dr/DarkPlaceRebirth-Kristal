uniform vec4 targetColor;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 texcolor = Texel(texture, texture_coords);

    float threshold = 0.01;

    float mask = step(threshold, max(texcolor.r, max(texcolor.g, texcolor.b)));

    vec3 finalRGB = mix(texcolor.rgb, targetColor.rgb, mask);

    return vec4(finalRGB, texcolor.a) * color;
}