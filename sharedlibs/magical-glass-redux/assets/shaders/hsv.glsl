extern vec2 texsize;
uniform float hue_shift = 0.0; // Default hue shift
uniform float saturation = 0.0; // Default saturation adjustment
uniform float value = 0.0; // Default value adjustment

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 texColor = Texel(texture, texture_coords);
    
    // Convert to HSV
    float cMax = max(texColor.r, max(texColor.g, texColor.b));
    float cMin = min(texColor.r, min(texColor.g, texColor.b));
    float delta = cMax - cMin;
    
    float hue;
    if (delta == 0.0) {
        hue = 0.0;
    } else if (cMax == texColor.r) {
        hue = mod((texColor.g - texColor.b) / delta, 6.0);
    } else if (cMax == texColor.g) {
        hue = (texColor.b - texColor.r) / delta + 2.0;
    } else {
        hue = (texColor.r - texColor.g) / delta + 4.0;
    }
    
    hue *= 60.0;
    if (hue < 0.0) {
        hue += 360.0;
    }
    
    // Apply the hue shift
    hue = mod(hue + hue_shift, 360.0);
    
    // Convert back to RGB
    float c = delta;
    float x = c * (1.0 - abs(mod(hue / 60.0, 2.0) - 1.0));
    float m = cMax - c;
    
    if (0.0 <= hue && hue < 60.0) {
        texColor.rgb = vec3(c, x, 0.0);
    } else if (60.0 <= hue && hue < 120.0) {
        texColor.rgb = vec3(x, c, 0.0);
    } else if (120.0 <= hue && hue < 180.0) {
        texColor.rgb = vec3(0.0, c, x);
    } else if (180.0 <= hue && hue < 240.0) {
        texColor.rgb = vec3(0.0, x, c);
    } else if (240.0 <= hue && hue < 300.0) {
        texColor.rgb = vec3(x, 0.0, c);
    } else {
        texColor.rgb = vec3(c, 0.0, x);
    }
    
    texColor.rgb += vec3(m);
    
    // Apply saturation and value adjustments
    texColor.rgb = mix(vec3(0.5), texColor.rgb, saturation + 1.0); // Adjusting saturation
    texColor.rgb *= value + 1.0; // Adjusting value
    
    return texColor * color;
}
