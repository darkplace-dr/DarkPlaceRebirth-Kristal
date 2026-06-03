extern Image tex;

vec4 effect(vec4 color, Image texture, vec2 uv, vec2 screen_coords)
{
    vec2 pixel = vec2(1.0/320.0, 1.0/240.0);

    vec4 base = Texel(texture, uv);

    float glow = 0.0;
    vec3 glowColor = vec3(0.0);

    for (int x = -4; x <= 4; x++)
    {
        for (int y = -4; y <= 4; y++)
        {
            vec2 offset = vec2(float(x), float(y)) * pixel * 2.0; // half-res step
            vec3 sampleCol = Texel(texture, uv + offset).rgb;

            float brightness = max(sampleCol.r, max(sampleCol.g, sampleCol.b));

            // neon threshold
            float neon = smoothstep(0.7, 1.0, brightness);

            float weight = 1.0 - length(vec2(x,y)) / 6.0;
            weight = max(weight, 0.0);

            glow += neon * weight;
            glowColor += sampleCol * neon * weight;
        }
    }

    glow /= 25.0;
    glowColor /= 25.0;

    vec3 result = base.rgb + glowColor * glow;

    return vec4(result, base.a) * color;
}