extern float time;
extern vec2 resolution;

vec3 scanline(vec2 coord, vec3 screen)
{
    screen.rgb -= sin((coord.y + (time * 29.0))) * 0.02;
    return screen;
}

vec2 crt(vec2 coord, float bend)
{
    coord = (coord - 0.5) * 2.0;
    coord *= 1.1;

    coord.x *= 1.0 + pow((abs(coord.y) / bend), 2.0);
    coord.y *= 1.0 + pow((abs(coord.x) / bend), 2.0);

    coord = (coord / 2.0) + 0.5;
    return coord;
}

vec3 sampleSplit(vec2 coord, Image texture)
{
    vec3 frag;
    frag.r = Texel(texture, vec2(coord.x - 0.01 * sin(time), coord.y)).r;
    frag.g = Texel(texture, vec2(coord.x, coord.y)).g;
    frag.b = Texel(texture, vec2(coord.x + 0.01 * sin(time), coord.y)).b;
    return frag;
}

vec4 effect(vec4 color, Image texture, vec2 texCoord, vec2 screenCoord)
{
    vec2 crtCoords = crt(texCoord, 3.2);
    if (crtCoords.x < 0.0 || crtCoords.x > 1.0 || crtCoords.y < 0.0 || crtCoords.y > 1.0)
        return vec4(0.0);

    vec3 fragColor = sampleSplit(crtCoords, texture);
    vec2 screenSpace = crtCoords * resolution;
    fragColor = scanline(screenSpace, fragColor);

    return vec4(fragColor, 1.0);
}
