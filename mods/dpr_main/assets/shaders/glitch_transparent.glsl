extern number iTime;
extern vec2 iResolution;
extern Image iChannel0;

float rand(float seed) {
    return fract(sin(dot(vec2(seed), vec2(12.9898, 78.233))) * 43758.5453);
}

vec2 displace(vec2 co, float seed, float seed2) {
    // Apply more randomness to the displacement direction and magnitude
    vec2 shift = vec2(0);
    
    // Random values for displacement, both in positive and negative directions
    float rand1 = rand(seed);
    float rand2 = rand(seed2);
    
    // Random displacement in both directions for x and y
    shift.x = (rand1 - 0.5) * 0.2;  // Displace horizontally (both directions)
    shift.y = (rand2 - 0.5) * 0.2;  // Displace vertically (both directions)

    // Additional randomness to increase displacement magnitude in both axes
    if (rand1 > 0.5) {
        shift.x += (rand(seed * 1.3) - 0.5) * 0.3;  // Add more randomness to x
    }
    if (rand2 > 0.5) {
        shift.y += (rand(seed2 * 1.5) - 0.5) * 0.3;  // Add more randomness to y
    }
    
    return shift;
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec2 uv = texture_coords;
    vec2 rDisplace = vec2(0);
    vec2 gDisplace = vec2(0);
    vec2 bDisplace = vec2(0);
    
    // Apply displacement based on time and added randomness
    if (rand(iTime) > 0.9) {
        rDisplace = displace(uv, iTime * 2., 2. + iTime);
        gDisplace = displace(uv, iTime * 3., 3. + iTime);
        bDisplace = displace(uv, iTime * 5., 5. + iTime);
    }
    
    rDisplace.x += 0.005 * (0.5 - rand(iTime * 37. * uv.y));
    gDisplace.x += 0.007 * (0.5 - rand(iTime * 41. * uv.y));
    bDisplace.x += 0.0011 * (0.5 - rand(iTime * 53. * uv.y));

    rDisplace.y += 0.001 * (0.5 - rand(iTime * 37. * uv.x));
    gDisplace.y += 0.001 * (0.5 - rand(iTime * 41. * uv.x));
    bDisplace.y += 0.001 * (0.5 - rand(iTime * 53. * uv.x));
    
    // Sample the texture using displaced coordinates for RGB channels
    float rcolor = Texel(texture, uv + rDisplace).r;
    float gcolor = Texel(texture, uv + gDisplace).g;
    float bcolor = Texel(texture, uv + bDisplace).b;

    // Check if the texture pixel is fully transparent (alpha check)
    vec4 texColor = vec4(rcolor, gcolor, bcolor, 1.0);

    // If the texture color has very low RGB and alpha is 0, set to fully transparent
    texColor.a = (texColor.r < 0.01 && texColor.g < 0.01 && texColor.b < 0.01) ? 0.0 : 1.0;

    // If alpha is 0 (fully transparent), we don't modify the color; otherwise, apply the texture color
    return texColor.a == 0.0 ? texColor : texColor * color;
}
