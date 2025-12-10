uniform vec4 keyColor;    // The color to be made transparent (greenscreen color)
uniform float threshold;  // The tolerance for matching the key color

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 pixel = Texel(texture, texture_coords);  // Get the pixel color
    float diff = distance(pixel.rgb, keyColor.rgb);  // Measure color difference

    // If the difference between the pixel color and the key color is less than the threshold, make it transparent
    if (diff < threshold) {
        return vec4(0.0, 0.0, 0.0, 0.0);  // Transparent pixel
    } else {
        return pixel * color;  // Return the original color
    }
}